import 'package:tamago/domain/repositories/anime_repository.dart';
import 'package:tamago/domain/entities/anime_detail_result.dart';

class GetAnimeDetailUseCase {
  final AnimeRepository repository;

  GetAnimeDetailUseCase({required this.repository});

  Future<AnimeDetailResult> call(int malId) async {
    return await repository.getAnimeDetail(malId);
  }
}
