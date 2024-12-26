import 'package:flutter/material.dart';

class MyColors {
  static var primary = _PrimaryColors();
  static var secondary = _SecondaryColors();
  static var tertiary = _TertiaryColors();
  static var support = _SupportColors();

  static const dark = Color(0xFF25131A);
  static const light = Color(0xFFD9E1E1);
  static const gray = Color(0xFFD9E1E1);
  static const white = Color(0xFFD9E1E1);
  static const whiteButtons = Color(0xFFFFFFFF);
}

class _PrimaryColors {
  final pink900 = const Color(0xFF810A37);
  final pink800 = const Color(0xFFA60341);
  final pink700 = const Color(0xFFC90851);
  final pink600 = const Color(0xFFE10A5C);
  final pink500 = const Color(0xFFFB0160);
  final pink400 = const Color(0xFFEC367B);
  final pink300 = const Color(0xFFEA8AAE);
  final pink200 = const Color(0xFFF2BED2);
  final pink100 = const Color(0xFFF9DCE7);
}

class _SecondaryColors {
  final green900 = const Color(0xFF626615);
  final green800 = const Color(0xFF798D21);
  final green700 = const Color(0xFF88A52A);
  final green600 = const Color(0xFF97BD33);
  final green500 = const Color(0xFFA3D139);
  final green400 = const Color(0xFFAFD751);
  final green300 = const Color(0xFFBCDE6B);
  final green200 = const Color(0xFFCEE993);
  final green100 = const Color(0xFFE1F1BC);
}

class _TertiaryColors {
  final purple900 = const Color(0xFF22142F);
  final purple800 = const Color(0xFF43275E);
  final purple700 = const Color(0xFF653B8C);
  final purple600 = const Color(0xFF864EBB);
  final purple500 = const Color(0xFFA862EA);
  final purple400 = const Color(0xFFB981EE);
  final purple300 = const Color(0xFFCBA1F2);
  final purple200 = const Color(0xFFDCC0F7);
  final purple100 = const Color(0xFFEEE0FB);
}

class _SupportColors {
  final error = const Color(0xFFFA4D56);
  final success = const Color(0xFF42BE65);
  final warning = const Color(0xFFF1C21B);
  final info = const Color(0xFF4589FF);
}
