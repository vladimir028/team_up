import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:team_up/presentation/widgets/image_picker.dart';

class SecondAccountPageWidget {
  final String header = "Choose your photo profile";
  final String description = "Photo profile can be changed at any time";

  Widget getContent() {
    return const PickImage();
  }
}