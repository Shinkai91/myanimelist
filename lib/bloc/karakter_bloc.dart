import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:myanimelist/model/character.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

part 'karakter_event.dart';
part 'karakter_state.dart';

class KarakterBloc extends Bloc<KarakterEvent, KarakterState> {
  KarakterBloc() : super(KarakterInitial()) {
    on<FetchKarakter>(_onFetchKarakter);
  }

  Future<void> _onFetchKarakter(
      FetchKarakter event, Emitter<KarakterState> emit) async {
    emit(KarakterLoading());
    try {
      final response = await http.get(Uri.parse(
          'https://api.jikan.moe/v4/anime/${event.animeId}/characters'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        final characters =
            data.map((character) => Character.fromJson(character)).toList();
        emit(KarakterLoaded(characters));
      } else {
        emit(KarakterError());
      }
    } catch (_) {
      emit(KarakterError());
    }
  }
}