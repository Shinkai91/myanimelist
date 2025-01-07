import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myanimelist/model/character.dart';
import 'package:shimmer/shimmer.dart';
import 'package:myanimelist/bloc/detail_bloc.dart';
import 'package:myanimelist/bloc/karakter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  final int id;

  const DetailPage({super.key, required this.id});

  @override
  State<DetailPage> createState() => _AnimeDetailPageState();
}

class _AnimeDetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
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
      case 'Finished Airing':
        return Colors.green;
      case 'Currently Airing':
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
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  AnimeDetailBloc()..add(FetchAnimeDetail(widget.id)),
            ),
            BlocProvider(
              create: (context) =>
                  KarakterBloc()..add(FetchKarakter(widget.id)),
            ),
          ],
          child: Column(
            children: [
              // Content
              Expanded(
                child: BlocBuilder<AnimeDetailBloc, AnimeDetailState>(
                  builder: (context, state) {
                    if (state is AnimeDetailLoading) {
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
                    } else if (state is AnimeDetailError) {
                      return const Center(
                        child: Text('Failed to load anime detail'),
                      );
                    } else if (state is AnimeDetailLoaded) {
                      final animeDetail = state.animeDetail;
                      debugPrint('Anime Detail: $animeDetail');
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Anime Cover Image
                            Container(
                              height: 600,
                              width: 420,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade800),
                              ),
                              child: Image.network(
                                animeDetail.imageUrl,
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
                                      animeDetail.title,
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
                                      _buildRatingStars(animeDetail.score),
                                      Text(
                                        animeDetail.score.toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.amber,
                                        ),
                                      ),
                                      Text(
                                        animeDetail.rank != 0
                                            ? 'Rank #${animeDetail.rank}'
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
                                      '${animeDetail.type}, ${animeDetail.year != 0 ? animeDetail.year : 'Unknown'}',
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
                                      color: _getStatusColor(animeDetail.status)
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      animeDetail.status,
                                      style: TextStyle(
                                        color:
                                            _getStatusColor(animeDetail.status),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      animeDetail.duration,
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
                                children: animeDetail.genres
                                    .map((genre) => GenreChip(label: genre))
                                    .toList(),
                              ),
                            ),
                            // Synopsis
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                animeDetail.synopsis,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  height: 1.5,
                                ),
                              ),
                            ),
                            // Trailer Section
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                'Trailer:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: animeDetail.trailerUrl.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () =>
                                          _launchURL(animeDetail.trailerUrl),
                                      child: Container(
                                        height: 200,
                                        color: Colors.black12,
                                        child: Image.network(
                                          animeDetail.maximumImageUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : const Center(
                                      child: Text(
                                        'No Trailer',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                            ),
                            // Opening Songs
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                'Opening Songs:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: animeDetail.openingSongs
                                    .map((song) => Text(song))
                                    .toList(),
                              ),
                            ),
                            // Ending Songs
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                'Ending Songs:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: animeDetail.endingSongs
                                    .map((song) => Text(song))
                                    .toList(),
                              ),
                            ),
                            // Characters and Voice Actors
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                'Characters & Voice Actors:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            BlocBuilder<KarakterBloc, KarakterState>(
                              builder: (context, state) {
                                if (state is KarakterLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is KarakterError) {
                                  return const Center(
                                    child: Text('Failed to load characters'),
                                  );
                                } else if (state is KarakterLoaded) {
                                  final characters = state.characters;
                                  return Column(
                                    children: characters.map((character) {
                                      final japaneseVoiceActor =
                                          character.voiceActors.firstWhere(
                                        (va) => va.language == 'Japanese',
                                        orElse: () => VoiceActor(
                                          malId: 0,
                                          name: '',
                                          imageUrl: '',
                                          language: '',
                                        ),
                                      );
                                      final englishVoiceActor =
                                          character.voiceActors.firstWhere(
                                        (va) => va.language == 'English',
                                        orElse: () => VoiceActor(
                                          malId: 0,
                                          name: '',
                                          imageUrl: '',
                                          language: '',
                                        ),
                                      );
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  character.imageUrl,
                                                  width: 50,
                                                  height: 50,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      character.name,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Text(character.role),
                                                    const SizedBox(height: 4),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        if (japaneseVoiceActor
                                                            .name.isNotEmpty)
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        4),
                                                            child: Row(
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  child: Image
                                                                      .network(
                                                                    japaneseVoiceActor
                                                                        .imageUrl,
                                                                    width: 30,
                                                                    height: 30,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 4),
                                                                Flexible(
                                                                  child: Text(
                                                                    '${japaneseVoiceActor.name} (Japanese)',
                                                                    softWrap:
                                                                        true,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        if (englishVoiceActor
                                                            .name.isNotEmpty)
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        4),
                                                            child: Row(
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  child: Image
                                                                      .network(
                                                                    englishVoiceActor
                                                                        .imageUrl,
                                                                    width: 30,
                                                                    height: 30,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 4),
                                                                Flexible(
                                                                  child: Text(
                                                                    '${englishVoiceActor.name} (English)',
                                                                    softWrap:
                                                                        true,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  );
                                } else {
                                  return const Center(
                                    child: Text('No characters available'),
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 8.0)
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