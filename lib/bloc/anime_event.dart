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