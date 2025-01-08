import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:myanimelist/bloc/manga_bloc.dart';
import 'package:myanimelist/bloc/rekomendasi_bloc.dart';
import 'package:myanimelist/model/manga.dart';
import 'package:myanimelist/model/rekomendasi.dart' as rekomendasi;
import 'package:myanimelist/pages/manga_detail_screen.dart';

class MangaScreen extends StatefulWidget {
  const MangaScreen({super.key});

  @override
  State<MangaScreen> createState() => _MangaScreenState();
}

class _MangaScreenState extends State<MangaScreen> {
  List<Manga> topMangas = [];
  List<Manga> publishingMangas = [];
  List<rekomendasi.MangaRecommendation> recommendations = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    context.read<MangaBloc>().add(const FetchManga(filter: ''));
    context.read<MangaBloc>().add(const FetchManga(filter: 'publishing'));
    context.read<MangaRecommendationBloc>().add(FetchMangaRecommendations());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _fetchData,
        child: _buildPageContent(),
      ),
    );
  }

  Widget _buildPageContent() {
    return MultiBlocListener(
      listeners: [
        BlocListener<MangaBloc, MangaState>(
          listener: (context, state) {
            if (state is MangaLoaded) {
              if (state.filter == 'publishing') {
                publishingMangas = state.mangas;
              } else if (state.filter == '') {
                topMangas = state.mangas;
              }
            }
          },
        ),
        BlocListener<MangaRecommendationBloc, MangaRecommendationState>(
          listener: (context, state) {
            if (state is MangaRecommendationLoaded) {
              recommendations = state.recommendations;
            }
          },
        ),
      ],
      child: BlocBuilder<MangaBloc, MangaState>(
        builder: (context, state) {
          if (state is MangaLoading) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shimmer effect for loading state
                  _buildShimmerSection('Rekomendasi', isCarousel: true),
                  _buildShimmerSection('Top Manga', isCarousel: false),
                  _buildShimmerSection('Top Publishing', isCarousel: false),
                ],
              ),
            );
          } else if (state is MangaLoaded) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rekomendasi Text
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Text(
                      'Rekomendasi',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  // Carousel Image Section
                  BlocBuilder<MangaRecommendationBloc,
                      MangaRecommendationState>(
                    builder: (context, state) {
                      if (state is MangaRecommendationLoading) {
                        return _buildLoading(isCarousel: true);
                      } else if (state is MangaRecommendationLoaded) {
                        return Container(
                          height: 300, // Adjusted height for portrait posters
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0), // Reduce vertical margin
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.recommendations.length,
                            itemBuilder: (context, index) {
                              final recommendation =
                                  state.recommendations[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MangaDetailScreen(
                                          id: recommendation.malId),
                                    ),
                                  );
                                },
                                child: Container(
                                  width:
                                      200, // Adjusted width for portrait posters
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Stack(
                                      children: [
                                        Image.network(
                                          recommendation.imageUrl,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                        Positioned(
                                          left: 0,
                                          bottom: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            color:
                                                Colors.black.withOpacity(0.6),
                                            child: Text(
                                              recommendation.title,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else if (state is MangaRecommendationError) {
                        return _buildLoading(isCarousel: true);
                      } else {
                        return const Center(
                            child: Text('Something went wrong!'));
                      }
                    },
                  ),

                  // Section Builder
                  _buildSection('Top Manga', topMangas),
                  _buildSection('Top Publishing', publishingMangas),
                ],
              ),
            );
          } else if (state is MangaError) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shimmer effect for loading state
                  _buildShimmerSection('Rekomendasi', isCarousel: true),
                  _buildShimmerSection('Top Manga', isCarousel: false),
                  _buildShimmerSection('Top Publishing', isCarousel: false),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Something went wrong!'));
          }
        },
      ),
    );
  }

  Widget _buildLoading({bool isCarousel = false}) {
    return Container(
      height: isCarousel ? 300 : 220, // Adjusted height for portrait posters
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5, // Number of shimmer items
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width:
                  isCarousel ? 200 : 120, // Adjusted width for portrait posters
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerSection(String title, {bool isCarousel = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 150,
              height: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            height:
                isCarousel ? 300 : 220, // Adjusted height for portrait posters
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5, // Number of shimmer items
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: isCarousel
                        ? 200
                        : 120, // Adjusted width for portrait posters
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
  }

  Widget _buildSection(String title, List<Manga> mangas) {
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
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: mangas.length,
              itemBuilder: (context, index) {
                final manga = mangas[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MangaDetailScreen(id: manga.malId),
                      ),
                    );
                  },
                  child: Container(
                    width: 120,
                    margin: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(manga.imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(4.0),
                                    bottomRight: Radius.circular(4.0),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Score: ${manga.score == 0.0 ? 'N/A' : manga.score}',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                    Text(
                                      'Members: ${manga.members}',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            manga.title,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            manga.genres.join(', '),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
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