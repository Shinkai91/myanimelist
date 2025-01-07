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
                  _buildShimmerSection('Top Manga'),
                  _buildShimmerSection('Top Publishing'),
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
                          height: 200,
                          margin: const EdgeInsets.symmetric(vertical: 16.0),
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
                                      builder: (context) =>
                                          DetailPage(id: recommendation.malId),
                                    ),
                                  );
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      recommendation.imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else if (state is MangaRecommendationError) {
                        return Center(child: Text(state.message));
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
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Something went wrong!'));
          }
        },
      ),
    );
  }

  Widget _buildLoading({bool isCarousel = false}) {
    return Container(
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
              width: isCarousel ? MediaQuery.of(context).size.width * 0.8 : 120,
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
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5, // Number of shimmer items
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: isCarousel
                        ? MediaQuery.of(context).size.width * 0.8
                        : 120,
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
            height: 200,
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
                        builder: (context) => DetailPage(id: manga.malId),
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
                            manga.imageUrl,
                            fit: BoxFit.cover,
                            height: 150,
                            width: 120,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          manga.title,
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