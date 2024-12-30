import 'package:team_up/data/account/sport_selection/sport.dart';

import 'image.dart';

class UserStore {
  static String? username;
  static String? email;
  static String? password;
  static String? confirmPassword;
  static ImageStore? imageStore;
  static List<Sport>? favoriteSports;

  static void resetFields() {
    username = "";
    email = "";
    password = "";
    confirmPassword  = "";
    imageStore = ImageStore();
    favoriteSports = [];
  }
}