class DistrictData {
  bool success;
  List<Districts> districts;

  DistrictData({
    required this.success,
    required this.districts,
  });

  factory DistrictData.fromJson(Map<String, dynamic> json) {
    return DistrictData(
      success: json['success'] ?? false,
      districts: (json['districts'] as List<dynamic>?)
              ?.map((e) => Districts.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'districts': districts.map((e) => e.toJson()).toList(),
    };
  }
}

class Districts {
  int id;
  String name;

  Districts({
    required this.id,
    required this.name,
  });

  factory Districts.fromJson(Map<String, dynamic> json) {
    return Districts(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
