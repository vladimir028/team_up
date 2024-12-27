import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../data/account/account_overview.dart';
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

  @override
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

  void _navigateToNextPage(int nextPage) {
    if (nextPage == thirdPage) {
      Navigator.pushNamed(context, "/home");
      return;
    }
    _pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
