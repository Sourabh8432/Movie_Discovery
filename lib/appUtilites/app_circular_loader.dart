import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/appUtilites/app_colors.dart';

class AppLoaderProgress extends StatelessWidget {
  const AppLoaderProgress();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: new Center(
        child: new Container(
          padding: const EdgeInsets.all(8.0),
          child: !Platform.isIOS
              ? Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CircularProgressIndicator(color: grayShade300),
                )
              : CupertinoActivityIndicator(
                  radius: 20,
                ),
        ),
      ),
    );

//   BOX LOADER
//
//    Container _loaderView = new Container(
//      color: Colors.black26,
//      child: new Center(
//        child: new Container(
//          height: 75.0,
//          width: 75.0,
//          decoration: BoxDecoration(
//            shape: BoxShape.rectangle,
//            color: Colors.white,
//            borderRadius: new BorderRadius.circular(4.0),
//          ),
//          padding: EdgeInsets.all(15.0),
//          child: new CircularProgressIndicator(),
//        ),
//      ),
//    );
  }
  static void showLoader(BuildContext context){
    showDialog(barrierDismissible:false,context: context, barrierColor:Colors.transparent,builder: (BuildContext context){
            return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: new Center(
          child: new Container(
            padding: const EdgeInsets.all(8.0),
            child: !Platform.isIOS
                ? Padding(
              padding: const EdgeInsets.all(4.0),
              child: CircularProgressIndicator(color: grayShade300,),
            )
                : CupertinoActivityIndicator(
              radius: 20,
            ),
          ),
        ),
      );
      }
    );
  }
  static void hideLoader(BuildContext context){
    Navigator.pop(context);
  }
}
