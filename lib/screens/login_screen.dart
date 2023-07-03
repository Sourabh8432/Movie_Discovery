import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';

import '../appUtilites/app_constants.dart';
import 'home_screen.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  Timer? _timer;
  late double _progress;
  ThemeMode _themeMode = ThemeMode.light;

  void toggleThemeMode() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FlutterLogo(
              size: 100.0,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: AppConstants.userName,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: AppConstants.userPass,
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  login();
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(
                      ),
                    ));

                // TODO: Handle login button press
              },
              child: Text(AppConstants.login),
            ),
          ],
        ),
      ),
    );
  }

  void login() async {
    TMDB tmdbAuthCustomLog = TMDB(
      ApiKeys(AppConstants.apiKey, AppConstants.accessToken),
      logConfig: const ConfigLogger.showAll(),
    );
    try {
      Map<String, dynamic> result =
          await tmdbAuthCustomLog.v3.auth.createSessionWithLogin(
        _usernameController.text.toString(),
        _passwordController.text.toString(),
      );
      print(result);

      String accountId = result['account_id'];

      print(accountId);
    } catch (e) {
      print(AppConstants.errorOccurred + ' :'+'$e');
    }
  }
}
