part of 'seasonal_bloc.dart';

abstract class SeasonalAnimeEvent extends Equatable {
  const SeasonalAnimeEvent();

  @override
  List<Object> get props => [];
}

class FetchSeasonalAnimeBySeason extends SeasonalAnimeEvent {
  final int year;
  final String season;

  const FetchSeasonalAnimeBySeason(this.year, this.season);

  @override
  List<Object> get props => [year, season];
}