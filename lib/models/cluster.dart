class ClusterData {
  bool success;
  List<Clusters> clusters;

  ClusterData({
    required this.success,
    required this.clusters,
  });

  factory ClusterData.fromJson(Map<String, dynamic> json) {
    return ClusterData(
      success: json['success'] ?? false,
      clusters: (json['clusters'] as List<dynamic>?)
              ?.map((e) => Clusters.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'clusters': clusters.map((e) => e.toJson()).toList(),
    };
  }
}

class Clusters {
  int id;
  String name;
  String thumbnail;
  String status;
  int minValue;
  int maxValue;

  Clusters({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.status,
    required this.minValue,
    required this.maxValue,
  });

  factory Clusters.fromJson(Map<String, dynamic> json) {
    return Clusters(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      status: json['status'] ?? '',
      minValue: json['min_value'] ?? 0,
      maxValue: json['max_value'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'thumbnail': thumbnail,
      'status': status,
      'min_value': minValue,
      'max_value': maxValue,
    };
  }
}
