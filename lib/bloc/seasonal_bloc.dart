import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myanimelist/model/seasonal.dart';

part 'seasonal_event.dart';
part 'seasonal_state.dart';

class SeasonalAnimeBloc extends Bloc<SeasonalAnimeEvent, SeasonalAnimeState> {
  SeasonalAnimeBloc() : super(SeasonalAnimeInitial()) {
    on<FetchSeasonalAnimeBySeason>(_onFetchSeasonalAnimeBySeason);
  }

  void _onFetchSeasonalAnimeBySeason(FetchSeasonalAnimeBySeason event,
      Emitter<SeasonalAnimeState> emit) async {
    emit(SeasonalAnimeLoading());
    bool success = false;
    while (!success) {
      try {
        final response = await http.get(Uri.parse(
            'https://api.jikan.moe/v4/seasons/${event.year}/${event.season}?filter=${event.type}'));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final seasonalAnimeResponse = SeasonalAnimeResponse.fromJson(data);
          emit(SeasonalAnimeLoaded(seasonalAnimeResponse.data));
          success = true;
        } else {
          emit(const SeasonalAnimeError('Failed to load seasonal anime'));
        }
      } catch (e) {
        emit(SeasonalAnimeError(e.toString()));
      }
    }
  }
}
