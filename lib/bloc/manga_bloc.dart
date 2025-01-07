import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myanimelist/model/manga.dart';

part 'manga_event.dart';
part 'manga_state.dart';

class MangaBloc extends Bloc<MangaEvent, MangaState> {
  MangaBloc() : super(MangaInitial()) {
    on<FetchManga>(_onFetchManga);
  }

  Future<void> _onFetchManga(FetchManga event, Emitter<MangaState> emit) async {
    emit(MangaLoading(filter: event.filter));
    try {
      final response = await http.get(Uri.parse(
          'https://api.jikan.moe/v4/top/manga?filter=${event.filter}'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> mangaJson = data['data'];
        final mangas = mangaJson
            .map((json) => Manga.fromJson(json, filter: event.filter))
            .toList();
        emit(MangaLoaded(mangas: mangas, filter: event.filter));
      } else {
        emit(
            MangaError(message: 'Failed to load mangas', filter: event.filter));
      }
    } catch (e) {
      emit(MangaError(message: e.toString(), filter: event.filter));
    }
  }
}