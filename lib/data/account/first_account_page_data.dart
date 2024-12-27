import 'package:flutter/material.dart';

import '../../presentation/widgets/input_field.dart';

class FirstAccountPageWidget {
  final String header = "Create Username!";
  final String description = "Username can be changed at any time";
  TextEditingController emailController = TextEditingController();

  Widget getContent() {
    return InputField(
        controller: emailController,
        hintText: "Enter Username",
        isPasswordField: false);
  }
}