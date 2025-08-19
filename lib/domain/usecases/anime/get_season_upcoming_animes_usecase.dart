import 'package:tamago/domain/repositories/anime_repository.dart';
import 'package:jikan_api_v4/jikan_api_v4.dart';

class GetSeasonUpcomingAnimesUseCase {
  final AnimeRepository repository;

  GetSeasonUpcomingAnimesUseCase({required this.repository});

  Future<List<Anime>> call() async {
    return await repository.getSeasonUpcomingAnimes();
  }
}
