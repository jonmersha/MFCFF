class AdminRegion {
  final int id;
  final String tracker;
  final String name;
  final String status;

  AdminRegion({
    required this.id,
    required this.tracker,
    required this.name,
    required this.status,
  });

  factory AdminRegion.fromJson(Map<String, dynamic> json) {
    return AdminRegion(
      id: json['id'],
      tracker: json['tracker'] ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "status": status,
    };
  }
}
