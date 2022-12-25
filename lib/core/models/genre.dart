import 'dart:convert';

GenresQuery genresQueryFromJson(String str) =>
    GenresQuery.fromJson(json.decode(str));

class GenresQuery {
  GenresQuery({
    required this.genres,
  });

  List<Genre> genres;

  factory GenresQuery.fromJson(Map<String, dynamic> json) => GenresQuery(
        genres: List<Genre>.from(json["genres"].map((x) => Genre.fromJson(x))),
      );
}

class Genre {
  Genre({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        id: json["id"],
        name: json["name"],
      );
}
