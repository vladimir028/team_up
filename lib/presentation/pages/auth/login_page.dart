import 'package:flutter/material.dart';

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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

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
              'Welcome Back!',
              style: TextStyle(
                  color: MyColors.tertiary.purple900,
                  fontSize: MyFontSizes.titleXLarge,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Use Credentials to access your account',
              style: TextStyle(
                  color: MyColors.tertiary.purple800,
                  fontSize: MyFontSizes.titleBase,
                  fontWeight: FontWeight.normal),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            InputField(
                controller: _emailController,
                hintText: "Enter Email",
                isPasswordField: false),
            const SizedBox(height: 20),
            InputField(
                controller: _passwordController,
                hintText: "Enter Password",
                isPasswordField: true),
            const SizedBox(height: 30),
            const NavigationRoutes(
              descriptionButton: "Login",
              routeButton: "/itineraries",
              descriptionRegular: "Don't have an account? ",
              descriptionBold: "Sign up",
              descriptionRoute: "/register",
            ),
          ],
        ),
      ),
    );
  }
}
