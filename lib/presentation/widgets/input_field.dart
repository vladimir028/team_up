import 'package:flutter/material.dart';

import '../../styles/my_colors.dart';

class InputField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final bool? isPasswordField;
  final bool? isDateField;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;

  const InputField({
    super.key,
    this.controller,
    this.hintText,
    this.isPasswordField,
    this.isDateField,
    this.keyboardType,
    this.onTap,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: widget.hintText,
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: MyColors.dark,
            width: 2.0,
            style: BorderStyle.solid,
          ),
        ),
        suffixIcon: widget.isPasswordField == true
            ? IconButton(
          icon: Icon(
            _isPasswordVisible
                ? Icons.visibility
                : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        )
            : const Icon(Icons.email),
      ),
      controller: widget.controller,
      obscureText: widget.isPasswordField == true && !_isPasswordVisible,
      readOnly: widget.isDateField ?? false,
      keyboardType: widget.keyboardType,
      onTap: widget.onTap,
    );
  }
}
