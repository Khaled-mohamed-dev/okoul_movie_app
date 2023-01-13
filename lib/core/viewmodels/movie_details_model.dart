import 'package:okuol_movie_app/locator.dart';
import 'package:stacked/stacked.dart';

import '../models/cast.dart';
import '../models/genre.dart';
import '../services/api.dart';

class MovieDetailsModel extends BaseViewModel {
  final ApiService apiService = locator<ApiService>();

  Future<List<Cast>> getCast(int movieId) async {
    return await apiService.getCast(movieId);
  }

  Future<List<Genre>> getGenres() async {
    return await apiService.getGenres();
  }
}
