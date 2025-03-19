import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> imageUrls;

  const ImageCarousel({super.key, required this.imageUrls});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int _currentIndex = 0;
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // CarouselView
          Expanded(
            child: CarouselView(
              controller: _carouselController,
              itemExtent: constraints.maxWidth, // Width of each item
              itemSnapping: true,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: widget.imageUrls.map((imageUrl) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Text('Failed to load image'),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          // Dots Indicator
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.imageUrls.asMap().entries.map((entry) {
              int index = entry.key;
              return GestureDetector(
                onTap: () => _carouselController.animateTo(
                    index * constraints.maxWidth,
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOut),
                child: Container(
                  width: _currentIndex == index ? 12.0 : 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index
                        ? Colors.blue
                        : Colors.grey.withOpacity(0.5),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      );
    });
  }
}
