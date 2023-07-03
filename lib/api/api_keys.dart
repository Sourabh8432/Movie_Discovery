import 'package:tmdb_api/tmdb_api.dart';
import '../appUtilites/app_constants.dart';


class MovieData {




  Future<void> authenticateAndCreateSession() async {
    // Initialize the TMDB API with your API key and read access token
    TMDB tmdbAuthCustomLog = TMDB(
      ApiKeys(AppConstants.apiKey, AppConstants.accessToken),
      logConfig: const ConfigLogger.showAll(),
    );

    try {
      // Create a new session

      final requestTokenResponse = await tmdbAuthCustomLog.v3.auth
          .createRequestToken();
      print('requestTokenResponse: $requestTokenResponse');

      final sessionDetails = await tmdbAuthCustomLog.v3.auth.createRequestToken();
      // String? sessionId = sessionDetails?['request_token'];

      print('sessionId: $sessionDetails');

      if (sessionDetails != null) {
        // Get account details
        final accountDetails = await tmdbAuthCustomLog.v3.account.getDetails(sessionDetails);
        print('accountDetails: $accountDetails');
        final accountId = accountDetails;
        print('accountId: $accountId');
        // Get media details
        final mediaDetails = await tmdbAuthCustomLog.v3.movies.getDetails(550);
        String? mediaId = mediaDetails?['id']?.toString();

        print('Session ID: $sessionDetails');
        // print('Account ID: $accountId');
        print('Media ID: $mediaId');
      } else {
        print('Failed to create session');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<void> addToFavorites(int mediaId, int accountId,String sessionId) async {
    TMDB tmdbAuthCustomLog = TMDB(
      ApiKeys(AppConstants.apiKey, AppConstants.accessToken),
      logConfig: const ConfigLogger.showAll(),
    );
    try {
      final sessionDetails = await tmdbAuthCustomLog.v3.auth.createRequestToken();
      final accountDetails = await tmdbAuthCustomLog.v3.account.getDetails(sessionDetails);
      accountId = accountDetails['account_id'];
      Map<dynamic, dynamic> mediaDetails = await tmdbAuthCustomLog.v3.movies.getDetails(550);
      mediaId = mediaDetails['id'];
      final response = await tmdbAuthCustomLog.v3.account.markAsFavorite(
        sessionDetails,
        accountId,
        mediaId,
          MediaType.movie,
          );
      print(response);
      // if (response.success) {
      //   print('Added to favorites successfully');
      // } else {
      //   print('Failed to add to favorites');
      // }
    } catch (e) {
      print('An error occurred: $e');
    }
  }


}



// Future<void> addToFavorites() async {
//   TMDB tmdbfavCustomLog = TMDB(
//     ApiKeys(AppConstants.apiKey, AppConstants.accessToken),
//     logConfig: const ConfigLogger.showAll(),
//   );
//
//   String sessionId = '';
//   int accountId = 0;
//   int movieId = 0;
//   try {
//     final auth = tmdbfavCustomLog.v3.auth;
//     final token = await auth.createRequestToken();
//
//     final addFavourite = await tmdbfavCustomLog.v3.account.markAsFavorite(
//         sessionId,
//         accountId,
//         mediaId,
//         MediaType.movie,
//     );
//     print(response.statusMessage);
//   } catch (error) {
//     print('Failed to add to favorites: $error');
//   }

//
// Future<void> removeFromFavorites() async {
//   TMDB tmdbfavCustomLog = TMDB(
//     ApiKeys(AppConstants.apiKey, AppConstants.accessToken),
//     logConfig: const ConfigLogger.showAll(),
//   );
//   try {
//     final response = await tmdbRepository.markAsFavorite(
//       MediaType.movie,
//       movieId: 12345, // Replace with the actual movie ID
//       favorite: false,
//     );
//     print(response.statusMessage);
//   } catch (error) {
//     print('Failed to remove from favorites: $error');
//   }
// }
