class Genre {
  final int id;
  final int malId;
  final String name;
  final String icon;
  final int order;
  final DateTime createdAt;
  final DateTime updatedAt;

  Genre({
    required this.id,
    required this.malId,
    required this.name,
    required this.icon,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'] as int,
      malId: json['mal_id'] as int,
      name: json['name'] as String,
      icon: json['icon'] as String,
      order: json['order'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mal_id': malId,
      'name': name,
      'icon': icon,
      'order': order,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
