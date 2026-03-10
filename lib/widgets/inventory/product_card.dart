import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../models/inventory/product_model.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final Color kDeepGreen;
  final VoidCallback onRefresh;

  const ProductCard({
    super.key,
    required this.product,
    required this.kDeepGreen,
    required this.onRefresh
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final PageController _pageController = PageController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Auto-slide logic
    if (widget.product.images.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (_pageController.hasClients) {
          int next = (_pageController.page!.toInt() + 1) % widget.product.images.length;
          _pageController.animateToPage(
            next,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Critical: prevent memory leaks
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      clipBehavior: Clip.antiAlias, // Ensures images respect the rounded corners
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sliding Image Area
          SizedBox(
            height: 220,
            width: double.infinity,
            child: widget.product.images.isEmpty
                ? const Center(child: Icon(Icons.image_not_supported, size: 60, color: Colors.grey))
                : Stack(
              alignment: Alignment.bottomCenter,
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: widget.product.images.length,
                  itemBuilder: (context, index) {
                    return CachedNetworkImage(
                      imageUrl: widget.product.images[index].image,
                      fit: BoxFit.cover, // Ensures the image fills the box
                      width: double.infinity,
                      placeholder: (ctx, url) => const Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
                if (widget.product.images.length > 1)
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: widget.product.images.length,
                      effect: WormEffect(
                        activeDotColor: widget.kDeepGreen,
                        dotColor: Colors.white.withOpacity(0.5),
                        dotHeight: 8,
                        dotWidth: 8,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Content remains the same...
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.product.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text("SKU: ${widget.product.sku} | Price: \$${widget.product.unitPrice}",
                    style: TextStyle(color: Colors.grey[700])),
                const SizedBox(height: 8),
                Text(widget.product.description, maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}