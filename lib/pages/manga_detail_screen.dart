import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:myanimelist/bloc/manga_detail_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  final int id;

  const DetailPage({super.key, required this.id});

  @override
  State<DetailPage> createState() => _MangaDetailPageState();
}

class _MangaDetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch $url');
        throw 'Could not launch $url';
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  Widget _buildRatingStars(double? rating) {
    if (rating == null) {
      return const Text('No rating available');
    }
    int fullStars = rating ~/ 2;
    bool hasHalfStar = (rating % 2) >= 1;
    return Row(
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return const Icon(Icons.star, color: Colors.amber);
        } else if (index == fullStars && hasHalfStar) {
          return const Icon(Icons.star_half, color: Colors.amber);
        } else {
          return const Icon(Icons.star_border, color: Colors.amber);
        }
      }),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Finished':
        return Colors.green;
      case 'Publishing':
        return Colors.yellow;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 40, 53, 147),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Image.network(
          'https://store-images.s-microsoft.com/image/apps.14964.9007199266506523.65c06eb1-33a4-438a-855a-7726d60ec911.21ac20c8-cdd3-447c-94d5-d8cf1eb08650?h=210',
          height: 40,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) =>
              MangaDetailBloc()..add(FetchMangaDetail(widget.id)),
          child: Column(
            children: [
              // Content
              Expanded(
                child: BlocBuilder<MangaDetailBloc, MangaDetailState>(
                  builder: (context, state) {
                    if (state is MangaDetailLoading) {
                      return Center(
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.white,
                          child: Container(
                            height: 600,
                            width: 420,
                            color: Colors.grey.shade300,
                          ),
                        ),
                      );
                    } else if (state is MangaDetailError) {
                      return const Center(
                        child: Text('Failed to load manga detail'),
                      );
                    } else if (state is MangaDetailLoaded) {
                      final mangaDetail = state.mangaDetail;
                      debugPrint('Manga Detail: $mangaDetail');
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Manga Cover Image
                            Container(
                              height: 600,
                              width: 420,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade800),
                              ),
                              child: Image.network(
                                mangaDetail.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Text('Failed to load image'),
                                  );
                                },
                              ),
                            ),
                            // Stats Section
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      mangaDetail.title,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      _buildRatingStars(mangaDetail.score),
                                      Text(
                                        mangaDetail.score.toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.amber,
                                        ),
                                      ),
                                      Text(
                                        mangaDetail.rank != 0
                                            ? 'Rank #${mangaDetail.rank}'
                                            : 'No rank available',
                                        style: TextStyle(
                                          color: Colors.blue.shade300,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Info Section
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      '${mangaDetail.type}, ${mangaDetail.chapters != 0 ? mangaDetail.chapters : 'Unknown'} chapters',
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(mangaDetail.status)
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      mangaDetail.status,
                                      style: TextStyle(
                                        color:
                                            _getStatusColor(mangaDetail.status),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      '${mangaDetail.volumes != 0 ? mangaDetail.volumes : 'Unknown'} volumes',
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Genres
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8, // Add spacing between rows
                                children: mangaDetail.genres
                                    .map((genre) => GenreChip(label: genre))
                                    .toList(),
                              ),
                            ),
                            // Synopsis
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                mangaDetail.synopsis,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text('No data available'),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GenreChip extends StatelessWidget {
  final String label;

  const GenreChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.blue),
      ),
    );
  }
}