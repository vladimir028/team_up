import 'package:flutter/material.dart';

import '../../../../styles/my_colors.dart';
import '../../../../styles/my_font_sizes.dart';

class AccountPageLayout extends StatefulWidget {
  final PageController controller;
  final VoidCallback onTap;
  final String header;
  final String description;
  final Widget content;

  const AccountPageLayout(
      {super.key,
      required this.controller,
      required this.onTap,
      required this.header,
      required this.description,
      required this.content});

  @override
  State<AccountPageLayout> createState() => _AccountPageLayoutState();
}

class _AccountPageLayoutState extends State<AccountPageLayout> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.header,
                style: TextStyle(
                  color: MyColors.tertiary.purple900,
                  fontSize: MyFontSizes.titleXLarge,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20),
              Text(
                widget.description,
                style: TextStyle(
                  color: MyColors.tertiary.purple900,
                  fontSize: MyFontSizes.titleBase,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 30),
              Expanded(
                child: widget.content,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.primary.pink500,
                    shadowColor: MyColors.dark,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: MyFontSizes.titleMedium,
                      color: MyColors.whiteButtons,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
