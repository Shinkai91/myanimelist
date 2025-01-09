import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myanimelist/widgets/genre_chip.dart';
import 'package:shimmer/shimmer.dart';
import 'package:myanimelist/bloc/manga_detail_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:myanimelist/pages/offline_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MangaDetailScreen extends StatefulWidget {
  final int id;

  const MangaDetailScreen({super.key, required this.id});

  @override
  State<MangaDetailScreen> createState() => _MangaDetailPageState();
}

class _MangaDetailPageState extends State<MangaDetailScreen> {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _isOffline = false;
  bool _isSharing = false;
  bool _isMounted = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _checkConnectivity();
    _checkIfFavorite();

    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      final result =
          results.isNotEmpty ? results.first : ConnectivityResult.none;
      if (result == ConnectivityResult.none) {
        setState(() {
          _isOffline = true;
        });
      } else {
        setState(() {
          _isOffline = false;
        });
      }
    });
  }

  Future<void> _checkConnectivity() async {
    final ConnectivityResult result =
        (await Connectivity().checkConnectivity()) as ConnectivityResult;
    if (result == ConnectivityResult.none) {
      setState(() {
        _isOffline = true;
      });
    } else {
      setState(() {
        _isOffline = false;
      });
    }
  }

  Future<void> _checkIfFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteManga = prefs.getStringList('favoriteManga') ?? [];
    if (favoriteManga.contains(widget.id.toString())) {
      setState(() {
        _isFavorite = true;
      });
    }
  }

  Future<void> _saveToFavorites(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteManga = prefs.getStringList('favoriteManga') ?? [];
    if (!favoriteManga.contains(id.toString())) {
      favoriteManga.add(id.toString());
      await prefs.setStringList('favoriteManga', favoriteManga);
      setState(() {
        _isFavorite = true;
      });
    }
  }

  Future<void> _removeFromFavorites(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteManga = prefs.getStringList('favoriteManga') ?? [];
    if (favoriteManga.contains(id.toString())) {
      favoriteManga.remove(id.toString());
      await prefs.setStringList('favoriteManga', favoriteManga);
      if (mounted) {
        setState(() {
          _isFavorite = false;
        });
        Navigator.pop(context, true);
      }
    }
  }

  @override
  void dispose() {
    _isMounted = false;
    _connectivitySubscription.cancel();
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
    if (_isOffline) {
      return OfflineScreen(
        onRetry: _checkConnectivity,
      );
    }
    return BlocProvider(
      create: (context) => MangaDetailBloc()..add(FetchMangaDetail(widget.id)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 40, 53, 147),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Image.asset(
            'lib/assets/appbar.png',
            height: 40,
          ),
          actions: [
            IconButton(
              icon: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: _isFavorite ? Colors.red : Colors.white,
              ),
              onPressed: () {
                if (_isFavorite) {
                  _removeFromFavorites(widget.id);
                } else {
                  _saveToFavorites(widget.id);
                }
              },
            ),
            BlocBuilder<MangaDetailBloc, MangaDetailState>(
              builder: (context, state) {
                return IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () async {
                    if (state is MangaDetailLoaded && !_isSharing) {
                      if (_isMounted) {
                        setState(() {
                          _isSharing = true;
                        });
                      }
                      final mangaDetail = state.mangaDetail;
                      await Share.share(mangaDetail.url);
                      if (_isMounted) {
                        setState(() {
                          _isSharing = false;
                        });
                      }
                    }
                  },
                );
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  // Content
                  Expanded(
                    child: BlocBuilder<MangaDetailBloc, MangaDetailState>(
                      builder: (context, state) {
                        if (state is MangaDetailLoading) {
                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Shimmer for Anime Cover Image
                                Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.white,
                                  child: Container(
                                    height: 600,
                                    width: double.infinity,
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                // Shimmer for Stats Section
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Shimmer.fromColors(
                                          baseColor: Colors.grey.shade300,
                                          highlightColor: Colors.white,
                                          child: Container(
                                            height: 24,
                                            width: double.infinity,
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Shimmer.fromColors(
                                            baseColor: Colors.grey.shade300,
                                            highlightColor: Colors.white,
                                            child: Container(
                                              height: 16,
                                              width: 100,
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Shimmer.fromColors(
                                            baseColor: Colors.grey.shade300,
                                            highlightColor: Colors.white,
                                            child: Container(
                                              height: 16,
                                              width: 50,
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Shimmer for Info Section
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Shimmer.fromColors(
                                          baseColor: Colors.grey.shade300,
                                          highlightColor: Colors.white,
                                          child: Container(
                                            height: 16,
                                            width: double.infinity,
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.white,
                                        child: Container(
                                          height: 16,
                                          width: 80,
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Shimmer.fromColors(
                                          baseColor: Colors.grey.shade300,
                                          highlightColor: Colors.white,
                                          child: Container(
                                            height: 16,
                                            width: double.infinity,
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Shimmer for Genres
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Wrap(
                                    spacing: 8,
                                    children: List.generate(3, (index) {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.white,
                                        child: Container(
                                          height: 24,
                                          width: 60,
                                          color: Colors.grey.shade300,
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                                // Shimmer for Synopsis
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(3, (index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: Shimmer.fromColors(
                                          baseColor: Colors.grey.shade300,
                                          highlightColor: Colors.white,
                                          child: Container(
                                            height: 16,
                                            width: double.infinity,
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                                // Shimmer for Trailer Section
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.white,
                                    child: Container(
                                      height: 200,
                                      width: double.infinity,
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                ),
                                // Shimmer for Opening Songs
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(2, (index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: Shimmer.fromColors(
                                          baseColor: Colors.grey.shade300,
                                          highlightColor: Colors.white,
                                          child: Container(
                                            height: 16,
                                            width: double.infinity,
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                                // Shimmer for Ending Songs
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(2, (index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: Shimmer.fromColors(
                                          baseColor: Colors.grey.shade300,
                                          highlightColor: Colors.white,
                                          child: Container(
                                            height: 16,
                                            width: double.infinity,
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                                // Shimmer for Characters and Voice Actors
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(3, (index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Shimmer.fromColors(
                                          baseColor: Colors.grey.shade300,
                                          highlightColor: Colors.white,
                                          child: Container(
                                            height: 50,
                                            width: double.infinity,
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
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
                                    border:
                                        Border.all(color: Colors.grey.shade800),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
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
                                          color: _getStatusColor(
                                                  mangaDetail.status)
                                              .withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          mangaDetail.status,
                                          style: TextStyle(
                                            color: _getStatusColor(
                                                mangaDetail.status),
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
                            child: Text(''),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (_isSharing)
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
