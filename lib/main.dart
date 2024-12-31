import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myanimelist/bloc/anime_bloc.dart';
import 'package:myanimelist/pages/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyAnimeList());
}


class MyAnimeList extends StatelessWidget {
  const MyAnimeList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AnimeBloc(),
      child: const MaterialApp(
        home: HomeScreen(),
      ),
    );
  }
}