class Factory {
  final int id;
  final String tracker;
  final String name;
  final int companyId; // Mapped from "company"
  final String companyName; // Mapped from "company_name"
  final int cityId; // Mapped from "city"
  final String cityName; // Mapped from "city_name"
  final int? capacity;
  final String? description;
  final String status;

  Factory({
    required this.id,
    required this.tracker,
    required this.name,
    required this.companyId,
    required this.companyName,
    required this.cityId,
    required this.cityName,
    this.capacity,
    this.description,
    required this.status,
  });

  // Factory method to create a Factory object from JSON
  factory Factory.fromJson(Map<String, dynamic> json) {
    return Factory(
      id: json['id'],
      tracker: json['tracker'],
      name: json['name'],
      companyId: json['company'],
      companyName: json['company_name'] ?? "Unknown Company",
      cityId: json['city'],
      cityName: json['city_name'] ?? "Unknown City",
      capacity: json['capacity'],
      description: json['description'],
      status: json['status'] ?? 'active',
    );
  }

  // Method to convert Factory to JSON for POST/PUT requests
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "company": companyId,
      "city": cityId,
      "capacity": capacity,
      "description": description,
      "status": status,
    };
  }
}
