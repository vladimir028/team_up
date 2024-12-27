import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:team_up/data/onboard/onboard_data.dart';

import '../../../../styles/my_colors.dart';
import 'onboard_layout.dart';

class OnboardNavigation extends StatefulWidget {
  const OnboardNavigation({super.key});

  @override
  State<OnboardNavigation> createState() => _OnboardNavigationState();
}

class _OnboardNavigationState extends State<OnboardNavigation> {
  final PageController _pageController = PageController();
  static int firstPage = 1;
  static int secondPage = 2;
  static int thirdPage = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            controller: _pageController,
            children: [
              HomePageLayout(
                heading: OnboardData.firstOnBoardPageStrings.heading,
                description: OnboardData.firstOnBoardPageStrings.description,
                indexToStart: OnboardData.firstOnBoardPageStrings.indexToStart,
                onTap: () => _navigateToNextPage(firstPage),
              ),
              HomePageLayout(
                heading: OnboardData.secondOnBoardPageStrings.heading,
                description: OnboardData.secondOnBoardPageStrings.description,
                indexToStart: OnboardData.secondOnBoardPageStrings.indexToStart,
                onTap: () => _navigateToNextPage(secondPage),
              ),
              HomePageLayout(
                heading: OnboardData.thirdOnBoardPageStrings.heading,
                description: OnboardData.thirdOnBoardPageStrings.description,
                indexToStart: OnboardData.thirdOnBoardPageStrings.indexToStart,
                onTap: () => _navigateToNextPage(thirdPage),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: SmoothPageIndicator(
              controller: _pageController,
              count: 3,
              effect: SwapEffect(
                  activeDotColor: MyColors.dark,
                  dotColor: MyColors.primary.pink100),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToNextPage(int nextPage) {
    if (nextPage == thirdPage) {
      Navigator.pushNamed(context, "/login");
      return;
    }
    _pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
