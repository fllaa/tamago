import 'package:jikan_api_v4/jikan_api_v4.dart';
import 'package:tamago/domain/repositories/anime_repository.dart';

class GetAnimeReviewsUseCase {
  final AnimeRepository repository;

  GetAnimeReviewsUseCase({required this.repository});

  Future<List<Review>> call(int malId, {int page = 1}) async {
    return await repository.getAnimeReviews(malId, page: page);
  }
}