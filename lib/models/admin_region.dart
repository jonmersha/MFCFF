class AdminRegion {
  final String tracker;
  final String name;
  final String status;

  AdminRegion({required this.tracker, required this.name, required this.status});

  factory AdminRegion.fromJson(Map<String, dynamic> json) => AdminRegion(
    tracker: json['tracker'],
    name: json['name'],
    status: json['status'],
  );
}

class City {
  final String tracker;
  final String name;
  final int adminRegionId;
  final String? regionName;
  final String? description;
  final String status;

  City({
    required this.tracker,
    required this.name,
    required this.adminRegionId,
    this.regionName,
    this.description,
    required this.status,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
    tracker: json['tracker'],
    name: json['name'],
    adminRegionId: json['admin_region'],
    regionName: json['region_name'],
    description: json['description'],
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "admin_region": adminRegionId,
    "description": description,
    "status": status,
  };
}

class Company {
  final String tracker;
  final String name;
  final int city;
  final String cityName;
  final String? logo;
  final String? banner;
  final String? description;
  final String status;

  Company({
    required this.tracker,
    required this.name,
    required this.city,
    required this.cityName,
    this.logo,
    this.banner,
    this.description,
    required this.status,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    tracker: json['tracker'],
    name: json['name'],
    city: json['city'],
    cityName: json['city_name'],
    logo: json['logo'],
    banner: json['banner'],
    description: json['description'],
    status: json['status'],
  );
}