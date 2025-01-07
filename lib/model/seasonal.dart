class SeasonalAnimeResponse {
  final List<SeasonalAnime> data;
  final Pagination pagination;

  SeasonalAnimeResponse({required this.data, required this.pagination});

  factory SeasonalAnimeResponse.fromJson(Map<String, dynamic> json) {
    return SeasonalAnimeResponse(
      data: (json['data'] as List)
          .map((anime) => SeasonalAnime.fromJson(anime))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}

class SeasonalAnime {
  final int malId;
  final String url;
  final Images images;
  final Trailer trailer;
  final bool approved;
  final List<Title> titles;
  final String title;
  final String titleEnglish;
  final String titleJapanese;
  final List<String> titleSynonyms;
  final String type;
  final String source;
  final int episodes;
  final String status;
  final bool airing;
  final Aired aired;
  final String duration;
  final String rating;
  final double score;
  final int scoredBy;
  final int rank;
  final int popularity;
  final int members;
  final int favorites;
  final String synopsis;
  final String background;
  final String season;
  final int year;
  final Broadcast broadcast;
  final List<Producer> producers;
  final List<Producer> licensors;
  final List<Producer> studios;
  final List<Genre> genres;
  final List<Genre> explicitGenres;
  final List<Genre> themes;
  final List<Genre> demographics;

  SeasonalAnime({
    required this.malId,
    required this.url,
    required this.images,
    required this.trailer,
    required this.approved,
    required this.titles,
    required this.title,
    required this.titleEnglish,
    required this.titleJapanese,
    required this.titleSynonyms,
    required this.type,
    required this.source,
    required this.episodes,
    required this.status,
    required this.airing,
    required this.aired,
    required this.duration,
    required this.rating,
    required this.score,
    required this.scoredBy,
    required this.rank,
    required this.popularity,
    required this.members,
    required this.favorites,
    required this.synopsis,
    required this.background,
    required this.season,
    required this.year,
    required this.broadcast,
    required this.producers,
    required this.licensors,
    required this.studios,
    required this.genres,
    required this.explicitGenres,
    required this.themes,
    required this.demographics,
  });

  factory SeasonalAnime.fromJson(Map<String, dynamic> json) {
    return SeasonalAnime(
      malId: json['mal_id'] ?? 0,
      url: json['url'] ?? '',
      images: Images.fromJson(json['images'] ?? {}),
      trailer: Trailer.fromJson(json['trailer'] ?? {}),
      approved: json['approved'] ?? false,
      titles: (json['titles'] as List)
          .map((title) => Title.fromJson(title))
          .toList(),
      title: json['title'] ?? '',
      titleEnglish: json['title_english'] ?? '',
      titleJapanese: json['title_japanese'] ?? '',
      titleSynonyms: (json['title_synonyms'] as List)
          .map((synonym) => synonym as String)
          .toList(),
      type: json['type'] ?? '',
      source: json['source'] ?? '',
      episodes: json['episodes'] ?? 0,
      status: json['status'] ?? '',
      airing: json['airing'] ?? false,
      aired: Aired.fromJson(json['aired'] ?? {}),
      duration: json['duration'] ?? '',
      rating: json['rating'] ?? '',
      score: (json['score'] ?? 0).toDouble(),
      scoredBy: json['scored_by'] ?? 0,
      rank: json['rank'] ?? 0,
      popularity: json['popularity'] ?? 0,
      members: json['members'] ?? 0,
      favorites: json['favorites'] ?? 0,
      synopsis: json['synopsis'] ?? '',
      background: json['background'] ?? '',
      season: json['season'] ?? '',
      year: json['year'] ?? 0,
      broadcast: Broadcast.fromJson(json['broadcast'] ?? {}),
      producers: (json['producers'] as List)
          .map((producer) => Producer.fromJson(producer))
          .toList(),
      licensors: (json['licensors'] as List)
          .map((licensor) => Producer.fromJson(licensor))
          .toList(),
      studios: (json['studios'] as List)
          .map((studio) => Producer.fromJson(studio))
          .toList(),
      genres: (json['genres'] as List)
          .map((genre) => Genre.fromJson(genre))
          .toList(),
      explicitGenres: (json['explicit_genres'] as List)
          .map((genre) => Genre.fromJson(genre))
          .toList(),
      themes: (json['themes'] as List)
          .map((theme) => Genre.fromJson(theme))
          .toList(),
      demographics: (json['demographics'] as List)
          .map((demographic) => Genre.fromJson(demographic))
          .toList(),
    );
  }
}

class Images {
  final ImageType jpg;
  final ImageType webp;

  Images({required this.jpg, required this.webp});

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      jpg: ImageType.fromJson(json['jpg'] ?? {}),
      webp: ImageType.fromJson(json['webp'] ?? {}),
    );
  }
}

class ImageType {
  final String imageUrl;
  final String smallImageUrl;
  final String largeImageUrl;

  ImageType({
    required this.imageUrl,
    required this.smallImageUrl,
    required this.largeImageUrl,
  });

  factory ImageType.fromJson(Map<String, dynamic> json) {
    return ImageType(
      imageUrl: json['image_url'] ?? '',
      smallImageUrl: json['small_image_url'] ?? '',
      largeImageUrl: json['large_image_url'] ?? '',
    );
  }
}

class Trailer {
  final String youtubeId;
  final String url;
  final String embedUrl;

  Trailer({
    required this.youtubeId,
    required this.url,
    required this.embedUrl,
  });

  factory Trailer.fromJson(Map<String, dynamic> json) {
    return Trailer(
      youtubeId: json['youtube_id'] ?? '',
      url: json['url'] ?? '',
      embedUrl: json['embed_url'] ?? '',
    );
  }
}

class Aired {
  final String from;
  final String to;
  final Prop prop;

  Aired({required this.from, required this.to, required this.prop});

  factory Aired.fromJson(Map<String, dynamic> json) {
    return Aired(
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      prop: Prop.fromJson(json['prop'] ?? {}),
    );
  }
}

class Prop {
  final FromTo from;
  final FromTo to;
  final String string;

  Prop({required this.from, required this.to, required this.string});

  factory Prop.fromJson(Map<String, dynamic> json) {
    return Prop(
      from: FromTo.fromJson(json['from'] ?? {}),
      to: FromTo.fromJson(json['to'] ?? {}),
      string: json['string'] ?? '',
    );
  }
}

class FromTo {
  final int day;
  final int month;
  final int year;

  FromTo({required this.day, required this.month, required this.year});

  factory FromTo.fromJson(Map<String, dynamic> json) {
    return FromTo(
      day: json['day'] ?? 0,
      month: json['month'] ?? 0,
      year: json['year'] ?? 0,
    );
  }
}

class Genre {
  final int malId;
  final String type;
  final String name;
  final String url;

  Genre({
    required this.malId,
    required this.type,
    required this.name,
    required this.url,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      malId: json['mal_id'] ?? 0,
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

class Title {
  final String type;
  final String title;

  Title({required this.type, required this.title});

  factory Title.fromJson(Map<String, dynamic> json) {
    return Title(
      type: json['type'] ?? '',
      title: json['title'] ?? '',
    );
  }
}

class Broadcast {
  final String day;
  final String time;
  final String timezone;
  final String string;

  Broadcast({
    required this.day,
    required this.time,
    required this.timezone,
    required this.string,
  });

  factory Broadcast.fromJson(Map<String, dynamic> json) {
    return Broadcast(
      day: json['day'] ?? '',
      time: json['time'] ?? '',
      timezone: json['timezone'] ?? '',
      string: json['string'] ?? '',
    );
  }
}

class Producer {
  final int malId;
  final String type;
  final String name;
  final String url;

  Producer({
    required this.malId,
    required this.type,
    required this.name,
    required this.url,
  });

  factory Producer.fromJson(Map<String, dynamic> json) {
    return Producer(
      malId: json['mal_id'] ?? 0,
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

class Pagination {
  final int lastVisiblePage;
  final bool hasNextPage;
  final Items items;

  Pagination({
    required this.lastVisiblePage,
    required this.hasNextPage,
    required this.items,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      lastVisiblePage: json['last_visible_page'] ?? 0,
      hasNextPage: json['has_next_page'] ?? false,
      items: Items.fromJson(json['items'] ?? {}),
    );
  }
}

class Items {
  final int count;
  final int total;
  final int perPage;

  Items({
    required this.count,
    required this.total,
    required this.perPage,
  });

  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(
      count: json['count'] ?? 0,
      total: json['total'] ?? 0,
      perPage: json['per_page'] ?? 0,
    );
  }
}