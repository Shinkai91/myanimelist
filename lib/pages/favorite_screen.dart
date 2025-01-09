import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myanimelist/bloc/manga_detail_bloc.dart';
import 'package:myanimelist/bloc/detail_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:myanimelist/pages/anime_detail_screen.dart';
import 'package:myanimelist/pages/manga_detail_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool _isAnimeSelected = true;

  Future<Map<String, List<String>>> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteManga = prefs.getStringList('favoriteManga') ?? [];
    final favoriteAnime = prefs.getStringList('favoriteAnime') ?? [];
    return {
      'favoriteManga': favoriteManga,
      'favoriteAnime': favoriteAnime,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Anime',
              style: TextStyle(
                color: _isAnimeSelected ? Colors.blue : Colors.grey,
                fontWeight:
                    _isAnimeSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Switch(
                key: ValueKey<bool>(_isAnimeSelected),
                value: !_isAnimeSelected,
                onChanged: (value) {
                  setState(() {
                    _isAnimeSelected = !value;
                  });
                },
                activeColor: Colors.grey,
                inactiveTrackColor: Colors.white,
              ),
            ),
            Text(
              'Manga',
              style: TextStyle(
                color: !_isAnimeSelected ? Colors.blue : Colors.grey,
                fontWeight:
                    !_isAnimeSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<Map<String, List<String>>>(
        future: _loadFavorites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading favorites'));
          } else {
            final favoriteManga = snapshot.data?['favoriteManga'] ?? [];
            final favoriteAnime = snapshot.data?['favoriteAnime'] ?? [];
            final favoriteList =
                _isAnimeSelected ? favoriteAnime : favoriteManga;
            if (favoriteList.isEmpty) {
              return const Center(child: Text('No Favorites Available'));
            }
            return ListView.builder(
              itemCount: favoriteList.length,
              itemBuilder: (context, index) {
                final id = favoriteList[index];
                return _isAnimeSelected
                    ? BlocProvider<AnimeDetailBloc>(
                        create: (context) {
                          final animeBloc = AnimeDetailBloc();
                          animeBloc.add(FetchAnimeDetail(int.parse(id)));
                          return animeBloc;
                        },
                        child: BlocBuilder<AnimeDetailBloc, AnimeDetailState>(
                          builder: (context, state) {
                            if (state is AnimeDetailLoading ||
                                state is AnimeDetailError) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: ListTile(
                                  leading: Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.white,
                                  ),
                                  title: Container(
                                    width: double.infinity,
                                    height: 10,
                                    color: Colors.white,
                                  ),
                                  subtitle: Container(
                                    width: double.infinity,
                                    height: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            } else if (state is AnimeDetailLoaded) {
                              final animeDetail = state.animeDetail;
                              return ListTile(
                                leading: Image.network(
                                  animeDetail.imageUrl,
                                  fit: BoxFit.cover,
                                  width: 50,
                                  height: 50,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.error);
                                  },
                                ),
                                title: Text(animeDetail.title),
                                subtitle: Text(animeDetail.genres.join(', ')),
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AnimeDetailScreen(id: int.parse(id)),
                                    ),
                                  );
                                  if (result == true) {
                                    setState(() {});
                                  }
                                },
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                      )
                    : BlocProvider<MangaDetailBloc>(
                        create: (context) {
                          final mangaBloc = MangaDetailBloc();
                          mangaBloc.add(FetchMangaDetail(int.parse(id)));
                          return mangaBloc;
                        },
                        child: BlocBuilder<MangaDetailBloc, MangaDetailState>(
                          builder: (context, state) {
                            if (state is MangaDetailLoading ||
                                state is MangaDetailError) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: ListTile(
                                  leading: Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.white,
                                  ),
                                  title: Container(
                                    width: double.infinity,
                                    height: 10,
                                    color: Colors.white,
                                  ),
                                  subtitle: Container(
                                    width: double.infinity,
                                    height: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            } else if (state is MangaDetailLoaded) {
                              final mangaDetail = state.mangaDetail;
                              return ListTile(
                                leading: Image.network(
                                  mangaDetail.imageUrl,
                                  fit: BoxFit.cover,
                                  width: 50,
                                  height: 50,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.error);
                                  },
                                ),
                                title: Text(mangaDetail.title),
                                subtitle: Text(mangaDetail.genres.join(', ')),
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MangaDetailScreen(id: int.parse(id)),
                                    ),
                                  );
                                  if (result == true) {
                                    setState(() {});
                                  }
                                },
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                      );
              },
            );
          }
        },
      ),
    );
  }
}