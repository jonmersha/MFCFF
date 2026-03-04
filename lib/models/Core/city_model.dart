
class City {
  final int id; // Added explicit ID for POST requests
  final String tracker;
  final String name;
  final int adminRegion;
  final String regionName;
  final String? description;
  final String status;

  City({
    required this.id,
    required this.tracker,
    required this.name,
    required this.adminRegion,
    required this.regionName,
    this.description,
    required this.status,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    // We use admin_region as the ID since your POST request expects an integer
    final int extractedId = json['admin_region'] ?? 0;

    return City(
      id: extractedId,
      tracker: json['tracker'] ?? '',
      name: json['name'] ?? '',
      adminRegion: extractedId,
      regionName: json['region_name'] ?? '',
      description: json['description'],
      status: json['status'] ?? 'active',
    );
  }

  // Optional: Override equality and hashCode
  // This prevents the "Selection Freeze" in Dropdowns
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is City &&
              runtimeType == other.runtimeType &&
              tracker == other.tracker;

  @override
  int get hashCode => tracker.hashCode;
}
