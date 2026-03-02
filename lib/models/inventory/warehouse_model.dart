class Warehouse {
  final int id;
  final String tracker;
  final int factoryId;
  final String name;
  final String? description;
  final String? location;
  final int? capacity;
  final String status;

  Warehouse({
    required this.id,
    required this.tracker,
    required this.factoryId,
    required this.name,
    this.description,
    this.location,
    this.capacity,
    required this.status,
  });

  factory Warehouse.fromJson(Map<String, dynamic> json) => Warehouse(
    id: json['id'],
    tracker: json['tracker'],
    factoryId: json['factory'],
    name: json['name'],
    description: json['description'],
    location: json['location'],
    capacity: json['capacity'],
    status: json['status'],
  );
}
