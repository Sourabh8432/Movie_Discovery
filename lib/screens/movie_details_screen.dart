import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movieapp/api/api_keys.dart';
import 'package:tmdb_api/tmdb_api.dart';

import '../appUtilites/app_colors.dart';
import '../appUtilites/app_constants.dart';

class movieDetials extends StatefulWidget {
  final String name,
      rating,
      releaseDate,
      backdropPath,
      language,
      overView,
      popularity;
  int movieId;

  movieDetials({
    super.key,
    required this.name,
    required this.rating,
    required this.releaseDate,
    required this.backdropPath,
    required this.language,
    required this.overView,
    required this.popularity,
    required this.movieId,
  });

  @override
  State<movieDetials> createState() => _movieDetialsState();
}

class _movieDetialsState extends State<movieDetials> {
  TextEditingController _ratingController = TextEditingController();

  @override

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    alignment: Alignment.bottomLeft,
                    height: 350,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(right: 20, bottom: 20, left: 20),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: greyColor.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 10), // changes position of shadow
                          ),
                        ],
                        image: DecorationImage(
                            image: NetworkImage(widget.backdropPath),
                            colorFilter: new ColorFilter.mode(
                                blackColor.withOpacity(0.7),
                                BlendMode.multiply),
                            fit: BoxFit.cover),
                        color: grayShade300,
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(30))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: TextStyle(fontSize: 30, color: whiteColor),
                        ),
                        Text(
                          "⭐ Average Rating :- " + widget.rating,
                          style: TextStyle(fontSize: 15, color: whiteColor),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    // color: blackColor,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back,
                            size: 25,
                            color: whiteColor,
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          "Movie Detials",
                          style: TextStyle(
                            fontSize: 18,
                            color: whiteColor,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Card(
                              child: Container(
                                  height: 50,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Release Date",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(widget.releaseDate,
                                          style: TextStyle(
                                              fontSize: 12, color: greyColor)),
                                    ],
                                  )),
                            )),
                        Expanded(
                            flex: 2,
                            child: Card(
                              child: Container(
                                  height: 50,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Popularity",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(widget.popularity,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: greyColor,
                                              fontWeight: FontWeight.w900)),
                                    ],
                                  )),
                            )),
                        Expanded(
                            flex: 1,
                            child: Card(
                              child: Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  child: Text(widget.language)),
                            )),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            maxLength: 3,
                            inputFormatters: [
                              FilteringTextInputFormatter(RegExp(r'^\d+\.?\d{0,1}$'), allow: true),
                            ],
                            controller: _ratingController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: '6.9',
                              labelText: 'Rating',
                            ),
                          ),
                          SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              rateMovie(widget.movieId, double.parse(_ratingController.text));
                            },
                            child: Text('Rate Movie'),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: TextStyle(fontSize: 25),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.overView,
                          style: TextStyle(color: greyColor),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> rateMovie(movieId, rating) async {
    TMDB tmdbAuthCustomLog = TMDB(
      ApiKeys(AppConstants.apiKey, AppConstants.accessToken),
      logConfig: const ConfigLogger.showAll(),
    );
    try {
      final requestTokenResponse = await tmdbAuthCustomLog.v3.auth.createRequestToken();
      print('requestTokenResponse: $requestTokenResponse');

      final sessionDetails = await tmdbAuthCustomLog.v3.auth.createGuestSession();

      print('sessionId: $sessionDetails');
      await tmdbAuthCustomLog.v3.movies.rateMovie(movieId, rating, guestSessionId: sessionDetails ,sessionId: sessionDetails);// i will change this
      print('Movie rated successfully');
    } catch (error) {
      print('Error rating movie: $error');
    }
  }
}
