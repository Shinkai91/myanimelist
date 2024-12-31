import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'dart:async';

import 'package:myanimelist/bloc/anime_bloc.dart';
import 'package:myanimelist/model/anime.dart';
import 'package:myanimelist/pages/detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  late Timer _timer;
  late DateTime _currentTime;

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
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 40, 53, 147),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(
            'https://store-images.s-microsoft.com/image/apps.14964.9007199266506523.65c06eb1-33a4-438a-855a-7726d60ec911.21ac20c8-cdd3-447c-94d5-d8cf1eb08650?h=210',
            fit: BoxFit.contain,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${_currentTime.day}/${_currentTime.month}/${_currentTime.year}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.white),
                ),
                Text(
                  '${_currentTime.hour.toString().padLeft(2, '0')}:${_currentTime.minute.toString().padLeft(2, '0')}:${_currentTime.second.toString().padLeft(2, '0')}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: _buildPageContent(),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        items: const [
          CurvedNavigationBarItem(
            child: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.search),
            label: 'Search',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 40, 53, 147),
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }

  Widget _buildPageContent() {
    return BlocListener<AnimeBloc, AnimeState>(
      listener: (context, state) {
        if (state is AnimeLoaded) {
          if (state.animes.isNotEmpty && state.animes.first.filter == 'airing') {
            airingAnimes = state.animes;
          } else if (state.animes.isNotEmpty && state.animes.first.filter == 'upcoming') {
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
                                builder: (context) => AnimeDetailPage(animeId: anime.malId),
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
                        builder: (context) => AnimeDetailPage(animeId: anime.malId),
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