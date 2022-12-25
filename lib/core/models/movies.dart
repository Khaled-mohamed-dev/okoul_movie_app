import 'dart:convert';

import 'package:okuol_movie_app/core/models/genre.dart';

MoviesQuery moviesQueryFromJson(String str) =>
    MoviesQuery.fromJson(json.decode(str));

class MoviesQuery {
  MoviesQuery({
    required this.page,
    required this.movies,
    required this.totalPages,
    required this.totalResults,
  });

  final int page;
  final List<Movie> movies;
  final int totalPages;
  final int totalResults;

  factory MoviesQuery.fromJson(Map<String, dynamic> json) => MoviesQuery(
        page: json["page"],
        movies: List<Movie>.from(
            json["results"].map((movieJson) => Movie.fromJson(movieJson))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
}

class Movie {
  Movie({
    required this.posterPath,
    required this.overview,
    required this.releaseDate,
    required this.genreIds,
    required this.id,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
  });

  final String? posterPath;
  final String overview;
  final DateTime releaseDate;
  final List<int> genreIds;
  final int id;
  final String title;
  final int voteCount;
  final double voteAverage;

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        posterPath: json["poster_path"],
        overview: json["overview"],
        releaseDate: DateTime.parse(json["release_date"]),
        genreIds: List<int>.from(json["genre_ids"].map((genreId) => genreId)),
        id: json["id"],
        title: json["title"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
      );

  factory Movie.movieBydFromJson(Map<String, dynamic> json) => Movie(
        posterPath: json["poster_path"],
        overview: json["overview"],
        releaseDate: DateTime.parse(json["release_date"]),
        genreIds: List<int>.from(
            json["genres"].map((genre) => Genre.fromJson(genre).id)),
        id: json["id"],
        title: json["title"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
      );
}
