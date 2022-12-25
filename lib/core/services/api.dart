import 'dart:convert';
import 'dart:io';
import 'package:okuol_movie_app/core/constants/endpoints.dart';
import 'package:okuol_movie_app/core/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:okuol_movie_app/tmdb_access_token.dart';

const _headers = {HttpHeaders.authorizationHeader: "Bearer $tmdbAccessToken"};

class ApiService {
  final http.Client client;

  ApiService(this.client);

  Future<MoviesQuery?> getNowPlayingMovies() async {
    final uri = Uri.parse(nowPlayingMoviesUrl);
    try {
      final response = await client.get(
        uri,
        headers: _headers,
      );
      return moviesQueryFromJson(response.body);
    } catch (e) {
      return null;
    }
  }

  Future<MoviesQuery?> getUpcomingMovies() async {
    final uri = Uri.parse(upcomingMoviesUrl);
    try {
      final response = await client.get(uri, headers: {
        HttpHeaders.authorizationHeader: "Bearer $tmdbAccessToken"
      });
      return moviesQueryFromJson(response.body);
    } catch (e) {
      return null;
    }
  }

  Future<MoviesQuery?> getTrendingMovies() async {
    try {
      final uri = Uri.parse(trendingMoviesUrl);
      final response = await client.get(uri, headers: {
        HttpHeaders.authorizationHeader: "Bearer $tmdbAccessToken"
      });
      return moviesQueryFromJson(response.body);
    } catch (e) {
      return null;
    }
  }

  Future<MoviesQuery?> getMoviesByGenre(int genreID) async {
    final uri = Uri.https(
      baseUrl,
      "/3/discover/movie",
      {"with_genres": "$genreID"},
    );
    try {
      final response = await client.get(
        uri,
        headers: _headers,
      );
      return moviesQueryFromJson(response.body);
    } catch (e) {
      return null;
    }
  }

    Future<Movie?> getMovieById(int movieId) async {
    final uri = Uri.https(
      baseUrl,
      "/3/movie/$movieId",
    );
    try {
      final response = await client.get(
        uri,
        headers: _headers,
      );
      return Movie.movieBydFromJson(jsonDecode(response.body)) ;
    } catch (e) {
      return null;
    }
  }


  Future<List<Genre>?> getGenres() async {
    final uri = Uri.parse(genresUrl);
    try {
      final response = await client.get(
        uri,
        headers: _headers,
      );
      return genresQueryFromJson(response.body).genres;
    } catch (e) {
      return null;
    }
  }

  Future<List<Cast>?> getCast(int movieId) async {
    final uri = Uri.https(
      baseUrl,
      "/3/movie/$movieId/credits",
    );

    try {
      final response = await client.get(
        uri,
        headers: _headers,
      );
      return castQueryFromJson(response.body).cast;
    } catch (e) {
      return null;
    }
  }
}
