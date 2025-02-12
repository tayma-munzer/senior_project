class Artwork {
  final int id;
  final String title;
  final String poster;
  final int done;

  Artwork({
    required this.id,
    required this.title,
    required this.poster,
    required this.done,
  });

  factory Artwork.fromJson(Map<String, dynamic> json) {
    return Artwork(
      id: json['id'],
      title: json['title'],
      poster: json['poster'],
      done: json['done'] is bool ? (json['done'] ? 1 : 0) : json['done'] ?? 0,
    );
  }
}
