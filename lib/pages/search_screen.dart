import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:myanimelist/bloc/anime_bloc.dart';
import 'package:myanimelist/pages/detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  void _clearSearch() {
    _searchController.clear();
    context.read<AnimeBloc>().add(FetchAnime()); // Fetch initial data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for an anime...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: _clearSearch,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                ),
                onChanged: (query) {
                  if (query.isEmpty) {
                    context
                        .read<AnimeBloc>()
                        .add(FetchAnime()); // Fetch initial data
                  } else {
                    context.read<AnimeBloc>().add(SearchAnime(query));
                  }
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: BlocBuilder<AnimeBloc, AnimeState>(
                builder: (context, state) {
                  if (state is AnimeLoading) {
                    return ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.white,
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 10.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(10.0),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Container(
                                  color: Colors.grey.shade300,
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                              title: Container(
                                color: Colors.grey.shade300,
                                height: 20,
                                width: double.infinity,
                              ),
                              subtitle: Container(
                                color: Colors.grey.shade300,
                                height: 20,
                                width: double.infinity,
                                margin: const EdgeInsets.only(top: 5.0),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is AnimeLoaded) {
                    final animes = state.animes;
                    if (animes.isEmpty) {
                      return const Center(
                        child: Text('Anime yang anda cari tidak ada'),
                      );
                    }
                    return ListView.builder(
                      itemCount: animes.length,
                      itemBuilder: (context, index) {
                        final anime = animes[index];
                        return Card(
                          color: Colors.white, // Set background color to white
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10.0),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                anime.imageUrl,
                                fit: BoxFit.cover,
                                width: 50,
                                height: 50,
                              ),
                            ),
                            title: Text(
                              anime.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              anime.genres.join(', '),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 16.0),
                            onTap: () {
                              // Navigate to DetailScreen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailPage(id: anime.malId),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    return Container(); // Empty container for other states
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}