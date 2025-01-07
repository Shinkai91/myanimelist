part of 'manga_detail_bloc.dart';

abstract class MangaDetailState extends Equatable {
  const MangaDetailState();

  @override
  List<Object> get props => [];
}

class MangaDetailInitial extends MangaDetailState {}

class MangaDetailLoading extends MangaDetailState {}

class MangaDetailLoaded extends MangaDetailState {
  final MangaDetail mangaDetail;

  const MangaDetailLoaded({required this.mangaDetail});

  @override
  List<Object> get props => [mangaDetail];
}

class MangaDetailError extends MangaDetailState {
  final String message;

  const MangaDetailError({required this.message});

  @override
  List<Object> get props => [message];
}