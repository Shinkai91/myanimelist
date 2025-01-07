part of 'anime_rekomendasi_bloc.dart';

abstract class AnimeRecommendationEvent extends Equatable {
  const AnimeRecommendationEvent();

  @override
  List<Object> get props => [];
}

class FetchAnimeRecommendations extends AnimeRecommendationEvent {}