import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movieapp/appUtilites/app_constants.dart';
import 'package:movieapp/screens/movie_details_screen.dart';
import 'package:movieapp/screens/search_screen.dart';
import 'package:tmdb_api/tmdb_api.dart';
import '../appUtilites/Icons.dart';
import '../appUtilites/app_circular_loader.dart';
import '../appUtilites/app_colors.dart';
import '../appUtilites/theme_data.dart';

class HomeScreen extends StatefulWidget {


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
bool modeChange = true;
class _HomeScreenState extends State<HomeScreen> {


  @override

  // void fetchMovieData() async {
  //
  //   // authenticateAndCreateSession();
  // }
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      showMovieData();
    });

  }



  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: modeChange? ThemeClass.lightTheme: ThemeClass.darkTheme,
      darkTheme: ThemeClass.darkTheme,
      themeMode: ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            AppConstants.appTitle,
          ),
          actions: [
            InkWell(
                onTap: (){
                  setState(() {
                    modeChange =! modeChange;
                  });

                },
                child: Icon(
                  modeChange
                      ? iconLight
                      : iconDark,
                )),
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
                      color: modeChange?blackColor:whiteColor,
                    ))),
          ],
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
                                        builder: (context) => movieDetials(
                                          movieId: movieList[index]['id'],
                                          name: movieList[index]
                                              ['original_title'],
                                          rating: movieList[index]['vote_average']
                                              .toString(),
                                          releaseDate: movieList[index]
                                              ['release_date'],
                                          backdropPath: AppConstants.imageUrl +
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
                            style: TextStyle(fontSize: 14),
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
      ),
    );
  }

  List movieList = [];

  Future<void> showMovieData() async {
    try {
      TMDB tmdbCustomLog = TMDB(
        ApiKeys(AppConstants.apiKey, AppConstants.accessToken),
        logConfig: const ConfigLogger.showAll(),
      );

      Map popularMovies = await tmdbCustomLog.v3.movies.getPopular();
      setState(() {
        movieList = popularMovies['results'];
      });
    } catch (error) {
      // Handle any error that occurs during the API request
      print('Error fetching movie data: $error');
    }
  }
}
