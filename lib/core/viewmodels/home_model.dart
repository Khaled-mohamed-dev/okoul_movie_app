import 'dart:async';
import 'package:okuol_movie_app/core/models/models.dart';
import 'package:okuol_movie_app/core/services/api.dart';
import 'package:okuol_movie_app/locator.dart';
import 'package:stacked/stacked.dart';


class HomeModel extends BaseViewModel {
  final ApiService apiService = locator<ApiService>();
  Future<List<Movie>> getNowPlayingMovies() async {
    return await apiService.getNowPlayingMovies().then(
          (value) => value?.movies ?? [],
        );
  }

  Future<List<Movie>> getUpcomingMovies() async {
    return await apiService.getUpcomingMovies().then(
          (value) => value?.movies ?? [],
        );
  }

  Future<List<Movie>> getMoviesByGenre(int genreId) async {
    return await apiService.getMoviesByGenre(genreId).then(
          (value) => value?.movies ?? [],
        );
  }

  Future<List<Genre>> getGenres() async {
    return await apiService.getGenres().then((value) => value ?? []);
  }

}
