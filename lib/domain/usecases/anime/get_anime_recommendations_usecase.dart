import 'package:jikan_api_v4/jikan_api_v4.dart';
import 'package:tamago/domain/repositories/anime_repository.dart';

class GetAnimeRecommendationsUseCase {
  final AnimeRepository repository;

  GetAnimeRecommendationsUseCase({required this.repository});

  Future<List<Recommendation>> call(int malId) async {
    return await repository.getAnimeRecommendations(malId);
  }
}