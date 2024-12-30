import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:team_up/global/image.dart';
import 'package:team_up/global/user_registration_details.dart';
import 'package:team_up/models/custom_user.dart';
import 'package:team_up/service/auth_service.dart';
import 'package:toastification/toastification.dart';

import '../../../../data/account/account_overview.dart';
import '../../../../global/toast.dart';
import '../../../../models/sport.dart';
import '../../../../styles/my_colors.dart';
import 'account_page_layout.dart';

class AccountNavigation extends StatefulWidget {
  const AccountNavigation({super.key});

  @override
  State<AccountNavigation> createState() => _AccountNavigationState();
}

class _AccountNavigationState extends State<AccountNavigation> {
  final PageController _pageController = PageController();
  static int firstPage = 1;
  static int secondPage = 2;
  static int thirdPage = 3;

  String _email = "";
  String _password = "";

  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    _email = UserStore.email ?? "";
    _password = UserStore.password ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: SmoothPageIndicator(
              controller: _pageController,
              count: 3,
              effect: ExpandingDotsEffect(
                dotWidth: 60,
                activeDotColor: MyColors.dark,
                dotColor: MyColors.primary.pink100,
              ),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                AccountPageLayout(
                  controller: _pageController,
                  onTap: () => _navigateToNextPage(firstPage),
                  header: AccountOverview.firstAccountPageWidget.header,
                  description:
                      AccountOverview.firstAccountPageWidget.description,
                  content: AccountOverview.firstAccountPageWidget.getContent(),
                ),
                AccountPageLayout(
                  controller: _pageController,
                  onTap: () => _navigateToNextPage(secondPage),
                  header: AccountOverview.secondAccountPageWidget.header,
                  description:
                      AccountOverview.secondAccountPageWidget.description,
                  content: AccountOverview.secondAccountPageWidget.getContent(),
                ),
                AccountPageLayout(
                  controller: _pageController,
                  onTap: () => _navigateToNextPage(thirdPage),
                  header: AccountOverview.thirdAccountPageWidget.header,
                  description:
                      AccountOverview.thirdAccountPageWidget.description,
                  content: AccountOverview.thirdAccountPageWidget.getContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToNextPage(int nextPage) async {
    if (nextPage == thirdPage) {
      await _handleSignUp();
      return;
    }
    _animateToNextPage(nextPage);
  }

  void _animateToNextPage(int nextPage) {
    _pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _handleSignUp() async {
    final String email = _email;
    final String password = _password;

    final String username =
        AccountOverview.firstAccountPageWidget.usernameController.text;
    final List<Sport> favSports = UserStore.favoriteSports!;
    final File selectedImage = ImageStore.selectedImage!;

    final User? user = await authService.signUpWithEmailAndPassword(
      email,
      password,
    );

    if (user == null) return;

    final CustomUser? customUser = await authService.addAdditionalInfoForUser(
      user.uid,
      username,
      favSports,
      selectedImage,
    );

    if (customUser != null && mounted) {
      showMessage();
      resetStores();
      Navigator.pushNamed(context, "/login");
    }
  }

  void resetStores() {
    UserStore.resetFields();
    ImageStore.resetFields();
    AccountOverview.firstAccountPageWidget.usernameController =
        TextEditingController();
  }

  void showMessage() {
    Toast toast = Toast(
        ToastificationType.success,
        "Account created successfully!",
        "You can now log in!",
        Icons.check,
        MyColors.support.success);
    toast.showToast();
  }
}
