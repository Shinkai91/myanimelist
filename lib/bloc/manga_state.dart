part of 'manga_bloc.dart';

abstract class MangaState extends Equatable {
  const MangaState();

  @override
  List<Object> get props => [];
}

class MangaInitial extends MangaState {}

class MangaLoading extends MangaState {}

class MangaLoaded extends MangaState {
  final List<Manga> mangas;
  final String filter;

  const MangaLoaded({required this.mangas, required this.filter});

  @override
  List<Object> get props => [mangas, filter];
}

class MangaRecommendationsLoaded extends MangaState {
  final List<MangaRecommendation> recommendations;

  const MangaRecommendationsLoaded({required this.recommendations});

  @override
  List<Object> get props => [recommendations];
}

class MangaError extends MangaState {
  final String message;

  const MangaError({required this.message});

  @override
  List<Object> get props => [message];
}