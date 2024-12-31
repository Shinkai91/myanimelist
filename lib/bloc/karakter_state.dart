part of 'karakter_bloc.dart';

abstract class KarakterState extends Equatable {
  const KarakterState();

  @override
  List<Object> get props => [];
}

class KarakterInitial extends KarakterState {}

class KarakterLoading extends KarakterState {}

class KarakterLoaded extends KarakterState {
  final List<Character> characters;

  const KarakterLoaded(this.characters);

  @override
  List<Object> get props => [characters];
}

class KarakterError extends KarakterState {}