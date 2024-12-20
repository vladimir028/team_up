import 'package:flutter/material.dart';
import 'package:team_up/presentation/pages/auth/login_page.dart';
import 'package:team_up/presentation/pages/auth/register_page.dart';
import 'package:team_up/presentation/pages/home_page.dart';
import 'package:team_up/presentation/pages/overview/account/choose_photo.dart';
import 'package:team_up/presentation/pages/overview/account/choose_sport.dart';
import 'package:team_up/presentation/pages/overview/account/create_username.dart';
import 'package:team_up/presentation/pages/overview/onboards/splash_page.dart';
import 'package:team_up/presentation/pages/sport_detail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Team Up',
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/create_username': (context) => const CreateUsernamePage(),
        '/choose_profile_picture': (context) => const ChoosePhotoPage(),
        '/choose_favorite_sport': (context) => const ChooseSportPage(),
        '/home': (context) => const HomePage(),
        '/sport_detail': (context) => const SportDetailPage(),
      },
    );
  }
}
