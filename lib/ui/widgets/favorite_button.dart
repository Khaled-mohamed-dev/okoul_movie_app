import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:okuol_movie_app/core/constants/colors.dart';
import 'package:okuol_movie_app/core/models/app_database.dart';
import 'package:okuol_movie_app/core/viewmodels/favorites_model.dart';
import 'package:stacked/stacked.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({Key? key, required this.movie}) : super(key: key);
  final Favorite movie;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.nonReactive(
      viewModelBuilder: () => FavoritesModel(),
      builder: ((context, model, child) {
        return StreamBuilder(
          stream: model.watchFavorites(),
          builder: (context, snapshot) {
            var data = snapshot.data ?? [];
            var favorite = data
                .firstWhereOrNull((Favorite element) => element.id == movie.id);
            var isFavorite = favorite == null ? false : true;
            return Container(
              decoration: BoxDecoration(
                color: kcSecondaryColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: IconButton(
                  onPressed: () async {
                    if (!isFavorite) {
                      await model.insertMovie(
                        Favorite(id: movie.id, imageUrl: movie.imageUrl),
                      );
                    } else {
                      await model.deleteMovie(favorite);
                      // model.update();
                    }
                  },
                  icon: Icon(
                    isFavorite ? Ionicons.heart : Ionicons.heart_outline,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
