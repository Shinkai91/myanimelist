import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myanimelist/model/rekomendasi.dart';

part 'rekomendasi_event.dart';
part 'rekomendasi_state.dart';

class MangaRecommendationBloc
    extends Bloc<MangaRecommendationEvent, MangaRecommendationState> {
  MangaRecommendationBloc() : super(MangaRecommendationInitial()) {
    on<FetchMangaRecommendations>(_onFetchMangaRecommendations);
  }

  Future<void> _onFetchMangaRecommendations(FetchMangaRecommendations event,
      Emitter<MangaRecommendationState> emit) async {
    emit(MangaRecommendationLoading());
    try {
      final response = await http
          .get(Uri.parse('https://api.jikan.moe/v4/recommendations/manga'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> recommendationsJson = data['data'];
        final recommendations = recommendationsJson
            .map((json) => MangaRecommendation.fromJson(json))
            .toList();
        emit(MangaRecommendationLoaded(recommendations: recommendations));
      } else {
        emit(const MangaRecommendationError(
            message: 'Failed to load manga recommendations'));
      }
    } catch (e) {
      emit(MangaRecommendationError(message: e.toString()));
    }
  }
}