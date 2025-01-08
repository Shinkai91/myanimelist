import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:myanimelist/model/rekomendasi.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

part 'anime_rekomendasi_event.dart';
part 'anime_rekomendasi_state.dart';

class AnimeRecommendationBloc
    extends Bloc<AnimeRecommendationEvent, AnimeRecommendationState> {
  AnimeRecommendationBloc() : super(AnimeRecommendationInitial()) {
    on<FetchAnimeRecommendations>(_onFetchAnimeRecommendations);
  }

  Future<void> _onFetchAnimeRecommendations(FetchAnimeRecommendations event,
      Emitter<AnimeRecommendationState> emit) async {
    emit(AnimeRecommendationLoading());
    bool success = false;
    while (!success) {
      try {
        final response = await http
            .get(Uri.parse('https://api.jikan.moe/v4/recommendations/anime'));
        if (response.statusCode == 200) {
          final data = json.decode(response.body)['data'] as List;
          final recommendations =
              data.map((json) => AnimeRecommendation.fromJson(json)).toList();
          emit(AnimeRecommendationLoaded(recommendations: recommendations));
          success = true;
        } else {
          emit(const AnimeRecommendationError(
              message: 'Failed to load recommendations'));
        }
      } catch (e) {
        emit(AnimeRecommendationError(message: e.toString()));
      }
    }
  }
}