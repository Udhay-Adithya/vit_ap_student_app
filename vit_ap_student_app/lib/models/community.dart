import 'dart:convert';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

String postToJson(Post data) => json.encode(data.toJson());

class Post {
  String id;
  String content;
  String profileImagePath;
  String username;
  DateTime timestamp;
  String type;
  int likes;
  int dislikes;
  List<String> likedBy;
  List<String> dislikedBy;
  List<Comment> comments;
  List<String> tags;
  String creatorId;

  Post({
    required this.id,
    required this.content,
    required this.profileImagePath,
    required this.username,
    required this.timestamp,
    required this.type,
    required this.likes,
    required this.dislikes,
    required this.likedBy,
    required this.dislikedBy,
    required this.comments,
    required this.tags,
    required this.creatorId,
  });

  Post copyWith({
    String? id,
    String? content,
    String? profileImagePath,
    String? username,
    DateTime? timestamp,
    String? type,
    int? likes,
    int? dislikes,
    List<String>? likedBy,
    List<String>? dislikedBy,
    List<Comment>? comments,
    List<String>? tags,
    String? creatorId,
  }) =>
      Post(
        id: id ?? this.id,
        content: content ?? this.content,
        profileImagePath: profileImagePath ?? this.profileImagePath,
        username: username ?? this.username,
        timestamp: timestamp ?? this.timestamp,
        type: type ?? this.type,
        likes: likes ?? this.likes,
        dislikes: dislikes ?? this.dislikes,
        likedBy: likedBy ?? this.likedBy,
        dislikedBy: dislikedBy ?? this.dislikedBy,
        comments: comments ?? this.comments,
        tags: tags ?? this.tags,
        creatorId: creatorId ?? this.creatorId,
      );

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        content: json["content"],
        profileImagePath: json["profileImagePath"],
        username: json["username"],
        timestamp: DateTime.parse(json["timestamp"]),
        type: json["type"],
        likes: json["likes"],
        dislikes: json["dislikes"],
        likedBy: List<String>.from(json["likedBy"].map((x) => x)),
        dislikedBy: List<String>.from(json["dislikedBy"].map((x) => x)),
        comments: List<Comment>.from(
            json["comments"].map((x) => Comment.fromJson(x))),
        tags: List<String>.from(json["tags"].map((x) => x)),
        creatorId: json["creatorId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
        "profileImagePath": profileImagePath,
        "username": username,
        "timestamp": timestamp.toIso8601String(),
        "type": type,
        "likes": likes,
        "dislikes": dislikes,
        "likedBy": List<dynamic>.from(likedBy.map((x) => x)),
        "dislikedBy": List<dynamic>.from(dislikedBy.map((x) => x)),
        "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "creatorId": creatorId,
      };
}

class Comment {
  String id;
  String content;
  String userId;
  String profileImagePath;
  int likes;
  List<String> likedBy;
  DateTime timestamp;

  Comment({
    required this.id,
    required this.content,
    required this.userId,
    required this.profileImagePath,
    required this.likes,
    required this.likedBy,
    required this.timestamp,
  });

  Comment copyWith({
    String? id,
    String? content,
    String? userId,
    String? profileImagePath,
    int? likes,
    List<String>? likedBy,
    DateTime? timestamp,
  }) =>
      Comment(
        id: id ?? this.id,
        content: content ?? this.content,
        userId: userId ?? this.userId,
        profileImagePath: profileImagePath ?? this.profileImagePath,
        likes: likes ?? this.likes,
        likedBy: likedBy ?? this.likedBy,
        timestamp: timestamp ?? this.timestamp,
      );

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        content: json["content"],
        userId: json["userId"],
        profileImagePath: json["profileImagePath"],
        likes: json["likes"],
        likedBy: List<String>.from(json["likedBy"].map((x) => x)),
        timestamp: DateTime.parse(json["timestamp"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
        "userId": userId,
        "profileImagePath": profileImagePath,
        "likes": likes,
        "likedBy": List<dynamic>.from(likedBy.map((x) => x)),
        "timestamp": timestamp.toIso8601String(),
      };
}
