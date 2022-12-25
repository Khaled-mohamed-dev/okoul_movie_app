import 'package:drift/drift.dart';
import 'package:okuol_movie_app/core/models/app_database.dart';

class LocalDatabaseService {
  final MyDataBase database;

  LocalDatabaseService(this.database);

  Stream<List<Favorite>> watchFavorites() => database.watchFavorites();

  Future insertMovie(Insertable<Favorite> movie) => database.insertMovie(movie);

  Future deleteMovie(Insertable<Favorite> movie) => database.deleteMovie(movie);
}
