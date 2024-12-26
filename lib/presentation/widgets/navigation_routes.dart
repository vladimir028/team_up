import 'package:flutter/material.dart';

import '../../styles/my_colors.dart';
import '../../styles/my_font_sizes.dart';

class NavigationRoutes extends StatelessWidget {
  final String descriptionButton;
  final String routeButton;
  final String descriptionRegular;
  final String descriptionBold;
  final String descriptionRoute;
  final VoidCallback? onTap;

  const NavigationRoutes(
      {super.key,
      required this.descriptionButton,
      required this.routeButton,
      required this.descriptionRegular,
      required this.descriptionBold,
      required this.descriptionRoute,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (onTap != null) {
                onTap!();
              } else {
                Navigator.pushNamed(context, routeButton);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.primary.pink500,
              shadowColor: MyColors.dark,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                  color: MyColors.dark,
                  width: 2.0,
                ),
              ),
            ),
            child: Text(
              descriptionButton,
              style: const TextStyle(
                  fontSize: MyFontSizes.titleMedium,
                  color: MyColors.white),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
            onPressed: () {
              Navigator.pushNamed(context, descriptionRoute);
            },
            child: RichText(
              text: TextSpan(
                text: descriptionRegular,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: MyColors.dark,
                    ),
                children: [
                  TextSpan(
                    text: descriptionBold,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: MyColors.primary.pink300,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
