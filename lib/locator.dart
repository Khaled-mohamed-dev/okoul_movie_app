import 'package:get_it/get_it.dart';
import 'package:okuol_movie_app/core/models/app_database.dart';
import 'package:okuol_movie_app/core/services/api.dart';
import 'package:http/http.dart' as http;
import 'package:okuol_movie_app/core/services/local_database.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  //services
  locator.registerLazySingleton(() => ApiService(locator()));
  locator.registerLazySingleton(() => LocalDatabaseService(locator()));

  locator.registerLazySingleton(() => MyDataBase());
  locator.registerLazySingleton(() => http.Client());
}
