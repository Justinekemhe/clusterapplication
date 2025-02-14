class UserData {
  final bool success;
  final List<Users> users;

  UserData({
    required this.success,
    required this.users,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      success: json['success'] ?? false,
      users: (json['users'] as List<dynamic>?)
              ?.map((e) => Users.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'users': users.map((e) => e.toJson()).toList(),
    };
  }
}

class Users {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;

  Users({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
    };
  }
}
