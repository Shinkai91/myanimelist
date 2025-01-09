class AnimeDetail {
  final int malId;
  final String title;
  final String imageUrl;
  final String trailerUrl;
  final String embedUrl;
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
  final int members;
  final String url;

  AnimeDetail({
    required this.malId,
    required this.title,
    required this.imageUrl,
    required this.trailerUrl,
    required this.embedUrl,
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
    required this.members,
    required this.url,
  });

  factory AnimeDetail.fromJson(Map<String, dynamic> json) {
    return AnimeDetail(
      malId: json['mal_id'] ?? 0,
      title: json['title'] ?? 'No title available',
      imageUrl: json['images']['jpg']['large_image_url'] ?? '',
      trailerUrl: json['trailer']['url'] ?? '',
      embedUrl: json['trailer']['embed_url'] ?? '',
      maximumImageUrl: json['trailer']['images']['maximum_image_url'] ?? '',
      type: json['type'] ?? 'Unknown',
      episodes: json['episodes'] ?? 0,
      status: json['status'] ?? 'Unknown',
      duration: json['duration'] ?? 'Unknown duration',
      score: (json['score'] ?? 0).toDouble(),
      synopsis: json['synopsis'] ?? 'No synopsis available',
      year: json['year'] ?? 0,
      genres: (json['genres'] as List? ?? [])
          .map((genre) => genre['name'] as String)
          .toList(),
      openingSongs: (json['theme']['openings'] as List? ?? [])
          .map((song) => song as String)
          .toList(),
      endingSongs: (json['theme']['endings'] as List? ?? [])
          .map((song) => song as String)
          .toList(),
      rank: json['rank'] ?? 0,
      members: json['members'] ?? 0,
      url: json['url'] ?? '',
    );
  }
}

class MangaDetail {
  final int malId;
  final String title;
  final String imageUrl;
  final String type;
  final int chapters;
  final int volumes;
  final String status;
  final double score;
  final String synopsis;
  final List<String> genres;
  final int rank;
  final String url;

  MangaDetail({
    required this.malId,
    required this.title,
    required this.imageUrl,
    required this.type,
    required this.chapters,
    required this.volumes,
    required this.status,
    required this.score,
    required this.synopsis,
    required this.genres,
    required this.rank,
    required this.url,
  });

  factory MangaDetail.fromJson(Map<String, dynamic> json) {
    return MangaDetail(
      malId: json['mal_id'] ?? 0,
      title: json['title'] ?? 'No title available',
      imageUrl: json['images']['jpg']['large_image_url'] ?? '',
      type: json['type'] ?? 'Unknown',
      chapters: json['chapters'] ?? 0,
      volumes: json['volumes'] ?? 0,
      status: json['status'] ?? 'Unknown',
      score: (json['score'] ?? 0).toDouble(),
      synopsis: json['synopsis'] ?? 'No synopsis available',
      genres: (json['genres'] as List? ?? [])
          .map((genre) => genre['name'] as String)
          .toList(),
      rank: json['rank'] ?? 0,
      url: json['url'] ?? '',
    );
  }
}