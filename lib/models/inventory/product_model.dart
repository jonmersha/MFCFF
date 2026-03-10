class ProductImage {
  final int id;
  final String image;

  ProductImage({
    required this.id,
    required this.image,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "image": image,
    };
  }
}

class Product {
  final int id;
  final String tracker;
  final String name;
  final String sku;
  final String barcode;
  final String description;
  final double unitPrice;
  final String unitOfMeasure;
  final int minStockLevel;
  final String status;
  final int company;
  final String companyName;
  final List<ProductImage> images;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.tracker,
    required this.name,
    required this.sku,
    required this.barcode,
    required this.description,
    required this.unitPrice,
    required this.unitOfMeasure,
    required this.minStockLevel,
    required this.status,
    required this.company,
    required this.companyName,
    required this.images,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      tracker: json['tracker'],
      name: json['name'],
      sku: json['sku'],
      barcode: json['barcode'],
      description: json['description'],
      unitPrice: double.parse(json['unit_price'].toString()),
      unitOfMeasure: json['unit_of_measure'],
      minStockLevel: json['min_stock_level'],
      status: json['status'],
      company: json['company'],
      companyName: json['company_name'],
      images: (json['images'] as List)
          .map((img) => ProductImage.fromJson(img))
          .toList(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "tracker": tracker,
      "name": name,
      "sku": sku,
      "barcode": barcode,
      "description": description,
      "unit_price": unitPrice,
      "unit_of_measure": unitOfMeasure,
      "min_stock_level": minStockLevel,
      "status": status,
      "company": company,
      "company_name": companyName,
      "images": images.map((img) => img.toJson()).toList(),
      "created_at": createdAt.toIso8601String(),
    };
  }
}