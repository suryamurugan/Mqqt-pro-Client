import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mqtt_client/mqtt_client.dart';
//import 'package:mqtt_pro_client/pubsub/agenda_page.dart';
import 'package:mqtt_pro_client/config/index.dart';
import 'package:mqtt_pro_client/models/brokerList.dart';
import 'package:mqtt_pro_client/models/brokerObj.dart';
import 'package:mqtt_pro_client/notmain.dart';
import 'package:mqtt_pro_client/universal/image_card.dart';
import 'package:mqtt_pro_client/utils/devfest.dart';
import 'package:mqtt_pro_client/utils/tools.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mqtt_pro_client/db_helper.dart';
import 'package:mqtt_pro_client/models/brokerObj.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeFront extends StatelessWidget {
 

bool a = false;
  

  //List<BrokerObj> listbro = [BrokerObj("vfsv","vsfv","vsfvfs","vcsv")];
  
final dbHelper = DatabaseHelper.instance;
  
  
    

  @override
  Widget build(BuildContext context) {
   // return a ? BrokerList(allBrokers: listbro,) :
   return a ? Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          
          //Image.asset("cloud.png",width:100,height: 100,),
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
                return Dismissible(
                  
                  key: UniqueKey(),
                  background: Container(color: Colors.grey),
                    onDismissed: (direction) {
                        dbHelper.delete(item.id);
                       // DBProvider.db.deleteClient(item.id);
                    },
                  child: Card(
      child: ListTile(
        leading: Icon(FontAwesomeIcons.server,color: Tools.multiColors[Random().nextInt(4)],),
        title: Text(item.hostname),
        subtitle: Text(item.clientId),
        trailing: Text(item.portNo),
        onTap: (){
           Navigator.push(
                context,
                MaterialPageRoute(
                 // builder: (context) => SessionDetail(
                  //  session: allSessions[i],
                  builder: (context)=>NotMain(brokerObj: item,),
                  ),
              
              );
        },
      ),
    )
                  /*Card(
          elevation: 0.6,
          child: ListTile(
            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                 // builder: (context) => SessionDetail(
                  //  session: allSessions[i],
                  builder: (context)=>NotMain(brokerObj: item,),
                  ),
              
              );
            },
            // dense: true,
            isThreeLine: true,
            trailing: Text(item.portNo, style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(fontSize: 14, fontWeight: FontWeight.bold),softWrap: true,textAlign: TextAlign.center,),
            leading: Hero(
              tag: item.id,
              child: Icon(FontAwesomeIcons.server),
            ),
            title: Text(item.hostname,
                style: TextStyle(fontSize: 20),),
            subtitle: Text(
              item.clientId,
              style: Theme.of(context).textTheme.caption.copyWith(
                    fontSize: 14.0,
                  ),
            ),
          ),
        ),*/
                  /*ListTile(
                    
                  
                    contentPadding: EdgeInsets.all(10.0),
                  
                  title: Text(item.hostname),
                  subtitle: Text(item.clientId),
                  leading: Text(item.portNo.toString()),
                  trailing: Text(item.portNo.toString())
                ),*/

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
