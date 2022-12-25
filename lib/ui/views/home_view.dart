import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:okuol_movie_app/core/constants/colors.dart';
import 'package:okuol_movie_app/core/models/genre.dart';
import 'package:okuol_movie_app/core/models/movies.dart';
import 'package:okuol_movie_app/core/viewmodels/home_model.dart';
import 'package:okuol_movie_app/ui/views/movie_details.dart';
import 'package:okuol_movie_app/ui/views/trending_view.dart';
import 'package:okuol_movie_app/ui/widgets/image_card.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';
import 'favorites_view.dart';
import 'dart:math' as math;

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.nonReactive(
      viewModelBuilder: () => HomeModel(),
      builder: (context, model, __) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Image.asset(
              "assets/app-bar-icon.png",
              height: kToolbarHeight - 10,
            ),
            actions: [
              IconButton(
                color: kcSecondaryColor,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoritesView(),
                    ),
                  );
                },
                icon: const Icon(Ionicons.heart),
              )
            ],
            leading: IconButton(
                color: kcSecondaryColor,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TrendingView(),
                    ),
                  );
                },
                icon: const Icon(Ionicons.flame)),
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),
                NowPlayingList(model: model),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .03,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    children: [
                      _UpcomingList(model: model),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .03),
                      _MoviesByGenreList(model: model)
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class NowPlayingList extends StatefulWidget {
  const NowPlayingList({
    super.key,
    required this.model,
  });
  final HomeModel model;

  @override
  State<NowPlayingList> createState() => _NowPlayingListState();
}

class _NowPlayingListState extends State<NowPlayingList> {
  late Future<List<Movie>> future;
  @override
  void initState() {
    future = widget.model.getNowPlayingMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .5,
      width: double.infinity,
      child: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<Movie> data = snapshot.data ?? [];
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Now Playing",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .02,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .4,
                  child: _Carousel(data: data),
                ),
              ],
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}

class _UpcomingList extends StatefulWidget {
  const _UpcomingList({required this.model});
  final HomeModel model;

  @override
  State<_UpcomingList> createState() => _UpcomingListState();
}

class _UpcomingListState extends State<_UpcomingList> {
  late Future<List<Movie>> future;
  @override
  void initState() {
    future = widget.model.getUpcomingMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          "Upcoming",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .02,
        ),
        _MoviesList(moviesData: future),
      ],
    );
  }
}

class _MoviesByGenreList extends StatefulWidget {
  const _MoviesByGenreList({required this.model});
  final HomeModel model;

  @override
  State<_MoviesByGenreList> createState() => __MoviesByGenreListState();
}

class __MoviesByGenreListState extends State<_MoviesByGenreList> {
  late Future<List<Genre>> future;
  @override
  void initState() {
    // Only get the categories list once as it doesn;t change
    future = widget.model.getGenres();
    super.initState();
  }

  // The initial genre id which is Action genre
  int genreId = 28;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        } else {
          var data = snapshot.data;
          if (data == null) {
            return const Text("server error");
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Discover Movies By Category",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .02,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .05,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      Genre genre = data[index];
                      return GestureDetector(
                        onTap: () {
                          setState(
                            () {
                              genreId = genre.id;
                            },
                          );
                        },
                        child: Container(
                          margin: index != (data.length - 1)
                              ? const EdgeInsets.only(right: 12)
                              : null,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: genreId == genre.id
                                  ? kcSecondaryColor
                                  : kcAccentColor),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              genre.name,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .02,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: _MoviesList(
                    moviesData: widget.model.getMoviesByGenre(genreId),
                  ),
                )
              ],
            );
          }
        }
      },
    );
  }
}

class _Carousel extends StatefulWidget {
  const _Carousel({required this.data});
  final List<Movie> data;
  @override
  State<_Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<_Carousel> {
  int page = 2;
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect rect) {
        return const LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [
            Color.fromARGB(255, 255, 255, 255),
            Colors.transparent,
            Colors.transparent,
            Color.fromARGB(255, 255, 255, 255)
          ],
          stops: [0.0, 0.1, 0.9, 1.0],
        ).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: AlignmentDirectional.center,
        children: [
          PageView.builder(
            scrollDirection: Axis.horizontal,
            controller: PageController(
              viewportFraction: .6,
              initialPage: 2,
            ),
            onPageChanged: (value) {
              setState(() {
                page = value;
              });
            },
            // Make sure to always get 5 movies or less
            itemCount: math.min(5, widget.data.length),
            itemBuilder: (context, index) {
              Movie movie = widget.data[index];
              String? poster = movie.posterPath;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailsView(movie: movie),
                        ),
                      );
                    },
                    child: AnimatedContainer(
                      margin: index != page
                          ? const EdgeInsets.only(top: 50)
                          : const EdgeInsets.only(bottom: 30),
                      duration: const Duration(milliseconds: 350),
                      child: GestureDetector(
                        child: ImageCard(imageUrl: poster),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            bottom: -20,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * .5,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (int i = 0; i < 5; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: i == page ? kcSecondaryColor : Colors.white,
                      ),
                      width: i == page ? 40 : 10,
                      height: 10,
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _MoviesList extends StatefulWidget {
  const _MoviesList({required this.moviesData});
  final Future<List<Movie>> moviesData;

  @override
  State<_MoviesList> createState() => _MoviesListState();
}

class _MoviesListState extends State<_MoviesList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.moviesData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null) {
            return const Center(child: Text("No Connection"));
          } else {
            var data = snapshot.data ?? [];
            return SizedBox(
              height: MediaQuery.of(context).size.height * .25,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: math.min(10, data.length),
                itemBuilder: (BuildContext context, int index) {
                  var movie = data[index];
                  var poster = movie.posterPath;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                MovieDetailsView(movie: movie),
                          ),
                        );
                      },
                      child: LayoutBuilder(builder: (context, constraints) {
                        return ImageCard(imageUrl: poster);
                      }),
                    ),
                  );
                },
              ),
            );
          }
        } else {
          return SizedBox(
            height: MediaQuery.of(context).size.height * .25,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: 5,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Shimmer.fromColors(
                      baseColor: const Color(0xff25325e),
                      highlightColor: kcAccentColor,
                      child: Image.asset(
                        "assets/no-image.jpg",
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
