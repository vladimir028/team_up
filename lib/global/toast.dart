import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../styles/my_colors.dart';

class Toast {
  ToastificationType? type;
  String? text;
  String? description;
  IconData? iconData;
  Color? primaryColor;

  Toast(
      this.type, this.text, this.description, this.iconData, this.primaryColor);

  void showToast() {
    toastification.show(
      type: type,
      style: ToastificationStyle.flatColored,
      autoCloseDuration: const Duration(seconds: 5),
      title: Text(
        text!,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      description: Text(
        description!,
        style: const TextStyle(color: MyColors.dark),
      ),
      alignment: Alignment.bottomCenter,
      direction: TextDirection.ltr,
      icon: Icon(iconData),
      showIcon: true,
      primaryColor: primaryColor,
      foregroundColor: MyColors.dark,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: MyColors.dark,
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
    );
  }
}
