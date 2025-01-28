import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:team_up/models/custom_user.dart';
import 'package:team_up/data/account/sport_selection/sport.dart';
import 'package:team_up/presentation/pages/auth/login_page.dart';
import 'package:toastification/toastification.dart';

import '../global/toast.dart';
import '../styles/my_colors.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      Toast toast;
      if (e.code == 'invalid-email') {
        toast = Toast(
            ToastificationType.warning,
            "Email address is not valid",
            "Please enter a correct email address",
            Icons.warning_amber_outlined,
            MyColors.support.warning);
      } else if (e.code == 'email-already-in-use') {
        toast = Toast(
            ToastificationType.warning,
            "Invalid input",
            "Email is already in use",
            Icons.warning_amber_outlined,
            MyColors.support.warning);
      } else if (e.code == 'weak-password') {
        toast = Toast(
            ToastificationType.warning,
            "Weak Password",
            "Enter a password with a minimum of 6 characters",
            Icons.warning_amber_outlined,
            MyColors.support.warning);
      } else {
        toast = Toast(
            ToastificationType.error,
            "Invalid input",
            "An error occurred",
            Icons.dangerous_outlined,
            MyColors.support.error);
      }
      toast.showToast();
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      Toast toast;
      if (e.code == 'invalid-email') {
        toast = Toast(
            ToastificationType.warning,
            "Email address is not valid",
            "Please enter a correct email address",
            Icons.warning_amber_outlined,
            MyColors.support.warning);
      } else if (e.code == 'wrong-password') {
        toast = Toast(
            ToastificationType.error,
            "Wrong password",
            "Please enter the correct password",
            Icons.dangerous_outlined,
            MyColors.support.error);
      } else if (e.code == 'invalid-credential') {
        toast = Toast(ToastificationType.error, "Invalid Credentials",
            "User not found", Icons.dangerous_outlined, MyColors.support.error);
      } else {
        toast = Toast(
            ToastificationType.error,
            "Invalid input",
            "An error occurred",
            Icons.dangerous_outlined,
            MyColors.support.error);
      }
      toast.showToast();
    }
    return null;
  }

  User getCurrentUser() {
    return _auth.currentUser!;
  }

  Future<void> logoff(BuildContext context) async {
    await _auth.signOut();
    Toast toast = Toast(
        ToastificationType.success,
        "User logged out successfully",
        "Welcome to Login Screen",
        Icons.check,
        MyColors.support.success);
    toast.showToast();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginPage()),(route) => false);

  }

  bool passwordAndConfirmPasswordMatch(
      String password, String confirmPassword) {
    return password.compareTo(confirmPassword) == 0;
  }

  Future<CustomUser?> addAdditionalInfoForUser(String id, String username,
      List<Sport> favSports, File selectedImage) async {
    Map<String, int> sportMap = getSportMap(favSports);
    String imageUrlFromFirebase =
        await getPhotoAsStringFromFirebaseStorage(selectedImage);

    CustomUser customUser = CustomUser(
        id: id,
        username: username,
        profilePicture: imageUrlFromFirebase,
        favoriteSportWithLevel: sportMap);

    final createdUser = customUser.toJson();

    try {
      final collection = firebaseFirestore.collection("customUser");
      String id = collection.doc().id;

      await collection.doc(id).set(createdUser);
      return customUser;
    } catch (e) {
      Toast toast = Toast(ToastificationType.error, "An error occurred",
          e.toString(), Icons.dangerous_outlined, MyColors.support.error);
      toast.showToast();
    }

    return null;
  }

  Future<String> getPhotoAsStringFromFirebaseStorage(File selectedImage) async {
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('profile_pictures');
    Reference referenceImageToUpload =
        referenceDirImages.child(selectedImage.path);

    await referenceImageToUpload.putFile(selectedImage);
    return await referenceImageToUpload.getDownloadURL();
  }

  Map<String, int> getSportMap(List<Sport> favSports) {
    Map<String, int> tmp = HashMap();
    int a = 5;
    for (var sport in favSports) {
      tmp.putIfAbsent(sport.name, () => a);
    }

    return tmp;
  }
}
