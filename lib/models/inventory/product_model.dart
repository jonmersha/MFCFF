class Product {
  final int id;
  final String tracker;
  final String name;
  final double unitPrice;
  final String unitOfMeasure;
  final String status;
  final int companyId;
  final String companyName;
  final String? description;

  Product({
    required this.id,
    required this.tracker,
    required this.name,
    required this.unitPrice,
    required this.unitOfMeasure,
    required this.status,
    required this.companyId,
    required this.companyName,
    this.description,
  });

  // Factory constructor to create a Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      tracker: json['tracker'],
      name: json['name'],
      // Handles both int and double from API safely
      unitPrice: (json['unit_price'] as num).toDouble(),
      unitOfMeasure: json['unit_of_measure'],
      status: json['status'],
      companyId: json['company'],
      companyName: json['company_name'],
      description: json['description'],
    );
  }

  // Method to convert Product instance to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "unit_price": unitPrice,
      "unit_of_measure": unitOfMeasure,
      "status": status,
      "company": companyId,
      "description": description,
    };
  }
}
