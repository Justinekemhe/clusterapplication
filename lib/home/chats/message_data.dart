class MessageData {
  final bool success;
  final List<Messages> messages;

  MessageData({required this.success, required this.messages});

  factory MessageData.fromJson(Map<String, dynamic> json) {
    return MessageData(
      success: json['success'],
      messages: json['messages'] != null
          ? List<Messages>.from(
              json['messages'].map((v) => Messages.fromJson(v)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'messages': messages.map((v) => v.toJson()).toList(),
    };
  }
}

class Messages {
  final int id;
  final String message;
  final int userId;
  final String messageType;
  final String username;
  final String createdAt;

  Messages({
    required this.id,
    required this.message,
    required this.userId,
    required this.messageType,
    required this.username,
    required this.createdAt,
  });

  factory Messages.fromJson(Map<String, dynamic> json) {
    return Messages(
      id: json['id'],
      message: json['message'],
      userId: json['user_id'],
      messageType: json['messageType'],
      username: json['username'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'user_id': userId,
      'messageType': messageType,
      'username': username,
      'created_at': createdAt,
    };
  }
}
