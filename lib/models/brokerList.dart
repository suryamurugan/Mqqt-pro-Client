import 'dart:math';

//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_devfest/agenda/session_detail.dart';
//import 'package:flutter_devfest/home/session.dart';
import 'package:mqtt_pro_client/models/brokerObj.dart';
import 'package:mqtt_pro_client/utils/tools.dart';

class BrokerList extends StatelessWidget {
  final List<BrokerObj> allBrokers;

  const BrokerList({Key key, @required this.allBrokers}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: allBrokers.length,
      itemBuilder: (c, i) {
        // return Text("sdd");
        return Card(
          elevation: 0.0,
          child: ListTile(
            onTap: () {/*
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SessionDetail(
                    session: allBrokers[i],
                  ),
                ),
              );*/
            },
            // dense: true,
            isThreeLine: true,
            trailing: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                //text: "${allBrokers[i].sessionTotalTime}\n",
                text: "123\n",
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: "213",
                    //text: allBrokers[i].sessionStartTime,
                    style: Theme.of(context).textTheme.subtitle.copyWith(
                          fontSize: 12,
                        ),
                  ),
                ],
              ),
            ),
            leading: Hero(
              tag: allBrokers[i].clientId,
              child: CircleAvatar(
                radius: 30,
                //backgroundImage:
                //    CachedNetworkImageProvider(allBrokers[i].speakerImage),
              ),
            ),
            title: RichText(
              text: TextSpan(
                text: "165.22.209.7\n",
                //text: "${allbrokers[i].sessionTitle}\n",
                style: Theme.of(context).textTheme.title.copyWith(fontSize: 16),
                children: [
                  TextSpan(
                    text: "clientID",
                      //text: allbrokers[i].speakerName,
                      style: Theme.of(context).textTheme.subtitle.copyWith(
                            fontSize: 14,
                            color: Tools.multiColors[Random().nextInt(4)],
                          ),
                      children: []),
                ],
              ),
            ),
            subtitle: Text(
              "description",
              //allBrokers[i].speakerDesc,
              style: Theme.of(context).textTheme.caption.copyWith(
                    fontSize: 10.0,
                  ),
            ),
          ),
        );
      },
    );
  }
}
