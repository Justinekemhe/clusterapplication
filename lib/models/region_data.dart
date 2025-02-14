class RegionData {
  final bool success;
  final List<Regions> regions;

  RegionData({
    required this.success,
    required this.regions,
  });

  factory RegionData.fromJson(Map<String, dynamic> json) {
    return RegionData(
      success: json['success'] ?? false,
      regions: (json['regions'] as List<dynamic>?)
              ?.map((e) => Regions.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'regions': regions.map((e) => e.toJson()).toList(),
    };
  }
}

class Regions {
  final int id;
  final String name;

  Regions({
    required this.id,
    required this.name,
  });

  factory Regions.fromJson(Map<String, dynamic> json) {
    return Regions(
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
