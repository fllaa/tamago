import 'package:tamago/domain/entities/genre.dart';

abstract class GenreRepository {
  Future<List<Genre>> getHighlightedGenres();
}
