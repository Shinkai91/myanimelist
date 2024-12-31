part of 'anime_bloc.dart';

abstract class AnimeState extends Equatable {
  const AnimeState();

  @override
  List<Object> get props => [];
}

class AnimeInitial extends AnimeState {}

class AnimeLoading extends AnimeState {}

class AnimeLoaded extends AnimeState {
  final List<Anime> animes;

  const AnimeLoaded(this.animes);

  @override
  List<Object> get props => [animes];
}

class AnimeError extends AnimeState {
  final String message;

  const AnimeError(this.message);

  @override
  List<Object> get props => [message];
}