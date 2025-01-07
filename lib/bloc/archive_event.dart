part of 'archive_bloc.dart';

abstract class ArchiveEvent extends Equatable {
  const ArchiveEvent();

  @override
  List<Object> get props => [];
}

class FetchArchiveData extends ArchiveEvent {}