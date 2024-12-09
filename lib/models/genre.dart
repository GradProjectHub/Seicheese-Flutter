class Genre {
  final int id;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Genre({
    required this.id,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['genre_id'],
      name: json['genre_name'],
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
      'genre_id': id,
      'genre_name': name,
    };
  }
}
