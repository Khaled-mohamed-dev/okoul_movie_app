import 'package:flutter/material.dart';
import 'package:okuol_movie_app/core/viewmodels/favorites_model.dart';
import 'package:okuol_movie_app/ui/views/movie_details.dart';
import 'package:okuol_movie_app/ui/widgets/favorite_button.dart';
import 'package:okuol_movie_app/ui/widgets/image_card.dart';
import 'package:stacked/stacked.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
      ),
      body: ViewModelBuilder.nonReactive(
        viewModelBuilder: () => FavoritesModel(),
        builder: (context, model, child) => SafeArea(
          child: StreamBuilder(
            stream: model.watchFavorites(),
            builder: (context, snapshot) {
              var data = snapshot.data ?? [];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: GridView.builder(
                  itemCount: data.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 9 / 14,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20),
                  itemBuilder: (context, index) {
                    var movie = data[index];
                    return FutureBuilder(
                        future: model.getMovieById(movie.id),
                        builder: (context, snapshot) {
                          var movieData = snapshot.data;
                          return Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (movieData != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MovieDetailsView(movie: movieData),
                                      ),
                                    );
                                  }
                                },
                                child: ImageCard(
                                  imageUrl: movie.imageUrl,
                                ),
                              ),
                              Positioned(
                                right: 10,
                                top: 10,
                                child: FavoriteButton(movie: movie),
                              ),
                            ],
                          );
                        });
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
