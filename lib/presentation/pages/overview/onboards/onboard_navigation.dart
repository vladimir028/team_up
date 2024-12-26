import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:team_up/data/onboard/strings.dart';

import '../../../../styles/my_colors.dart';
import 'onboard_layout.dart';

class OnboardNavigation extends StatefulWidget {
  const OnboardNavigation({super.key});

  @override
  State<OnboardNavigation> createState() => _OnboardNavigationState();
}

class _OnboardNavigationState extends State<OnboardNavigation> {
  final PageController _pageController = PageController();

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
                heading: Strings.firstOnBoardPageStrings.heading,
                description: Strings.firstOnBoardPageStrings.description,
                indexToStart: Strings.firstOnBoardPageStrings.indexToStart,
                onTap: () => _navigateToNextPage(1),
              ),
              HomePageLayout(
                heading: Strings.secondOnBoardPageStrings.heading,
                description: Strings.secondOnBoardPageStrings.description,
                indexToStart: Strings.secondOnBoardPageStrings.indexToStart,
                onTap: () => _navigateToNextPage(2),
              ),
              HomePageLayout(
                heading: Strings.thirdOnBoardPageStrings.heading,
                description: Strings.thirdOnBoardPageStrings.description,
                indexToStart: Strings.thirdOnBoardPageStrings.indexToStart,
                onTap: () => print('Onboarding complete'),
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
    _pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
