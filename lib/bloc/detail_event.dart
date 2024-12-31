part of 'detail_bloc.dart';

abstract class AnimeDetailEvent extends Equatable {
  const AnimeDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchAnimeDetail extends AnimeDetailEvent {
  final int animeId;

  const FetchAnimeDetail(this.animeId);

  @override
  List<Object> get props => [animeId];
}