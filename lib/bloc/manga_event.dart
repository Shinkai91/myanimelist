part of 'manga_bloc.dart';

abstract class MangaEvent extends Equatable {
  const MangaEvent();

  @override
  List<Object> get props => [];
}

class FetchManga extends MangaEvent {
  final String filter;

  const FetchManga({this.filter = ''});

  @override
  List<Object> get props => [filter];
}

class SearchManga extends MangaEvent {
  final String query;

  const SearchManga(this.query);

  @override
  List<Object> get props => [query];
}