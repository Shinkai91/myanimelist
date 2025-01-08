part of 'anime_bloc.dart';

abstract class AnimeEvent extends Equatable {
  const AnimeEvent();

  @override
  List<Object> get props => [];
}

class FetchAnime extends AnimeEvent {
  final String? filter;

  const FetchAnime({this.filter});

  @override
  List<Object> get props => [filter ?? ''];
}

class SearchAnime extends AnimeEvent {
  final String query;

  const SearchAnime(this.query);

  @override
  List<Object> get props => [query];
}