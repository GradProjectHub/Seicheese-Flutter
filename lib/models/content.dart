// lib/models/content.dart

class Content {
  final int? id;
  final String name;
  final int genreId;
  final String? genreName; // nullableに変更
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Content({
    this.id,
    required this.name,
    required this.genreId,
    this.genreName, // nullable
    this.createdAt,
    this.updatedAt,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json['content_id'],
      name: json['content_name'],
      genreId: json['genre_id'],
      genreName: json['genre_name'], // APIレスポンスにない場合はnull
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content_name': name,
      'genre_id': genreId,
    };
  }
}
