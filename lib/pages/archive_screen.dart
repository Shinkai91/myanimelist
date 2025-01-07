import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myanimelist/bloc/archive_bloc.dart';
import 'package:myanimelist/pages/seasonal_screen.dart';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArchiveBloc()..add(FetchArchiveData()),
      child: const ArchiveView(),
    );
  }
}

class ArchiveView extends StatelessWidget {
  const ArchiveView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Archive'),
      ),
      body: BlocBuilder<ArchiveBloc, ArchiveState>(
        builder: (context, state) {
          if (state is ArchiveLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ArchiveLoaded) {
            return ListView.builder(
              itemCount: state.archives.length,
              itemBuilder: (context, index) {
                final archive = state.archives[index];
                return ExpansionTile(
                  title: Text('${archive.year}'),
                  children: archive.seasons.map((season) {
                    return ListTile(
                      title: Text(season),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SeasonalScreen(
                              year: archive.year,
                              season: season,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              },
            );
          } else if (state is ArchiveError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}