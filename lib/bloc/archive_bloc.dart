import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:myanimelist/model/archive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

part 'archive_event.dart';
part 'archive_state.dart';

class ArchiveBloc extends Bloc<ArchiveEvent, ArchiveState> {
  ArchiveBloc() : super(ArchiveInitial()) {
    on<FetchArchiveData>((event, emit) async {
      emit(ArchiveLoading());
      bool success = false;
      while (!success) {
        try {
          final response =
              await http.get(Uri.parse('https://api.jikan.moe/v4/seasons'));
          if (response.statusCode == 200) {
            final List<dynamic> data = json.decode(response.body)['data'];
            final archives =
                data.map((json) => Archive.fromJson(json)).toList();
            emit(ArchiveLoaded(archives));
            success = true;
          } else {
            emit(const ArchiveError('Failed to fetch data'));
          }
        } catch (e) {
          emit(ArchiveError(e.toString()));
        }
      }
    });
  }
}
