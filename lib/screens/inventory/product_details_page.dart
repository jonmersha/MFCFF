import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../models/inventory/product_model.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final PageController _controller = PageController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Start auto-slide if there are multiple images
    if (widget.product.images.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
        if (_controller.hasClients) {
          int next = (_controller.page!.toInt() + 1) % widget.product.images.length;
          _controller.animateToPage(
            next,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOutCubic, // Professional smooth transition
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Prevent memory leaks
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product.name)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isLandscape = constraints.maxWidth > 800;

          // Landscape: Split-screen (Image right, Details left)
          // Portrait: Stacked
          return isLandscape
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: _buildDetailsSection(),
                ),
              ),
              Expanded(flex: 3, child: _buildHeroSection()),
            ],
          )
              : SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 400, child: _buildHeroSection()),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: _buildDetailsSection(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      color: Colors.black, // Dark frame for professional look
      child: widget.product.images.isEmpty
          ? const Center(
          child: Icon(Icons.image_not_supported, size: 100, color: Colors.white54))
          : Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.product.images.length,
            itemBuilder: (context, index) => CachedNetworkImage(
              imageUrl: widget.product.images[index].image,
              fit: BoxFit.cover, // Ensures full coverage
            ),
          ),
          if (widget.product.images.length > 1)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SmoothPageIndicator(
                controller: _controller,
                count: widget.product.images.length,
                effect: const WormEffect(
                  activeDotColor: Colors.white,
                  dotColor: Colors.white30,
                  dotHeight: 10,
                  dotWidth: 10,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.product.name,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Text("SKU: ${widget.product.sku}",
            style: TextStyle(color: Colors.grey[600], fontSize: 18)),
        const SizedBox(height: 40),
        const Text("Description",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Text(
            widget.product.description.isEmpty
                ? "No description provided."
                : widget.product.description,
            style: const TextStyle(fontSize: 16, height: 1.6)),
        const SizedBox(height: 40),
        const Text("Specifications",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildInfoRow("Barcode", widget.product.barcode),
        _buildInfoRow("Price", "\$${widget.product.unitPrice}"),
        _buildInfoRow("UoM", widget.product.unitOfMeasure),
        _buildInfoRow("Status", widget.product.status.toUpperCase()),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          Text(value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}