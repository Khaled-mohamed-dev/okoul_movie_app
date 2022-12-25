import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:okuol_movie_app/core/constants/colors.dart';
import 'package:okuol_movie_app/core/models/app_database.dart';
import 'package:okuol_movie_app/core/models/movies.dart';
import 'package:okuol_movie_app/core/viewmodels/movie_details_model.dart';
import 'package:okuol_movie_app/ui/widgets/favorite_button.dart';
import 'package:okuol_movie_app/ui/widgets/image_card.dart';
import 'package:stacked/stacked.dart';

class MovieDetailsView extends StatelessWidget {
  const MovieDetailsView({Key? key, required this.movie}) : super(key: key);
  final Movie movie;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return ViewModelBuilder.nonReactive(
      builder: (BuildContext context, MovieDetailsModel model, Widget? child) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                ListView(
                  children: [
                    movie.posterPath != null
                        ? SizedBox(
                            height: height * .5,
                            child: ShaderMask(
                              shaderCallback: (rect) {
                                return const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.black, Colors.transparent],
                                ).createShader(Rect.fromLTRB(
                                    0, 0, rect.width, rect.height));
                              },
                              blendMode: BlendMode.dstIn,
                              child: Image.network(
                                  "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                                  fit: BoxFit.cover,
                                  alignment: Alignment.topCenter),
                            ),
                          )
                        : const SizedBox(),
                    SizedBox(height: height * .02),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _VotingInfo(movie: movie),
                          SizedBox(height: height * .02),
                          Text(
                            movie.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: height * .02),
                          _RelatedCategories(
                            movie: movie,
                            height: height,
                            model: model,
                          ),
                          SizedBox(height: height * .02),
                          Text(
                            movie.overview,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(height: height * .02),
                          _CastList(
                            height: height,
                            movie: movie,
                            model: model,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 20,
                  left: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      color: kcSecondaryColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      alignment: Alignment.center,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Ionicons.arrow_back,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: FavoriteButton(
                    movie: Favorite(id: movie.id, imageUrl: movie.posterPath),
                  ),
                )
              ],
            ),
          ),
        );
      },
      viewModelBuilder: () => MovieDetailsModel(),
    );
  }
}

class _VotingInfo extends StatelessWidget {
  const _VotingInfo({required this.movie});
  final Movie movie;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xffecb716),
            borderRadius: BorderRadius.circular(200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "IMBD ${movie.voteAverage}",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * .1),
        Text(
          "${movie.voteCount} votes",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}

class _RelatedCategories extends StatelessWidget {
  const _RelatedCategories(
      {required this.movie, required this.height, required this.model});

  final Movie movie;
  final double height;
  final MovieDetailsModel model;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: model.getGenres(),
      builder: (context, snapshot) {
        var data = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        } else {
          if (data == null) {
            return const SizedBox();
          } else {
            var genres = data
                .where(
                  (genre) => movie.genreIds.contains(
                    genre.id,
                  ),
                )
                .toList();
            return SizedBox(
              height: height * .05,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: genres.length,
                itemBuilder: ((context, index) => Container(
                      margin: const EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                        color: kcAccentColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Center(
                          child: Text(
                            genres[index].name,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )),
              ),
            );
          }
        }
      },
    );
  }
}

class _CastList extends StatelessWidget {
  const _CastList(
      {required this.height, required this.movie, required this.model});
  final double height;
  final Movie movie;
  final MovieDetailsModel model;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: model.getCast(movie.id),
      builder: (context, snapshot) {
        var data = snapshot.data;
        if (data == null) {
          return const SizedBox();
        } else if (data.isEmpty) {
          return const SizedBox();
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "cast",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: height * .02),
              SizedBox(
                height: height * .3,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: min(10, data.length),
                  itemBuilder: ((context, index) {
                    var castMember = data[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ImageCard(
                            imageUrl: castMember.profilePath,
                            height: MediaQuery.of(context).size.height * .25,
                            gender: castMember.gender,
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * .01),
                          Text(
                            castMember.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              )
            ],
          );
        }
      },
    );
  }
}
