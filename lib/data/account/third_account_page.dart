import 'package:flutter/material.dart';

import '../../presentation/widgets/sport_icons.dart';

class ThirdAccountPageWidget {
  final String header = "Choose your favorite sport event";
  final String description =
      "So we can suggest places where you can play them!";

  Widget getContent() {
    return const SportIcons();
  }
}
