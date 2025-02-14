class PostData {
  bool success;
  List<Posts> posts;

  PostData({
    required this.success,
    required this.posts,
  });

  factory PostData.fromJson(Map<String, dynamic> json) {
    return PostData(
      success: json['success'] ?? false,
      posts: (json['posts'] as List<dynamic>?)
              ?.map((e) => Posts.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'posts': posts.map((e) => e.toJson()).toList(),
    };
  }
}

class Posts {
  int id;
  String thumbnail;
  String title;
  String body;
  String createdAt;

  Posts({
    required this.id,
    required this.thumbnail,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  factory Posts.fromJson(Map<String, dynamic> json) {
    return Posts(
      id: json['id'] ?? 0,
      thumbnail: json['thumbnail'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'thumbnail': thumbnail,
      'title': title,
      'body': body,
      'created_at': createdAt,
    };
  }
}
