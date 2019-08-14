import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils/devfest.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/config_page.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // ? Get Shared Preference Instance for whole app
  Devfest.prefs = await SharedPreferences.getInstance();

  runApp(ConfigPage());
}