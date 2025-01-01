import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:myanimelist/bloc/manga_bloc.dart';
import 'package:myanimelist/model/manga.dart';
import 'package:myanimelist/pages/detail_screen.dart';

class MangaScreen extends StatefulWidget {
  const MangaScreen({super.key});

  @override
  State<MangaScreen> createState() => _MangaScreenState();
}

class _MangaScreenState extends State<MangaScreen> {
  List<Manga> topMangas = [];
  List<Manga> publishingMangas = [];
  List<Manga> upcomingMangas = [];
  List<MangaRecommendation> recommendations = [];

  @override
  void initState() {
    super.initState();
    // Fetch manga data
    context.read<MangaBloc>().add(const FetchManga());
    context.read<MangaBloc>().add(const FetchManga(filter: 'publishing'));
    context.read<MangaBloc>().add(const FetchManga(filter: 'upcoming'));
    context.read<MangaBloc>().add(FetchMangaRecommendations());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildPageContent(),
    );
  }

  Widget _buildPageContent() {
    return BlocListener<MangaBloc, MangaState>(
      listener: (context, state) {
        if (state is MangaLoaded) {
          if (state.filter == 'publishing') {
            publishingMangas = state.mangas;
          } else if (state.filter == 'upcoming') {
            upcomingMangas = state.mangas;
          } else {
            topMangas = state.mangas;
          }
        } else if (state is MangaRecommendationsLoaded) {
          recommendations = state.recommendations;
        }
      },
      child: BlocBuilder<MangaBloc, MangaState>(
        builder: (context, state) {
          if (state is MangaLoading) {
            return _buildLoading();
          } else if (state is MangaLoaded ||
              state is MangaRecommendationsLoaded) {
            return _buildLoaded();
          } else if (state is MangaError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Something went wrong!'));
          }
        },
      ),
    );
  }

  Widget _buildLoading() {
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
  }

  Widget _buildLoaded() {
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
              itemCount: recommendations.length,
              itemBuilder: (context, index) {
                final recommendation = recommendations[index];
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
                    width: MediaQuery.of(context).size.width * 0.8,
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
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
          ),

          // Section Builder
          _buildSection('Top Manga', topMangas),
          _buildSection('Top Publishing', publishingMangas),
          _buildSection('Top Upcoming', upcomingMangas),
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