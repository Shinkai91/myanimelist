import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myanimelist/bloc/seasonal_bloc.dart';
import 'package:myanimelist/bloc/archive_bloc.dart';
import 'package:myanimelist/model/seasonal.dart';
import 'package:shimmer/shimmer.dart';

class SeasonalScreen extends StatelessWidget {
  const SeasonalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SeasonalAnimeBloc()
            ..add(FetchSeasonalAnimeBySeason(
                _getCurrentYear(), _getCurrentSeason())),
        ),
        BlocProvider(
          create: (context) => ArchiveBloc()..add(FetchArchiveData()),
        ),
      ],
      child: const SeasonalView(),
    );
  }

  static int _getCurrentYear() {
    return DateTime.now().year;
  }

  static String _getCurrentSeason() {
    final month = DateTime.now().month;
    if (month >= 1 && month <= 3) {
      return 'winter';
    } else if (month >= 4 && month <= 6) {
      return 'spring';
    } else if (month >= 7 && month <= 9) {
      return 'summer';
    } else {
      return 'fall';
    }
  }

  static String getNextSeason(String currentSeason) {
    const seasons = ['winter', 'spring', 'summer', 'fall'];
    int currentIndex = seasons.indexOf(currentSeason);
    int nextIndex = (currentIndex + 1) % seasons.length;
    return seasons[nextIndex];
  }

  static String getLastSeason(String currentSeason) {
    const seasons = ['winter', 'spring', 'summer', 'fall'];
    int currentIndex = seasons.indexOf(currentSeason);
    int lastIndex = (currentIndex - 1 + seasons.length) % seasons.length;
    return seasons[lastIndex];
  }

  static String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}

class SeasonalView extends StatefulWidget {
  const SeasonalView({super.key});

  @override
  State<SeasonalView> createState() => _SeasonalViewState();
}

class _SeasonalViewState extends State<SeasonalView> {
  String selectedNav = 'This Season';
  String selectedFilter = 'Members';
  late String currentSeason;
  late int currentYear;
  bool showArchive = false;

  @override
  void initState() {
    super.initState();
    currentYear = SeasonalScreen._getCurrentYear();
    currentSeason = SeasonalScreen._getCurrentSeason();
    _fetchAnime();
  }

  void _fetchAnime() {
    context
        .read<SeasonalAnimeBloc>()
        .add(FetchSeasonalAnimeBySeason(currentYear, currentSeason));
  }

  void _navigateToSeason(String season) {
    setState(() {
      final thisSeason = SeasonalScreen._getCurrentSeason();
      final thisYear = SeasonalScreen._getCurrentYear();

      if (season == 'Last') {
        currentSeason = SeasonalScreen.getLastSeason(thisSeason);
        currentYear = thisYear;
        if (currentSeason == 'fall') {
          currentYear--;
        }
      } else if (season == 'Next') {
        currentSeason = SeasonalScreen.getNextSeason(thisSeason);
        currentYear = thisYear;
        if (currentSeason == 'winter') {
          currentYear++;
        }
      } else {
        currentSeason = thisSeason;
        currentYear = thisYear;
      }
      selectedNav = season;
      showArchive = false;
      // Reset Bloc state and fetch new data
      context
          .read<SeasonalAnimeBloc>()
          .add(FetchSeasonalAnimeBySeason(currentYear, currentSeason));
    });
  }

  void _showArchive() {
    setState(() {
      showArchive = true;
    });
  }

  void _fetchArchiveAnime(int year, String season) {
    setState(() {
      currentYear = year;
      currentSeason = season;
      showArchive = false;
      context
          .read<SeasonalAnimeBloc>()
          .add(FetchSeasonalAnimeBySeason(currentYear, currentSeason));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Navigation Texts
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      _navigateToSeason('Last');
                    },
                    child: _buildNavText(context, 'Last'),
                  ),
                  GestureDetector(
                    onTap: () {
                      _navigateToSeason('This Season');
                    },
                    child: _buildNavText(context, 'This Season'),
                  ),
                  GestureDetector(
                    onTap: () {
                      _navigateToSeason('Next');
                    },
                    child: _buildNavText(context, 'Next'),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showArchive();
                    },
                    child: _buildNavText(context, 'Archive'),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // Dropdowns and Season Text
              if (!showArchive) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDropdown(
                        ['TV', 'ONA', 'OVA', 'Movie', 'Special', 'TV Special']),
                    Text(
                      '${SeasonalScreen.capitalize(currentSeason)} $currentYear',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildIconDropdown(),
                  ],
                ),
                const SizedBox(height: 16.0),
              ],

              // Content
              if (showArchive)
                BlocBuilder<ArchiveBloc, ArchiveState>(
                  builder: (context, state) {
                    if (state is ArchiveLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ArchiveLoaded) {
                      return Column(
                        children: state.archives.map((archive) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  '${archive.year}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: archive.seasons.map((season) {
                                  return GestureDetector(
                                    onTap: () {
                                      _fetchArchiveAnime(archive.year, season);
                                    },
                                    child: Chip(
                                      label: Text(
                                          SeasonalScreen.capitalize(season)),
                                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                                      labelStyle: TextStyle(
                                        color: currentYear == archive.year &&
                                                currentSeason == season
                                            ? Colors.blue
                                            : Colors.black,
                                      ),  
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 16.0),
                            ],
                          );
                        }).toList(),
                      );
                    } else if (state is ArchiveError) {
                      return Center(child: Text(state.message));
                    } else {
                      return const Center(child: Text('No data'));
                    }
                  },
                )
              else
                BlocBuilder<SeasonalAnimeBloc, SeasonalAnimeState>(
                  builder: (context, state) {
                    if (state is SeasonalAnimeLoading) {
                      return _buildShimmerGrid();
                    } else if (state is SeasonalAnimeLoaded) {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: state.animes.length,
                        itemBuilder: (context, index) {
                          return _buildAnimeCard(state.animes[index]);
                        },
                      );
                    } else if (state is SeasonalAnimeError) {
                      return Center(child: Text(state.message));
                    } else {
                      return _buildShimmerGrid();
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavText(BuildContext context, String text) {
    return GestureDetector(
      onTap: () {
        if (text == 'Archive') {
          _showArchive();
        } else {
          _navigateToSeason(text);
        }
      },
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: selectedNav == text ? Colors.blue : Colors.black,
        ),
      ),
    );
  }

  Widget _buildDropdown(List<String> items) {
    return DropdownButton<String>(
      dropdownColor: Colors.white,
      value: items.first,
      onChanged: (String? newValue) {
        // Handle dropdown change
      },
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildIconDropdown() {
    return DropdownButton<String>(
      dropdownColor: Colors.white,
      value: selectedFilter,
      icon: const Icon(Icons.filter_list),
      onChanged: (String? newValue) {
        setState(() {
          selectedFilter = newValue!;
        });
      },
      items: <String>['Members', 'Start Date', 'Score']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildAnimeCard(SeasonalAnime? anime) {
    if (anime == null) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                    image: DecorationImage(
                      image: NetworkImage('https://via.placeholder.com/150'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Score: 8.5',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        Text(
                          'Members: 100K',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Anime Title',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Genre',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(anime.images.jpg.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Score: ${anime.score == 0.0 ? 'N/A' : anime.score}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                        Text(
                          'Members: ${anime.members}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                anime.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                anime.genres.map((genre) => genre.name).join(', '),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.7,
      ),
      itemCount: 4, // Number of shimmer items
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        );
      },
    );
  }
}