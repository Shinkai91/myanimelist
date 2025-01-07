part of 'rekomendasi_bloc.dart';

abstract class MangaRecommendationEvent extends Equatable {
  const MangaRecommendationEvent();

  @override
  List<Object> get props => [];
}

class FetchMangaRecommendations extends MangaRecommendationEvent {}