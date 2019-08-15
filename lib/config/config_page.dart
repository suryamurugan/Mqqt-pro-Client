import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_pro_client/utils/devfest.dart';
import 'index.dart';
import 'package:mqtt_pro_client/home/home_page.dart';
import 'package:mqtt_pro_client/addbroker.dart';
import 'package:mqtt_pro_client/notmain.dart';
/*
import 'package:mqtt_client_app/pubsub/addnewsubtopic.dart';
import 'package:mqtt_client_app/pubsub/agenda_page.dart';
import 'package:mqtt_client_app/config/index.dart';
import 'package:mqtt_client_app/home/home_page.dart';
import 'package:mqtt_client_app/utils/devfest.dart';
*/
class ConfigPage extends StatefulWidget {
  static const String routeName = "/";
  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  ConfigBloc configBloc;

  @override
  void initState() {
    super.initState();
    setupApp();
  }

  setupApp() {
    configBloc = ConfigBloc();
    configBloc.darkModeOn =
        Devfest.prefs.getBool(Devfest.darkModePref) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (context) => configBloc,
      child: BlocBuilder<ConfigBloc, ConfigState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'MQTT CLIENT',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              //* Custom Google Font
              fontFamily: Devfest.google_sans_family,
              primarySwatch: Colors.red,
              primaryColor: configBloc.darkModeOn ? Colors.black : Colors.white,
              disabledColor: Colors.grey,
              cardColor: configBloc.darkModeOn ? Colors.black : Colors.white,
              canvasColor:
                  configBloc.darkModeOn ? Colors.black : Colors.grey[50],
              brightness:
                  configBloc.darkModeOn ? Brightness.dark : Brightness.light,
              buttonTheme: Theme.of(context).buttonTheme.copyWith(
                  colorScheme: configBloc.darkModeOn
                      ? ColorScheme.dark()
                      : ColorScheme.light()),
              appBarTheme: AppBarTheme(
                elevation: 0.0,
              ),
            ),
            home: HomePage(),
            routes: {
              HomePage.routeName: (context) => HomePage(),
              AddBrokerPage.routeName: (context) => AddBrokerPage(),
              NotMain.routeName: (context) => NotMain(),

           //   AgendaPage.routeName: (context) => AgendaPage(),
            //  AddNewSubTopicPage.routeName: (context) => AddNewSubTopicPage()
            },
          );
        },
      ),
    );
  }
}
