import 'package:firebase_auth/firebase_auth.dart';
import 'package:team_up/repository/auth_repository.dart';

class AuthService {
  final AuthRepository _authRepository = AuthRepository();

  Future<User?> signUpWithEmailAndPassword(String username, String email,
      String password, String confirmPassword) async {
    return await _authRepository.signUpWithEmailAndPassword(
        username, email, password, confirmPassword);
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    return await _authRepository.signInWithEmailAndPassword(email, password);
  }
}
