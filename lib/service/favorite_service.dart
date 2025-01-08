import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static const String _favoriteKey = 'favorite_animes';

  Future<void> addFavorite(int animeId) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteAnimes = prefs.getStringList(_favoriteKey) ?? [];
    if (!favoriteAnimes.contains(animeId.toString())) {
      favoriteAnimes.add(animeId.toString());
      await prefs.setStringList(_favoriteKey, favoriteAnimes);
    }
  }

  Future<void> removeFavorite(int animeId) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteAnimes = prefs.getStringList(_favoriteKey) ?? [];
    favoriteAnimes.remove(animeId.toString());
    await prefs.setStringList(_favoriteKey, favoriteAnimes);
  }

  Future<List<int>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteAnimes = prefs.getStringList(_favoriteKey) ?? [];
    return favoriteAnimes.map((id) => int.parse(id)).toList();
  }

  Future<bool> isFavorite(int animeId) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteAnimes = prefs.getStringList(_favoriteKey) ?? [];
    return favoriteAnimes.contains(animeId.toString());
  }
}