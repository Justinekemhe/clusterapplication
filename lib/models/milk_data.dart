class MilkData {
  bool success;
  List<Milks> milks;

  MilkData({
    required this.success,
    required this.milks,
  });

  factory MilkData.fromJson(Map<String, dynamic> json) {
    return MilkData(
      success: json['success'] ?? false,
      milks: (json['milks'] as List<dynamic>?)
              ?.map((e) => Milks.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'milks': milks.map((e) => e.toJson()).toList(),
    };
  }
}

class Milks {
  int id;
  int userId;
  String uuid;
  int quantity;
  int status;
  String createdAt;
  String updatedAt;

  Milks({
    required this.id,
    required this.userId,
    required this.uuid,
    required this.quantity,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Milks.fromJson(Map<String, dynamic> json) {
    return Milks(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      uuid: json['uuid'] ?? '',
      quantity: json['quantity'] ?? 0,
      status: json['status'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'uuid': uuid,
      'quantity': quantity,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
