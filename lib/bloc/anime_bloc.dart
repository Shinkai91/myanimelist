import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:myanimelist/model/anime.dart';

part 'anime_event.dart';
part 'anime_state.dart';

class AnimeBloc extends Bloc<AnimeEvent, AnimeState> {
  AnimeBloc() : super(AnimeInitial()) {
    on<FetchAnime>((event, emit) async {
      emit(AnimeLoading());
      bool success = false;
      while (!success) {
        try {
          final queryParameters = {
            if (event.filter != null) 'filter': event.filter!,
          };
          final uri =
              Uri.https('api.jikan.moe', '/v4/top/anime', queryParameters);
          final response = await http.get(uri);
          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            final animes = (data['data'] as List)
                .map((anime) => Anime.fromJson(anime, filter: event.filter))
                .toList();
            emit(AnimeLoaded(animes));
            success = true;
          } else {
            emit(const AnimeError('Failed to load anime'));
          }
        } catch (e) {
          emit(AnimeError('An error occurred: $e'));
        }
      }
    });
  }
}