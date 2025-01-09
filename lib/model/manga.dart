class Manga {
  final int malId;
  final String title;
  final String imageUrl;
  final String synopsis;
  final String type;
  final int chapters;
  final int volumes;
  final double score;
  final String startDate;
  final String endDate;
  final String filter;
  final List<String> genres;
  final int members;

  Manga({
    required this.malId,
    required this.title,
    required this.imageUrl,
    required this.synopsis,
    required this.type,
    required this.chapters,
    required this.volumes,
    required this.score,
    required this.startDate,
    required this.endDate,
    required this.filter,
    required this.genres,
    required this.members,
  });

  factory Manga.fromJson(Map<String, dynamic> json, {String filter = ''}) {
    return Manga(
      malId: json['mal_id'],
      title: json['title'],
      imageUrl: json['images']['jpg']['large_image_url'],
      synopsis: json['synopsis'] ?? 'No synopsis available',
      type: json['type'] ?? 'Unknown',
      chapters: json['chapters'] ?? 0,
      volumes: json['volumes'] ?? 0,
      score: (json['score'] ?? 0).toDouble(),
      startDate: json['start_date'] ?? 'Unknown',
      endDate: json['end_date'] ?? 'Unknown',
      filter: filter,
      genres: (json['genres'] as List<dynamic>? ?? [])
          .map((genre) => genre['name'] as String)
          .toList(), // Parse genres property
      members: json['members'] ?? 0, 
    );
  }
}

class MangaRecommendation {
  final int malId;
  final String title;
  final String imageUrl;

  MangaRecommendation({
    required this.malId,
    required this.title,
    required this.imageUrl,
  });

  factory MangaRecommendation.fromJson(Map<String, dynamic> json) {
    return MangaRecommendation(
      malId: json['entry'][0]['mal_id'],
      title: json['entry'][0]['title'],
      imageUrl: json['entry'][0]['images']['jpg']['large_image_url'],
    );
  }
}
