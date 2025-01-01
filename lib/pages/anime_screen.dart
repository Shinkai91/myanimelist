import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:async';

import 'package:myanimelist/bloc/anime_bloc.dart';
import 'package:myanimelist/model/anime.dart';
import 'package:myanimelist/pages/detail_screen.dart';
import 'package:myanimelist/pages/manga_screen.dart';
import 'package:myanimelist/pages/seasonal_screen.dart';
import 'package:myanimelist/pages/search_screen.dart';
import 'package:myanimelist/pages/favorite_screen.dart';
import 'package:myanimelist/pages/profile_screen.dart';
import 'package:myanimelist/widgets/appbar.dart';
import 'package:myanimelist/widgets/navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer _timer;
  late DateTime _currentTime;
  int _pageIndex = 0;

  List<Anime> topAnimes = [];
  List<Anime> airingAnimes = [];
  List<Anime> upcomingAnimes = [];

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });

    // Fetch anime data
    context.read<AnimeBloc>().add(const FetchAnime());
    context.read<AnimeBloc>().add(const FetchAnime(filter: 'airing'));
    context.read<AnimeBloc>().add(const FetchAnime(filter: 'upcoming'));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(currentTime: _currentTime),
      body: _buildPageContent(),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _pageIndex,
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildPageContent() {
    switch (_pageIndex) {
      case 0:
        return _buildAnimePage();
      case 1:
        return const MangaScreen();
      case 2:
        return const SeasonalScreen();
      case 3:
        return const SearchScreen();
      case 4:
        return const FavoriteScreen();
      case 5:
        return const ProfileScreen();
      default:
        return _buildAnimePage();
    }
  }

  Widget _buildAnimePage() {
    return BlocListener<AnimeBloc, AnimeState>(
      listener: (context, state) {
        if (state is AnimeLoaded) {
          if (state.animes.isNotEmpty &&
              state.animes.first.filter == 'airing') {
            airingAnimes = state.animes;
          } else if (state.animes.isNotEmpty &&
              state.animes.first.filter == 'upcoming') {
            upcomingAnimes = state.animes;
          } else {
            topAnimes = state.animes;
          }
        }
      },
      child: BlocBuilder<AnimeBloc, AnimeState>(
        builder: (context, state) {
          if (state is AnimeLoading) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shimmer effect for loading state
                  Container(
                    height: 200,
                    margin: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5, // Number of shimmer items
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (state is AnimeLoaded) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Carousel Image Section
                  Container(
                    height: 200,
                    margin: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: upcomingAnimes.length,
                      itemBuilder: (context, index) {
                        final anime = upcomingAnimes[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailPage(id: anime.malId),
                              ),
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                anime.trailerImageUrl ?? anime.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Section Builder
                  _buildSection('Top Anime', topAnimes),
                  _buildSection('Top 10 Airing', airingAnimes),
                  _buildSection('Top 10 Upcoming', upcomingAnimes),
                ],
              ),
            );
          } else if (state is AnimeError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Something went wrong!'));
          }
        },
      ),
    );
  }

  Widget _buildSection(String title, List<Anime> animes) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: animes.length,
              itemBuilder: (context, index) {
                final anime = animes[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(id: anime.malId),
                      ),
                    );
                  },
                  child: Container(
                    width: 120,
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            anime.imageUrl,
                            fit: BoxFit.cover,
                            height: 150,
                            width: 120,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          anime.title,
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}