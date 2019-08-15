import 'package:flutter/material.dart';
import 'package:mqtt_pro_client/home/index.dart';
import 'package:mqtt_pro_client/universal/dev_scaffold.dart';
import 'package:mqtt_pro_client/addbroker.dart';

import 'package:mqtt_pro_client/config/config_bloc.dart';
import 'package:mqtt_pro_client/config/config_event.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';


class HomePage extends StatelessWidget {
  static const String routeName = "/home";

  @override
  Widget build(BuildContext context) {
    var _homeBloc = HomeBloc();
    // BorderRadiusGeometry radius = BorderRadius.only(
    //   topLeft: Radius.circular(24.0),
    //   topRight: Radius.circular(24.0),
    // );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
         onPressed: () =>
                Navigator.pushNamed(context, AddBrokerPage.routeName),
          ),
      
      appBar: AppBar(
        actions: <Widget>[
              IconButton(
                icon: Icon(
                  ConfigBloc().darkModeOn
                      ? FontAwesomeIcons.lightbulb
                      : FontAwesomeIcons.solidLightbulb,
                  size: 18,
                ),
                onPressed: () {
                  ConfigBloc()
                      .dispatch(DarkModeEvent(!ConfigBloc().darkModeOn));
                },
              ),
              IconButton(
                onPressed: () => Share.share(
                    "Download the new DevFest App and share with your tech friends.\nPlayStore -  http://bit.ly/2GDr18N"),
                icon: Icon(
                  Icons.share,
                  size: 20,
                ),
              ),
            ],
            title: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset("cloud.png",height: 30,width: 30),
                 Text("MQTT"),
              ],
            ),
            centerTitle: true,
            
            //bottom: tabBar != null ? tabBar : null,
           /* actions: <Widget>[
              
              IconButton(
                icon: Icon(
                  ConfigBloc().darkModeOn
                      ? FontAwesomeIcons.lightbulb
                      : FontAwesomeIcons.solidLightbulb,
                  size: 18,
                ),
                onPressed: () {
                  ConfigBloc()
                      .dispatch(DarkModeEvent(!ConfigBloc().darkModeOn));
                },
              ),
              IconButton(
                onPressed: () => Share.share(
                    "Download the new DevFest App and share with your tech friends.\nPlayStore -  http://bit.ly/2GDr18N"),
                icon: Icon(
                  Icons.share,
                  size: 20,
                ),
              ),
            ],*/
          ),
        
        
     
      
      body: HomeScreen(homeBloc: _homeBloc),
     
    );
  }
}


