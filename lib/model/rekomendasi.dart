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

  AnimeRecommendation({
    required this.malId,
    required this.title,
    required this.imageUrl,
  });

  factory AnimeRecommendation.fromJson(Map<String, dynamic> json) {
    return AnimeRecommendation(
      malId: json['entry'][0]['mal_id'],
      title: json['entry'][0]['title'],
      imageUrl: json['entry'][0]['images']['jpg']['image_url'],
    );
  }
}