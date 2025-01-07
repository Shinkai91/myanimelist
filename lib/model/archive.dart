class Archive {
  final int year;
  final List<String> seasons;

  Archive({required this.year, required this.seasons});

  factory Archive.fromJson(Map<String, dynamic> json) {
    return Archive(
      year: json['year'],
      seasons: List<String>.from(json['seasons']),
    );
  }
}