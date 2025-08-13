import 'package:flutter_boilerplate/domain/entities/genre.dart';

abstract class GenreRepository {
  Future<List<Genre>> getHighlightedGenres();
}
