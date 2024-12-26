import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../global/toast.dart';
import '../styles/my_colors.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String username, String email,
      String password, String confirmPassword) async {
    if (!passwordAndConfirmPasswordMatch(password, confirmPassword)) {
      Toast toast = Toast(
          ToastificationType.error,
          "Invalid input",
          "Password and Confirm Password do not match",
          Icons.dangerous_outlined,
          MyColors.support.error);
      toast.showToast();
    }
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

  Future<void> logoff() async {
    await _auth.signOut();
    Toast toast = Toast(
        ToastificationType.success,
        "User logged out successfully",
        "Welcome to home page",
        Icons.check,
        MyColors.support.success);
    toast.showToast();
  }

  bool passwordAndConfirmPasswordMatch(
      String password, String confirmPassword) {
    return password.compareTo(confirmPassword) == 0;
  }
}
