import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:team_up/styles/my_colors.dart';
import '../../../../styles/my_font_sizes.dart';

class HomePageLayout extends StatefulWidget {
  final String heading;
  final String description;
  final int indexToStart;
  final VoidCallback onTap;

  const HomePageLayout({
    super.key,
    required this.heading,
    required this.description,
    required this.onTap,
    required this.indexToStart,
  });

  @override
  State<HomePageLayout> createState() => _HomePageLayoutState();
}

class _HomePageLayoutState extends State<HomePageLayout> {
  List<ImageProvider> imageProviders = [];
  bool imagesLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _preloadImages();
  }

  Future<void> _preloadImages() async {
    // Avoid reloading if already loaded
    if (imagesLoaded) return;

    List<ImageProvider> loadedImages = [];

    for (int i = 0; i < 6; i++) {
      String imagePath = 'lib/data/images/image${widget.indexToStart + i}.jpg';
      AssetImage assetImage = AssetImage(imagePath);

      // Preload image before adding it
      await precacheImage(assetImage, context);

      loadedImages.add(assetImage);
    }

    if (mounted) {
      setState(() {
        imageProviders = loadedImages;
        imagesLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: imagesLoaded
          ? SingleChildScrollView(
        child: Column(
          children: [
            MasonryGridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: imageProviders.length,
              gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(3.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image(image: imageProviders[index]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  Text(
                    widget.heading,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: MyFontSizes.titleXLarge,
                      fontWeight: FontWeight.bold,
                      color: MyColors.dark,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    widget.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: MyFontSizes.titleBase,
                      color: MyColors.dark,
                    ),
                  ),
                  const SizedBox(height: 30),
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
                      child: const Text('Next',
                          style: TextStyle(
                              fontSize: MyFontSizes.titleMedium,
                              color: MyColors.whiteButtons)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
          : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}