part of 'anime_rekomendasi_bloc.dart';

abstract class AnimeRecommendationState extends Equatable {
  const AnimeRecommendationState();

  @override
  List<Object> get props => [];
}

class AnimeRecommendationInitial extends AnimeRecommendationState {}

class AnimeRecommendationLoading extends AnimeRecommendationState {}

class AnimeRecommendationLoaded extends AnimeRecommendationState {
  final List<AnimeRecommendation> recommendations;

  const AnimeRecommendationLoaded({required this.recommendations});

  @override
  List<Object> get props => [recommendations];
}

class AnimeRecommendationError extends AnimeRecommendationState {
  final String message;

  const AnimeRecommendationError({required this.message});

  @override
  List<Object> get props => [message];
}