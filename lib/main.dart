import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uasapp/view/homeScreen.dart';
import 'package:uasapp/view/screen_onboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var prefs = await SharedPreferences.getInstance();
  var boolKey = 'isFirstTime';
  var isFirstTime = prefs.getBool(boolKey) ?? true;

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Basic Banking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        hintColor: Colors.transparent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isFirstTime
          ? ScreenOnBoarding(
              prefs: prefs,
              boolKey: boolKey,
            )
          : HomeScreen()));
}
