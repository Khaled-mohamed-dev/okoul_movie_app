import 'package:flutter/material.dart';
import 'package:okuol_movie_app/core/viewmodels/trending_model.dart';
import 'package:okuol_movie_app/ui/views/movie_details.dart';
import 'package:okuol_movie_app/ui/widgets/image_card.dart';
import 'package:stacked/stacked.dart';

class TrendingView extends StatelessWidget {
  const TrendingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trending"),
      ),
      body: ViewModelBuilder.nonReactive(
        viewModelBuilder: () => TrendingModel(),
        builder: (context, model, child) => SafeArea(
          child: FutureBuilder(
            future: model.getTrendingMovies(),
            builder: (context, snapshot) {
              var data = snapshot.data ?? [];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: GridView.builder(
                  itemCount: data.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 4,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20),
                  itemBuilder: (context, index) {
                    var movie = data[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                MovieDetailsView(movie: movie),
                          ),
                        );
                      },
                      child: ImageCard(
                        imageUrl: movie.posterPath,
                      ),
                    );
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
