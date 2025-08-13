import 'package:flutter_boilerplate/domain/entities/genre.dart';
import 'package:flutter_boilerplate/domain/repositories/genre_repository.dart';

class GetHighlightedGenresUseCase {
  final GenreRepository repository;

  GetHighlightedGenresUseCase({required this.repository});

  Future<List<Genre>> call() async {
    return await repository.getHighlightedGenres();
  }
}
