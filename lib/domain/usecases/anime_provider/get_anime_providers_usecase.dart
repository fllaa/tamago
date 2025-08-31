import 'package:tamago/domain/entities/anime_provider.dart';
import 'package:tamago/domain/repositories/anime_provider_repository.dart';

class GetAnimeProvidersUseCase {
  final AnimeProviderRepository repository;

  GetAnimeProvidersUseCase({required this.repository});

  Future<List<AnimeProvider>> call() async {
    return await repository.getAnimeProviders();
  }
}