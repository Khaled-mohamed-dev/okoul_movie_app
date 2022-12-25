import 'package:drift/drift.dart';
import 'package:okuol_movie_app/core/models/app_database.dart';
import 'package:okuol_movie_app/core/models/movies.dart';
import 'package:okuol_movie_app/core/services/api.dart';
import 'package:okuol_movie_app/core/services/local_database.dart';
import 'package:okuol_movie_app/locator.dart';
import 'package:stacked/stacked.dart';

class FavoritesModel extends BaseViewModel {
  final LocalDatabaseService localDatabaseService = locator<LocalDatabaseService>();
  final ApiService apiService = locator<ApiService>();


  Stream<List<Favorite>> watchFavorites() => localDatabaseService.watchFavorites();

  Future insertMovie(Insertable<Favorite> movie) =>
      localDatabaseService.insertMovie(movie);

  Future deleteMovie(Insertable<Favorite> movie) =>
      localDatabaseService.deleteMovie(movie);

  Future<Movie?> getMovieById(int movieId) => apiService.getMovieById(movieId);
}
