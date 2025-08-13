import 'package:flutter_boilerplate/domain/repositories/anime_repository.dart';
import 'package:jikan_api_v4/jikan_api_v4.dart';

class GetTopAnimesUseCase {
  final AnimeRepository repository;

  GetTopAnimesUseCase({required this.repository});

  Future<List<Anime>> call() async {
    return await repository.getTopAnimes();
  }
}
