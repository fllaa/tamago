import 'package:tamago/domain/entities/genre.dart';

class GenreModel extends Genre {
  GenreModel({
    required super.id,
    required super.malId,
    required super.name,
    required super.icon,
    required super.order,
    required super.createdAt,
    required super.updatedAt,
  });

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      id: json['id'] as int,
      malId: json['mal_id'] as int,
      name: json['name'] as String,
      icon: json['icon'] as String,
      order: json['order'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  factory GenreModel.fromEntity(Genre genre) {
    return GenreModel(
      id: genre.id,
      malId: genre.malId,
      name: genre.name,
      icon: genre.icon,
      order: genre.order,
      createdAt: genre.createdAt,
      updatedAt: genre.updatedAt,
    );
  }

  @override
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
