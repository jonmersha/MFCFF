class Company {
  final int id; // The integer ID required for POST: {"company": 1}
  final String tracker;
  final String name;
  final int city;
  final String cityName;
  final String? logo;
  final String? banner;
  final String? description;
  final String status;

  Company({
    required this.id,
    required this.tracker,
    required this.name,
    required this.city,
    required this.cityName,
    this.logo,
    this.banner,
    this.description,
    required this.status,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'] ?? 0,
      tracker: json['tracker'] ?? '',
      name: json['name'] ?? '',
      city: json['city'] ?? 0,
      cityName: json['city_name'] ?? '',
      logo: json['logo'],
      banner: json['banner'],
      description: json['description'],
      status: json['status'] ?? 'active',
    );
  }

  // CRITICAL: This prevents the "Selection Freeze" and Assertion Errors in Dropdowns
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Company &&
          runtimeType == other.runtimeType &&
          tracker == other.tracker;

  @override
  int get hashCode => tracker.hashCode;
}
