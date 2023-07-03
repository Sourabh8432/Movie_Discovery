import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movieapp/appUtilites/app_constants.dart';
import 'package:movieapp/screens/movie_details_screen.dart';
import 'package:movieapp/screens/search_screen.dart';
import 'package:tmdb_api/tmdb_api.dart';

import '../api/api_keys.dart';
import '../appUtilites/Icons.dart';
import '../appUtilites/app_colors.dart';

class facoriteScreen extends StatefulWidget {
  @override
  State<facoriteScreen> createState() => _facoriteScreenState();
}

class _facoriteScreenState extends State<facoriteScreen> {
  int? mediaId;
  int? accountId;
  String sessionId = '';

  @override
  void initState() {
    setState(() {
      addToFavorites();
      showMovieData();
    });

    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              AppConstants.appTitle,
              style: Theme
                  .of(context)
                  .brightness == Brightness.dark
                  ? TextStyle(color: whiteColor)
                  : TextStyle(color: blackColor),
            ),
            Spacer(),
            Container(
                alignment: Alignment.center,
                width: 40,
                height: 30,
                child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => searchScreen(),
                          ));
                    },
                    icon: Icon(
                      iconSearch,
                      size: 22,
                      color: Colors.blueAccent,
                    ))),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(vertical: 20),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 1,
                  childAspectRatio: 0.69,
                ),
                itemCount: movieList.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          movieDetials(
                                            movieId: movieList[index]['id'],
                                            name: movieList[index]
                                            ['original_title'],
                                            rating: movieList[index]['vote_average']
                                                .toString(),
                                            releaseDate: movieList[index]
                                            ['release_date'],
                                            backdropPath: AppConstants
                                                .imageUrl +
                                                movieList[index]['backdrop_path'],
                                            language: movieList[index]
                                            ['original_language'],
                                            overView: movieList[index]['overview'],
                                            popularity: movieList[index]
                                            ['popularity']
                                                .toString(),
                                          ),
                                    ));
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 200,
                                width: 140,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(AppConstants
                                            .imageUrl +
                                            movieList[index]['poster_path']),
                                        fit: BoxFit.cover),
                                    color: grayShade300,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: 25,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            width: 50,
                            decoration: BoxDecoration(
                                color: ratingBox,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(9),
                                    bottomLeft: Radius.circular(5))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  iconRating,
                                  color: whiteColor,
                                  size: 15,
                                ),
                                Text(
                                  movieList[index]['vote_average'].toString(),
                                  style: TextStyle(
                                      fontSize: 14, color: blackColor),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 140,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          movieList[index]['original_title'],
                          style: TextStyle(fontSize: 14, color: blackColor),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  List movieList = [];

  void showMovieData() async {
    TMDB tmdbCustomLog = TMDB(
      ApiKeys(AppConstants.apiKey, AppConstants.accessToken),
      logConfig: const ConfigLogger.showAll(),
    );
    Map popularMovies = await tmdbCustomLog.v3.movies.getPopular();
    movieList = popularMovies['results'];
    setState(() {});
    print(movieList);
  }

  Future<void> addToFavorites() async {
    TMDB tmdbAuthCustomLog = TMDB(
      ApiKeys(AppConstants.apiKey, AppConstants.accessToken),
      logConfig: const ConfigLogger.showAll(),
    );

      try {
        final sessionDetails = await tmdbAuthCustomLog.v3.auth.createRequestToken();
        Map popularMovies = await tmdbAuthCustomLog.v3.movies.getPopular();
        movieList = popularMovies['results'];
        mediaId = popularMovies['results']['genre_ids'];
        int accountId = popularMovies['results']['id'];
        final response = await tmdbAuthCustomLog.v3.account.markAsFavorite(
          sessionDetails,
          mediaId! ,
          accountId,
          MediaType.movie,
        );
        print(response);
      } catch (e) {
        print('An error occurred: $e');
      }
    }

  }