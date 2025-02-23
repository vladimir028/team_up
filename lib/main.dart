import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:team_up/firebase_options.dart';
import 'package:team_up/presentation/pages/auth/login_page.dart';
import 'package:team_up/presentation/pages/auth/register_page.dart';
import 'package:team_up/presentation/pages/sport_event/create_sport_event_page.dart';
import 'package:team_up/presentation/pages/overview/account/account_navigation.dart';
import 'package:team_up/presentation/pages/overview/onboards/onboard_navigation.dart';
import 'package:team_up/presentation/pages/sport_event/home_page.dart';

import 'package:team_up/presentation/pages/sport_event/sport_detail.dart';
import 'package:team_up/presentation/pages/sport_event/wrapper/my_upcoming_sport_events_page.dart';
import 'package:team_up/presentation/pages/sport_event/wrapper/my_wishlist_page.dart';
import 'package:team_up/presentation/widgets/map_picker.dart';
import 'package:team_up/provider/sport_form_provider.dart';
import 'package:team_up/service/notification_service.dart';
import 'package:toastification/toastification.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 3));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SportFormProvider(),
      child: ToastificationWrapper(
        child: MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Team Up',
          theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
          initialRoute: '/',
          routes: {
            '/': (context) => const OnboardNavigation(),
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),
            '/account_overview': (context) => const AccountNavigation(),
            '/home': (context) => const HomePage(),
            '/upcoming_events': (context) => const MyUpcomingSportEventsPage(),
            '/my_wishlist': (context) => const MyWishlistPage(),
            '/sport_create': (context) => const SportForm(),
            '/map_picker': (context) => const MapPicker(),
            '/sport_detail': (context) => const SportDetailPage(),
          },
        ),
      ),
    );
  }
}
