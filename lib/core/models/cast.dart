
import 'dart:convert';

CastQuery castQueryFromJson(String str) => CastQuery.fromJson(json.decode(str));

class CastQuery {
  CastQuery({
    required this.id,
    required this.cast,
  });

  final int id;
  final List<Cast> cast;

  factory CastQuery.fromJson(Map<String, dynamic> json) => CastQuery(
        id: json["id"],
        cast: List<Cast>.from(json["cast"].map((x) => Cast.fromJson(x))),
      );
}

class Cast {
  Cast({
    required this.id,
    required this.name,
    required this.profilePath,
    required this.character,
    required this.gender,
  });

  final int id;
  final String name;
  final String? profilePath;
  final String character;
  final int? gender;

  factory Cast.fromJson(Map<String, dynamic> json) => Cast(
        id: json["id"],
        name: json["name"],
        profilePath: json["profile_path"],
        character: json["character"],
        gender: json["gender"],
      );
}
