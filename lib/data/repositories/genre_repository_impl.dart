import 'package:tamago/core/services/supabase_service.dart';
import 'package:tamago/data/models/genre_model.dart';
import 'package:tamago/domain/entities/genre.dart';
import 'package:tamago/domain/repositories/genre_repository.dart';

class GenreRepositoryImpl implements GenreRepository {
  final SupabaseService supabaseService;

  GenreRepositoryImpl({required this.supabaseService});

  @override
  Future<List<Genre>> getHighlightedGenres() async {
    try {
      final response = await supabaseService.client
          .from('highlighted_genres')
          .select()
          .order('order');

      final genres = response.map((json) {
        return GenreModel.fromJson(json);
      }).toList();

      return genres.cast<Genre>();
    } catch (e) {
      throw Exception('Failed to fetch highlighted genres: $e');
    }
  }
}
