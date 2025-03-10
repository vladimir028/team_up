import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:team_up/models/custom_user.dart';
import 'package:team_up/data/account/sport_selection/sport.dart';
import 'package:team_up/repository/auth_repository.dart';

class AuthService {
  final AuthRepository _authRepository = AuthRepository();

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    return await _authRepository.signUpWithEmailAndPassword(email, password);
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    return await _authRepository.signInWithEmailAndPassword(email, password);
  }

  Future<CustomUser?> addAdditionalInfoForUser(String id, String username,
      List<Sport> favSports, File selectedImage) async {
    return await _authRepository.addAdditionalInfoForUser(
        id, username, favSports, selectedImage);
  }

  User getCurrentUser(){
    return _authRepository.getCurrentUser();
  }

  Future<void> logoff(BuildContext context) {
    return _authRepository.logoff(context);
  }

  Future<User?> signInWithGoogle() async {
    return await _authRepository.signInWithGoogle();
  }

  Future<void> signOutGoogle() async {
    await _authRepository.signOutGoogle();
  }

}
