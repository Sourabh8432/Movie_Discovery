import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';
import '../api/api_keys.dart';
import '../appUtilites/Icons.dart';
import '../appUtilites/app_circular_loader.dart';
import '../appUtilites/app_colors.dart';
import '../appUtilites/app_constants.dart';
import '../appUtilites/theme_data.dart';
import 'home_screen.dart';
import 'movie_details_screen.dart';

class searchScreen extends StatefulWidget {

  @override
  State<searchScreen> createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {
  TextEditingController _searchController = TextEditingController();
  final MovieData data = MovieData();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: modeChange? ThemeClass.lightTheme: ThemeClass.darkTheme,
      darkTheme: ThemeClass.darkTheme,
      themeMode: ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          // iconTheme: IconThemeData(color: blackColor),
          elevation: 0,
          title: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(

              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: TextField(
                controller: _searchController,
                onSubmitted: (value){
                  setState(() {
                    searchByTitle(_searchController.text.toString());
                  });
                },
                decoration: InputDecoration(
                  prefixIcon:  Icon(iconSearch),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        searchByTitle(_searchController.text.toString());
                      });
                    },
                  ),
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 1,
                    childAspectRatio: 0.67,
                  ),
                  itemCount: SearchmovieList.length,
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
                                          movieId: SearchmovieList[index]['id'],
                                          name: SearchmovieList[index]
                                          ['original_title'],
                                          rating: SearchmovieList[index]['vote_average']
                                              .toString(),
                                          releaseDate: SearchmovieList[index]
                                          ['release_date'],
                                          backdropPath: SearchmovieList[index]['backdrop_path'] != null ? AppConstants.imageUrl +
                                              SearchmovieList[index]['backdrop_path'] : '',
                                          language: SearchmovieList[index]
                                          ['original_language'],
                                          overView: SearchmovieList[index]['overview'],
                                          popularity: SearchmovieList[index]
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
                                          image: NetworkImage(SearchmovieList[index]['poster_path']!=null?AppConstants
                                              .imageUrl +
                                              SearchmovieList[index]['poster_path']:''),
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
                                    SearchmovieList[index]['vote_average'].toString(),
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
                            SearchmovieList[index]['original_title'].length >= 40 ? SearchmovieList[index]['original_title'].substring(0, 15)+'...' :SearchmovieList[index]['original_title'],
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  List SearchmovieList = [];

  Future<void> searchByTitle(String query) async {
    AppLoaderProgress.showLoader(context);

    try {
      TMDB tmdbsearchCustomLog = TMDB(
        ApiKeys(AppConstants.apiKey, AppConstants.accessToken),
        logConfig: const ConfigLogger.showAll(),
      );

      final Map searchAllMovie = await tmdbsearchCustomLog.v3.search.queryMovies(query);
      setState(() {
        SearchmovieList = searchAllMovie['results'];
      });
      print(searchAllMovie);
    } catch (error) {
      // Handle any error that occurs during the API request
      print('Error searching movie by title: $error');
    } finally {
      AppLoaderProgress.hideLoader(context);
    }
  }
}


