import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:team_up/service/auth_service.dart';
import 'package:toastification/toastification.dart';

import '../../../global/toast.dart';
import '../../../styles/my_colors.dart';
import '../../../styles/my_font_sizes.dart';
import '../../widgets/input_field.dart';
import '../../widgets/navigation_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  AuthService authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60), // Added spacing for better layout
              Image.asset(
                'lib/data/images/logo.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 20), // Spacing between logo and text
              Text(
                'Welcome Back!',
                style: TextStyle(
                  color: MyColors.tertiary.purple900,
                  fontSize: MyFontSizes.titleXLarge,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Use Credentials to access your account',
                style: TextStyle(
                  color: MyColors.tertiary.purple800,
                  fontSize: MyFontSizes.titleBase,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              InputField(
                controller: _emailController,
                hintText: "Enter Email",
                isPasswordField: false,
              ),
              const SizedBox(height: 20),
              InputField(
                controller: _passwordController,
                hintText: "Enter Password",
                isPasswordField: true,
              ),
              const SizedBox(height: 30),
              NavigationRoutes(
                descriptionButton: "Login",
                routeButton: "/itineraries",
                descriptionRegular: "Don't have an account? ",
                descriptionBold: "Sign up",
                descriptionRoute: "/register",
                onTap: _signIn,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signInWithGoogle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/data/images/google-logo.png',
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signInWithGoogle() async {
    User? user = await authService.signInWithGoogle();

    if (user != null && mounted) {
      Toast toast = Toast(
        ToastificationType.success,
        "User logged in successfully!",
        "Welcome!",
        Icons.check,
        MyColors.support.success,
      );
      toast.showToast();
      Navigator.pushNamed(context, "/home");
    }
  }
  void _signIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text;

    User? user = await authService.signInWithEmailAndPassword(email, password);

    if (user != null && mounted) {
      Toast toast = Toast(
        ToastificationType.success,
        "User logged in successfully!",
        "Welcome!",
        Icons.check,
        MyColors.support.success,
      );
      toast.showToast();
      Navigator.pushNamed(context, "/home");
    }
  }
}
