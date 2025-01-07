part of 'seasonal_bloc.dart';

abstract class SeasonalAnimeState extends Equatable {
  const SeasonalAnimeState();

  @override
  List<Object> get props => [];
}

class SeasonalAnimeInitial extends SeasonalAnimeState {}

class SeasonalAnimeLoading extends SeasonalAnimeState {}

class SeasonalAnimeLoaded extends SeasonalAnimeState {
  final List<SeasonalAnime> animes;

  const SeasonalAnimeLoaded(this.animes);

  @override
  List<Object> get props => [animes];
}

class SeasonalAnimeError extends SeasonalAnimeState {
  final String message;

  const SeasonalAnimeError(this.message);

  @override
  List<Object> get props => [message];
}