part of 'manga_detail_bloc.dart';

abstract class MangaDetailEvent extends Equatable {
  const MangaDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchMangaDetail extends MangaDetailEvent {
  final int id;

  const FetchMangaDetail(this.id);

  @override
  List<Object> get props => [id];
}