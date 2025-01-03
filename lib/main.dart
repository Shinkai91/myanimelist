import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myanimelist/bloc/anime_bloc.dart';
import 'package:myanimelist/bloc/manga_bloc.dart';
import 'package:myanimelist/pages/splash_screen.dart';

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
      ],
      child: const MaterialApp(
        home: SplashScreen(),
      ),
    );
  }
}