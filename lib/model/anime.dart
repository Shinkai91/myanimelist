class Anime {
  final int malId;
  final String title;
  final String imageUrl;
  final double score;
  final String? filter;
  final String? trailerImageUrl;

  Anime({
    required this.malId,
    required this.title,
    required this.imageUrl,
    required this.score,
    this.filter,
    this.trailerImageUrl,
  });

  factory Anime.fromJson(Map<String, dynamic> json, {String? filter}) {
    return Anime(
      malId: json['mal_id'] as int,
      title: json['title'] as String,
      imageUrl: json['images']['jpg']['image_url'] as String,
      score: (json['score'] ?? 0).toDouble(),
      filter: filter,
      trailerImageUrl: json['trailer']?['images']?['maximum_image_url'],
    );
  }
}
