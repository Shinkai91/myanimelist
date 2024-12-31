class Character {
  final int malId;
  final String name;
  final String imageUrl;
  final String role;
  final List<VoiceActor> voiceActors;

  Character({
    required this.malId,
    required this.name,
    required this.imageUrl,
    required this.role,
    required this.voiceActors,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      malId: json['character']['mal_id'],
      name: json['character']['name'],
      imageUrl: json['character']['images']['jpg']['image_url'],
      role: json['role'],
      voiceActors: (json['voice_actors'] as List)
          .map((voiceActor) => VoiceActor.fromJson(voiceActor))
          .toList(),
    );
  }
}

class VoiceActor {
  final int malId;
  final String name;
  final String imageUrl;
  final String language;

  VoiceActor({
    required this.malId,
    required this.name,
    required this.imageUrl,
    required this.language,
  });

  factory VoiceActor.fromJson(Map<String, dynamic> json) {
    return VoiceActor(
      malId: json['person']['mal_id'],
      name: json['person']['name'],
      imageUrl: json['person']['images']['jpg']['image_url'],
      language: json['language'],
    );
  }
}