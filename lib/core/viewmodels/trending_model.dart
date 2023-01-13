import 'package:okuol_movie_app/core/models/models.dart';
import 'package:okuol_movie_app/locator.dart';
import 'package:stacked/stacked.dart';

import '../services/api.dart';

class TrendingModel extends BaseViewModel {
  final ApiService apiService = locator<ApiService>();

  Future<List<Movie>> getTrendingMovies() async {
    return await apiService.getTrendingMovies().then((value) => value);
  }
}
