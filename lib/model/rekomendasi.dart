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

class AnimeRecommendation {
  final int malId;
  final String title;
  final String imageUrl;
  final double score;
  final int members;
  final List<String> genres;

  AnimeRecommendation({
    required this.malId,
    required this.title,
    required this.imageUrl,
    required this.score,
    required this.members,
    required this.genres,
  });

  factory AnimeRecommendation.fromJson(Map<String, dynamic> json) {
    return AnimeRecommendation(
      malId: json['entry'][0]['mal_id'],
      title: json['entry'][0]['title'],
      imageUrl: json['entry'][0]['images']['jpg']['image_url'],
      score: (json['score'] ?? 0).toDouble(),
      members: json['members'] as int,
      genres: (json['genres'] as List?)
              ?.map((genre) => genre['name'] as String)
              .toList() ??
          [],
    );
  }
}