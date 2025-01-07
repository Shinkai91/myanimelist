part of 'manga_bloc.dart';

abstract class MangaState extends Equatable {
  const MangaState();

  @override
  List<Object> get props => [];
}

class MangaInitial extends MangaState {}

class MangaLoading extends MangaState {
  final String filter;

  const MangaLoading({required this.filter});

  @override
  List<Object> get props => [filter];
}

class MangaLoaded extends MangaState {
  final List<Manga> mangas;
  final String filter;

  const MangaLoaded({required this.mangas, required this.filter});

  @override
  List<Object> get props => [mangas, filter];
}

class MangaError extends MangaState {
  final String message;
  final String filter;

  const MangaError({required this.message, required this.filter});

  @override
  List<Object> get props => [message, filter];
}