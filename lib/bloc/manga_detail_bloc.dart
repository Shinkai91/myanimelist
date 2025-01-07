import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:myanimelist/model/detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

part 'manga_detail_event.dart';
part 'manga_detail_state.dart';

class MangaDetailBloc extends Bloc<MangaDetailEvent, MangaDetailState> {
  MangaDetailBloc() : super(MangaDetailInitial()) {
    on<FetchMangaDetail>(_onFetchMangaDetail);
  }

  Future<void> _onFetchMangaDetail(
      FetchMangaDetail event, Emitter<MangaDetailState> emit) async {
    emit(MangaDetailLoading());
    try {
      final response = await http
          .get(Uri.parse('https://api.jikan.moe/v4/manga/${event.id}/full'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        final mangaDetail = MangaDetail.fromJson(data);
        emit(MangaDetailLoaded(mangaDetail: mangaDetail));
      } else {
        // ignore: prefer_const_constructors
        emit(MangaDetailError(message: 'Failed to load manga detail'));
      }
    } catch (e) {
      emit(MangaDetailError(message: e.toString()));
    }
  }
}