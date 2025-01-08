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
    on<SearchManga>(_onSearchManga);
  }

  Future<void> _onFetchManga(FetchManga event, Emitter<MangaState> emit) async {
    emit(MangaLoading(filter: event.filter));
    bool success = false;
    while (!success) {
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
          success = true;
        } else {
          emit(MangaError(
              message: 'Failed to load mangas', filter: event.filter));
        }
      } catch (e) {
        emit(MangaError(message: e.toString(), filter: event.filter));
      }
    }
  }

  Future<void> _onSearchManga(
      SearchManga event, Emitter<MangaState> emit) async {
    emit(const MangaLoading(filter: 'search'));
    try {
      final response = await http
          .get(Uri.parse('https://api.jikan.moe/v4/manga?q=${event.query}'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> mangaJson = data['data'];
        final mangas = mangaJson.map((json) => Manga.fromJson(json)).toList();
        emit(MangaLoaded(mangas: mangas, filter: 'search'));
      } else {
        emit(const MangaError(message: 'Failed to search mangas', filter: 'search'));
      }
    } catch (e) {
      emit(MangaError(message: e.toString(), filter: 'search'));
    }
  }
}