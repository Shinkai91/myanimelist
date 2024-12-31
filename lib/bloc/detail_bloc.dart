import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:myanimelist/model/detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

part 'detail_event.dart';
part 'detail_state.dart';

class AnimeDetailBloc extends Bloc<AnimeDetailEvent, AnimeDetailState> {
  AnimeDetailBloc() : super(AnimeDetailInitial()) {
    on<FetchAnimeDetail>(_onFetchAnimeDetail);
  }

  Future<void> _onFetchAnimeDetail(FetchAnimeDetail event, Emitter<AnimeDetailState> emit) async {
    emit(AnimeDetailLoading());
    try {
      final response = await http.get(Uri.parse('https://api.jikan.moe/v4/anime/${event.animeId}/full'));
      if (response.statusCode == 200) {
        final animeDetail = AnimeDetail.fromJson(json.decode(response.body)['data']);
        emit(AnimeDetailLoaded(animeDetail));
      } else {
        emit(AnimeDetailError());
      }
    } catch (_) {
      emit(AnimeDetailError());
    }
  }
}