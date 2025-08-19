import 'package:tamago/domain/entities/genre.dart';
import 'package:tamago/domain/repositories/genre_repository.dart';

class GetHighlightedGenresUseCase {
  final GenreRepository repository;

  GetHighlightedGenresUseCase({required this.repository});

  Future<List<Genre>> call() async {
    return await repository.getHighlightedGenres();
  }
}
