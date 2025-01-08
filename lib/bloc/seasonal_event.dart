part of 'seasonal_bloc.dart';

abstract class SeasonalAnimeEvent extends Equatable {
  const SeasonalAnimeEvent();

  @override
  List<Object> get props => [];
}

class FetchSeasonalAnimeBySeason extends SeasonalAnimeEvent {
  final int year;
  final String season;
  final String type;

  const FetchSeasonalAnimeBySeason(this.year, this.season, this.type);

  @override
  List<Object> get props => [year, season, type];
}