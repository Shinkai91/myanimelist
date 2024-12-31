part of 'karakter_bloc.dart';

abstract class KarakterEvent extends Equatable {
  const KarakterEvent();

  @override
  List<Object> get props => [];
}

class FetchKarakter extends KarakterEvent {
  final int animeId;

  const FetchKarakter(this.animeId);

  @override
  List<Object> get props => [animeId];
}