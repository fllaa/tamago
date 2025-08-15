import 'package:jikan_api_v4/jikan_api_v4.dart';

class AnimeDetailResult {
  final Anime? anime;
  final bool isFromCache;

  const AnimeDetailResult({
    required this.anime,
    required this.isFromCache,
  });
}