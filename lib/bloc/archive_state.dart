part of 'archive_bloc.dart';

abstract class ArchiveState extends Equatable {
  const ArchiveState();

  @override
  List<Object> get props => [];
}

class ArchiveInitial extends ArchiveState {}

class ArchiveLoading extends ArchiveState {}

class ArchiveLoaded extends ArchiveState {
  final List<Archive> archives;

  const ArchiveLoaded(this.archives);

  @override
  List<Object> get props => [archives];
}

class ArchiveError extends ArchiveState {
  final String message;

  const ArchiveError(this.message);

  @override
  List<Object> get props => [message];
}