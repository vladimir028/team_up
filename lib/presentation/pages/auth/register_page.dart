import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:team_up/service/auth_service.dart';
import 'package:toastification/toastification.dart';

import '../../../global/toast.dart';
import '../../../styles/my_colors.dart';
import '../../../styles/my_font_sizes.dart';
import '../../widgets/input_field.dart';
import '../../widgets/navigation_routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'lib/data/images/logo.png',
              width: 150,
              height: 150,
            ),
            Text(
              'Create an Account',
              style: TextStyle(
                  color: MyColors.tertiary.purple900,
                  fontSize: MyFontSizes.titleXLarge,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Please fill this detail to create an account',
              style: TextStyle(
                  color: MyColors.tertiary.purple800,
                  fontSize: MyFontSizes.titleBase,
                  fontWeight: FontWeight.normal),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            InputField(
                controller: _usernameController,
                hintText: "Enter Username",
                isPasswordField: false),
            const SizedBox(height: 20),
            InputField(
                controller: _emailController,
                hintText: "Enter email",
                isPasswordField: false),
            const SizedBox(height: 20),
            InputField(
                controller: _passwordController,
                hintText: "Enter Password",
                isPasswordField: true),
            const SizedBox(height: 20),
            InputField(
                controller: _confirmPasswordController,
                hintText: "Confirm Password",
                isPasswordField: true),
            const SizedBox(height: 30),
            NavigationRoutes(
              descriptionButton: "Sign Up",
              routeButton: "/login",
              descriptionRegular: "Already have an account? ",
              descriptionBold: "Login",
              descriptionRoute: "/login",
              onTap: _signUp,
            ),
          ],
        ),
      ),
    );
  }

  void _signUp() async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    User? user = await authService.signUpWithEmailAndPassword(
        username, email, password, confirmPassword);

    if (user != null && mounted) {
      Toast toast = Toast(
          ToastificationType.success,
          "User created successfully!",
          "You can now log in",
          Icons.check,
          MyColors.support.success);
      toast.showToast();
      Navigator.pushNamed(context, "/account_overview");
    }
  }
}
