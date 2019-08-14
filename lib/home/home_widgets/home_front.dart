import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
//import 'package:mqtt_pro_client/pubsub/agenda_page.dart';
import 'package:mqtt_pro_client/config/index.dart';
import 'package:mqtt_pro_client/models/brokerList.dart';
import 'package:mqtt_pro_client/models/brokerObj.dart';
import 'package:mqtt_pro_client/universal/image_card.dart';
import 'package:mqtt_pro_client/utils/devfest.dart';
import 'package:mqtt_pro_client/utils/tools.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mqtt_pro_client/db_helper.dart';
import 'package:mqtt_pro_client/models/brokerObj.dart';
//import 'package:cached_network_image/cached_network_image.dart';

class HomeFront extends StatelessWidget {
 

bool a = true;
  

  //List<BrokerObj> listbro = [BrokerObj("vfsv","vsfv","vsfvfs","vcsv")];
  
final dbHelper = DatabaseHelper.instance;
  
  
    

  @override
  Widget build(BuildContext context) {
   // return a ? BrokerList(allBrokers: listbro,) :
   return a ? Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset("cloud.png",width:100,height: 100,),
          new Container(
            padding: EdgeInsets.all(30),
            child: Text("Dude ! add new broker",
                    style: TextStyle(fontFamily: "GoogleSans",fontWeight: FontWeight.w400),),
          )
        ],
      ),
    ) :FutureBuilder<List<BrokerObj>>(
      future: dbHelper.queryAllRows(),
      builder: (BuildContext context, AsyncSnapshot<List<BrokerObj>> snapshot){
        if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                BrokerObj item = snapshot.data[index];
                return ListTile(
                  title: Text(item.hostname),
                  leading: Text(item.id.toString()),
                  trailing: Checkbox(
                    onChanged: (bool value) {
                      //DBProvider.db.blockClient(item);
                      //setState(() {});
                    },
                    //value: item.blocked,
                    value: true,
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
      },
    );
  
}

 emptyscrren(){
  return  Column(
      children: <Widget>[
        Image.asset("cloud.png"),
        Text("Add new data",
         style: TextStyle(fontFamily: "GoogleSans",fontWeight: FontWeight.w400))
      ],
    
  );
}

}
