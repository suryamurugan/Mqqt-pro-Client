import 'dart:math';

//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home/home_bloc.dart';
import 'dev_scaffold.dart';
import 'home/home_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mqtt_pro_client/models/brokerObj.dart';
import 'broker_O.dart';
import 'db_helper.dart';

class AddBrokerPage extends StatefulWidget {
   
  static const String routeName = "/addbrokerpage";

  @override
  AddBrokerPageState createState() => new AddBrokerPageState();

  
}

class AddBrokerPageState extends State<AddBrokerPage>{
  final dbHelper = DatabaseHelper.instance;

 final hostnameController = TextEditingController();
 final portNoController = TextEditingController();




   @override
  Widget build(BuildContext context) {
   // var _homeBloc = HomeBloc();
    //var state = _homeBloc.currentState as InHomeState;
   
    return DevScaffold(
      body: Center (
      
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("newbroker.png"),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextField(
            decoration: InputDecoration(labelText: "Hostname/Server IP",
            labelStyle: TextStyle(fontWeight: FontWeight.w300, ),
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(32)))
            ),
            //style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
            //autofocus: true,
            keyboardType: TextInputType.text,
            controller: hostnameController,
            ),
            ),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextField(
              
            decoration: InputDecoration(labelText: "Port",
            labelStyle: TextStyle(fontWeight: FontWeight.w300, ),
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(32)))
            ),
            //style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
            //autofocus: true,
            keyboardType: TextInputType.text,
            controller: portNoController,
            ),
            ),
            SizedBox(height: 10,),
            RaisedButton(
            child: Text("Done"),
            shape: StadiumBorder(),
            color: Colors.red,
            colorBrightness: Brightness.dark,
            //onPressed: () => Navigator.pushNamed(context, AgendaPage.routeName),
            onPressed: () {
              print("clicked");
              //_read();
              _dbhinset(BrokerObj(clientId: "",
                                  hostname:hostnameController.text,
                                  portNo: portNoController.text,
                                  username: "",
                                  password: "",
                                  ));
             // Navigator.pop(context,{});
              //_connect_to(context);
            },
          ),
           RaisedButton(
            child: Text("save"),
            shape: StadiumBorder(),
            color: Colors.red,
            colorBrightness: Brightness.dark,
            //onPressed: () => Navigator.pushNamed(context, AgendaPage.routeName),
            onPressed: () {
              print("clicked");
              db_fetch();
              //_save(context);
              //Navigator.pop(context,{});
              //_connect_to(context);
            },
          ),
            
            


          ],
        ),
      ),
      title: "Add new broker",
    );
  }


  _dbhinset(BrokerObj brokerObj) async{

    var newbr = brokerObj;
    final id = dbHelper.insert(newbr);
    print("inserted bro $id");
  }

  db_fetch() async{
    
    final allRows = await dbHelper.queryAllRows();
    allRows.forEach((row)=>print(row));

  }


    _read() async {
        final prefs = await SharedPreferences.getInstance();
        final key = 'my_int_key';
        final value = prefs.getStringList(key) ?? '[]';
        setState(() {
          //brokerList=value;
        });
        //print(brokerList);
        
        
         // allTopics = value;
         // print(allTopics);
        
      }

      _save(BuildContext context) async {
        
        final prefs = await SharedPreferences.getInstance();
        final key = 'my_int_key';
        List <String> l= ['1','2'];
        print(l);
        prefs.setStringList(key,l);
        ///print('saved $allTopics');
        //Navigator.pop(context);
        
      }
}