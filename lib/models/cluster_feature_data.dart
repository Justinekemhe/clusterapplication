class ClusterFeature {
  bool success;
  List<ClusterFeatures> clusterFeatures;

  ClusterFeature({
    required this.success,
    required this.clusterFeatures,
  });

  factory ClusterFeature.fromJson(Map<String, dynamic> json) {
    return ClusterFeature(
      success: json['success'] ?? false,
      clusterFeatures: (json['cluster_features'] as List<dynamic>?)
              ?.map((e) => ClusterFeatures.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'cluster_features': clusterFeatures.map((e) => e.toJson()).toList(),
    };
  }
}

class ClusterFeatures {
  int id;
  String name;

  ClusterFeatures({
    required this.id,
    required this.name,
  });

  factory ClusterFeatures.fromJson(Map<String, dynamic> json) {
    return ClusterFeatures(
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
