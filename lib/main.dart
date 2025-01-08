import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:myanimelist/bloc/anime_bloc.dart';
import 'package:myanimelist/bloc/anime_rekomendasi_bloc.dart';
import 'package:myanimelist/bloc/detail_bloc.dart';
import 'package:myanimelist/bloc/manga_bloc.dart';
import 'package:myanimelist/bloc/rekomendasi_bloc.dart';
import 'package:myanimelist/pages/splash_screen.dart';
import 'package:myanimelist/pages/offline_screen.dart';

void main() {
  runApp(const MyAnimeList());
}

class MyAnimeList extends StatelessWidget {
  const MyAnimeList({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AnimeBloc>(
          create: (context) => AnimeBloc(),
        ),
        BlocProvider<MangaBloc>(
          create: (context) => MangaBloc(),
        ),
        BlocProvider<MangaRecommendationBloc>(
          create: (context) => MangaRecommendationBloc(),
        ),
        BlocProvider<AnimeRecommendationBloc>(
          create: (context) => AnimeRecommendationBloc(),
        ),
        BlocProvider<AnimeDetailBloc>(
          create: (context) => AnimeDetailBloc(),
        ),
      ],
      child: const MaterialApp(
        home: ConnectivityWrapper(),
      ),
    );
  }
}

class ConnectivityWrapper extends StatefulWidget {
  const ConnectivityWrapper({super.key});

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    try {
      setState(() {
      });
    } catch (e) {
      debugPrint('Connectivity check failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream: Connectivity().onConnectivityChanged.map((results) => results.first),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final connectivityResult = snapshot.data;
          if (connectivityResult == ConnectivityResult.none) {
            return OfflineScreen(onRetry: _checkConnectivity);
          } else {
            return const SplashScreen();
          }
        } else if (snapshot.hasError ||
            snapshot.data == ConnectivityResult.none) {
          return OfflineScreen(onRetry: _checkConnectivity);
        } else {
          return const SplashScreen();
        }
      },
    );
  }
}