class WardData {
  final bool success;
  final List<Wards> wards;

  WardData({
    required this.success,
    required this.wards,
  });

  factory WardData.fromJson(Map<String, dynamic> json) {
    return WardData(
      success: json['success'] ?? false,
      wards: (json['wards'] as List<dynamic>?)
              ?.map((e) => Wards.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'wards': wards.map((e) => e.toJson()).toList(),
    };
  }
}

class Wards {
  final int id;
  final String name;

  Wards({
    required this.id,
    required this.name,
  });

  factory Wards.fromJson(Map<String, dynamic> json) {
    return Wards(
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
