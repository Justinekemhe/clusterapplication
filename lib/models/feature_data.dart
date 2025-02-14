class FeatureData {
  bool success;
  List<Features> features;

  FeatureData({
    required this.success,
    required this.features,
  });

  factory FeatureData.fromJson(Map<String, dynamic> json) {
    return FeatureData(
      success: json['success'] ?? false,
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => Features.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'features': features.map((e) => e.toJson()).toList(),
    };
  }
}

class Features {
  int id;
  String feature;
  String choice;

  Features({
    required this.id,
    required this.feature,
    required this.choice,
  });

  factory Features.fromJson(Map<String, dynamic> json) {
    return Features(
      id: json['id'] ?? 0,
      feature: json['feature'] ?? '',
      choice: json['choice'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'feature': feature,
      'choice': choice,
    };
  }
}
