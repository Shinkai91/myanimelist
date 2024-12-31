class AnimeDetail {
  final int malId;
  final String title;
  final String imageUrl;
  final String trailerUrl;
  final String maximumImageUrl;
  final String type;
  final int episodes;
  final String status;
  final String duration;
  final double score;
  final String synopsis;
  final int year;
  final List<String> genres;
  final List<String> openingSongs;
  final List<String> endingSongs;
  final int rank;

  AnimeDetail({
    required this.malId,
    required this.title,
    required this.imageUrl,
    required this.trailerUrl,
    required this.maximumImageUrl,
    required this.type,
    required this.episodes,
    required this.status,
    required this.duration,
    required this.score,
    required this.synopsis,
    required this.year,
    required this.genres,
    required this.openingSongs,
    required this.endingSongs,
    required this.rank,
  });

  factory AnimeDetail.fromJson(Map<String, dynamic> json) {
    return AnimeDetail(
      malId: json['mal_id'],
      title: json['title'],
      imageUrl: json['images']['jpg']['large_image_url'],
      trailerUrl: json['trailer']['url'] ?? '',
      maximumImageUrl: json['trailer']['images']['maximum_image_url'] ?? '',
      type: json['type'],
      episodes: json['episodes'],
      status: json['status'],
      duration: json['duration'],
      score: (json['score'] ?? 0).toDouble(),
      synopsis: json['synopsis'] ?? '',
      year: json['year'] ?? 0,
      genres: (json['genres'] as List)
          .map((genre) => genre['name'] as String)
          .toList(),
      openingSongs: (json['theme']['openings'] as List)
          .map((song) => song as String)
          .toList(),
      endingSongs: (json['theme']['endings'] as List)
          .map((song) => song as String)
          .toList(),
      rank: json['rank'] ?? 0,
    );
  }
}