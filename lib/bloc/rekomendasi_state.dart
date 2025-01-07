part of 'rekomendasi_bloc.dart';

abstract class MangaRecommendationState extends Equatable {
  const MangaRecommendationState();

  @override
  List<Object> get props => [];
}

class MangaRecommendationInitial extends MangaRecommendationState {}

class MangaRecommendationLoading extends MangaRecommendationState {}

class MangaRecommendationLoaded extends MangaRecommendationState {
  final List<MangaRecommendation> recommendations;

  const MangaRecommendationLoaded({required this.recommendations});

  @override
  List<Object> get props => [recommendations];
}

class MangaRecommendationError extends MangaRecommendationState {
  final String message;

  const MangaRecommendationError({required this.message});

  @override
  List<Object> get props => [message];
}