import 'package:flutter/material.dart';

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
  final TextEditingController _usernameController = TextEditingController();

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
            const SizedBox(height: 30),
            const NavigationRoutes(
              descriptionButton: "Sign Up",
              routeButton: "/login",
              descriptionRegular: "Already have an account? ",
              descriptionBold: "Login",
              descriptionRoute: "/login",
            ),
          ],
        ),
      ),
    );
  }
}
