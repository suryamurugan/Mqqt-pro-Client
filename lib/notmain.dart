import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:mqtt_pro_client/dev_scafold2.dart';
import 'package:mqtt_pro_client/models/brokerObj.dart';
import 'package:mqtt_pro_client/universal/dev_scaffold.dart';
import 'models/message.dart';
import 'dialogs/send_message.dart';
import 'dart:math';
import 'utils/tools.dart';
import 'models/submodel.dart';

class NotMain extends StatefulWidget {



 
  
final BrokerObj brokerObj;
  NotMain({Key key, @required this.brokerObj}) : super(key: key);

  
  
  static const String routeName = "/notmain";
  @override
  _MyAppState createState() => _MyAppState(brokerObj:brokerObj);
}

class _MyAppState extends State<NotMain> {


  String logger='';
  String pubmessage; 
  
  
  BrokerObj  brokerObj;

  _MyAppState({this.brokerObj});

  
  
  PageController _pageController;
  int _page = 0;

  String broker = '165.22.209.7';
  mqtt.MqttClient client;
  mqtt.MqttConnectionState connectionState;
  final topicController = TextEditingController();
  final messageController = TextEditingController();

  StreamSubscription subscription;

  Set<String> topics = Set<String>();
  List<SubObj> subobj = <SubObj>[];


  List<Message> messages = <Message>[];

  @override
  Widget build(BuildContext context) {
    IconData connectionStateIcon;
    switch (client?.connectionState) {
      case mqtt.MqttConnectionState.connected:
        connectionStateIcon = Icons.cloud_done;
        break;
      case mqtt.MqttConnectionState.disconnected:
        connectionStateIcon = Icons.cloud_off;
        break;
      case mqtt.MqttConnectionState.connecting:
        connectionStateIcon = Icons.cloud_upload;
        break;
      case mqtt.MqttConnectionState.disconnecting:
        connectionStateIcon = Icons.cloud_download;
        break;
      case mqtt.MqttConnectionState.faulted:
        connectionStateIcon = Icons.error;
        break;
      default:
        connectionStateIcon = Icons.cloud_off;
    }
  

    return DefaultTabController(
      length: 2,
      child: DevScaffold2(
        title: brokerObj.hostname,
          tabBar: TabBar(
            
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Tools.multiColors[Random().nextInt(4)],
            labelStyle: TextStyle(
              fontSize: 12,
            ),
            isScrollable: false,
          tabs: <Widget>[
            Tab(
              child: Text("Subscribe"),
              icon: Icon(
                //FontAwesomeIcons.cloudDownloadAlt,
                Icons.ac_unit,
                size: 12,
              ),
            ),
            Tab(
              child: Text("Publish"),
              icon: Icon(
               //FontAwesomeIcons.planeDeparture,
               Icons.access_alarm,
                size: 12,
              ),
            ),
           /* Tab(
              child: Text("Web & More"),
              icon: Icon(
                FontAwesomeIcons.chrome,
                size: 12,
              ),
            )
          */
          ],
        ),
         body: TabBarView(
          children: <Widget>[
             _buildBrokerPage(connectionStateIcon),
            _buildSubscriptionsPage(),
          //  _buildMessagesPage(),
           /* CloudScreen(
              homeBloc: _homeBloc,
            ),
            MobileScreenPage(
              homeBloc: _homeBloc,
            ),
            WebScreen(
              homeBloc: _homeBloc,
            ),
            */
          ],
        ),
       
       /*
        body: PageView(
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: <Widget>[
            _buildBrokerPage(connectionStateIcon),
            _buildSubscriptionsPage(),
            _buildMessagesPage(),
          ],
        ),*/
      ),
    );
    
  }

  Column _buildBrokerPage(IconData connectionStateIcon) {
   return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Card(
          elevation: 0,
          
          child:new Container(
            padding: EdgeInsets.all(20),
            
            child: 
              
              Row(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 200.0,
              child: TextField(
                controller: topicController,
                onSubmitted: (String topic) {
                  _subscribeToTopic(topic);
                },
                decoration: InputDecoration(hintText: 'Please enter a topic'),
              ),
            ),
            SizedBox(width: 8.0),
            RaisedButton(
              shape: StadiumBorder(),
              color: Colors.red,
              child: Text('add topic',style: TextStyle(color: Colors.white),),
              onPressed: () {
                _subscribeToTopic(topicController.value.text);
              },
            ),
          ],
        ) ,
            
          )
        ),
        
        SizedBox(height: 16.0),
        new Expanded(child: ListView.builder(
          
          itemCount: subobj.length, 
          itemBuilder: (context,item){
            return Card(
                child:new Row(
                  children: <Widget>[
                  
                    Text(subobj[item].topic),
                    Text(subobj[item].message),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: (){
                        _unsubscribeFromTopicSURYA(subobj[item]);
                      },
                    ),
                  ],
                ) ,);

          }
          ))
       /* 
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          alignment: WrapAlignment.start,
          children: _buildTopicsMap(),
        )
   */

        /*
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              broker,
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(width: 8.0),
            Icon(connectionStateIcon),
          ],
        ),
        SizedBox(height: 8.0),
        RaisedButton(
          child: Text(
              client?.connectionState == mqtt.MqttConnectionState.connected
                  ? 'Disconnect'
                  : 'Connect'),
          onPressed: () {
            if (client?.connectionState == mqtt.MqttConnectionState.connected) {
              _disconnect();
            } else {
              _connect();
            }
          },
        ),*/
      ],
    );
  }

  Column _buildMessagesPage() {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
          
            children: _buildMessageList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
            child: Text('Clear'),
            onPressed: () {
              setState(() {
                messages.clear();
              });
            },
          ),
        )
      ],
    );
  }

Column _buildSubscriptionsPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
         
          new Card(
          
          borderOnForeground: true,
          elevation: 0.0,
          child:new Padding(
        padding: EdgeInsets.all(16.0),
        child:new Column(
            children: <Widget>[
              SizedBox(
              
              child: TextField(
                controller: topicController,
                
                decoration: InputDecoration(hintText: 'Topic'),
              ),
            ),
            SizedBox(
              
              child: TextField(
                controller: messageController,
                
                decoration: InputDecoration(hintText: 'Message'),
              ),
            ),
            SizedBox(
              height: 10,
            ),
             
              RaisedButton(
            child: Text("publish"),
            shape: StadiumBorder(),
            color: Colors.red,
            colorBrightness: Brightness.dark,
            //onPressed: () => Navigator.pushNamed(context, AgendaPage.routeName),
            onPressed: () {
              print("dude this is before publishing");
             // _subscribeToTopicForPublishing(topicController.text);
             _publishMessage(topicController.text, messageController.text);
              setState(() {
                print(logger??'No data');
                //logger =logger+'\n';

              });
              print("clicked");
               // _connect_to(context);
              //_connect_to(context);
            },
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: new Column(

              children: <Widget>[

                new Text("Topic: "+topicController.text),
                new Text(pubmessage ?? ' ')
               
                

              ],
            ),

          )
            
          
          
             
            ],
          ))
        ),
        
            
            
      ],
    );
  }

/*
  Column _buildSubscriptionsPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 200.0,
              child: TextField(
                controller: topicController,
                onSubmitted: (String topic) {
                  _subscribeToTopic(topic);
                },
                decoration: InputDecoration(hintText: 'Please enter a topic'),
              ),
            ),
            SizedBox(width: 8.0),
            RaisedButton(
              child: Text('add topic'),
              onPressed: () {
                _subscribeToTopic(topicController.value.text);
              },
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          alignment: WrapAlignment.start,
          children: _buildTopicList(),
        )
      ],
    );
  }*/

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
    _connect();
    logger = 's';
  }


   List<Widget> _buildTopicsMap() {


    // Sort topics
    final List<String> sortedTopics = topics.toList()
      ..sort((String a, String b) {
        return compareNatural(a, b);
      });
      
    /*return sortedTopics 
        .map((String topic) => Chip(
              label: Text(topic),
              onDeleted: () {
                _unsubscribeFromTopic(topic);
              },
            ))
        .toList();*/
        return sortedTopics.map((String topic)=>ListTile(
          
          title: Text("Message"),
          leading: Text(topic,style: TextStyle(fontFamily: "GoogleSans",fontWeight: FontWeight.w600),),
          trailing: IconButton(icon: Icon(Icons.delete_sweep,),
                                onPressed: (){
                                 // setState(() {
                                    // /topics.remove(topic);
                                    _unsubscribeFromTopic(topic);
                                 // });
                                  print(topics);
                                  
                                  
                                },),
        )
      ).toList();
      
  }


  List<Widget> _buildMessageList() {
    return messages
        .map((Message message) => Card(
              color: Colors.white70,
              child: ListTile(
                trailing: CircleAvatar(
                    radius: 14.0,
                    backgroundColor: Theme.of(context).accentColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'QoS',
                          style: TextStyle(fontSize: 8.0),
                        ),
                        Text(
                          message.qos.index.toString(),
                          style: TextStyle(fontSize: 8.0),
                        ),
                      ],
                    )),
                title: Text(message.topic),
                subtitle: Text(message.message),
                dense: true,
              ),
            ))
        .toList()
        .reversed
        .toList();
  }



  List<Widget> _buildTopicList() {
    // Sort topics
    final List<String> sortedTopics = topics.toList()
      ..sort((String a, String b) {
        return compareNatural(a, b);
      });
    /*return sortedTopics
        .map((String topic) => Chip(
              label: Text(topic),
              onDeleted: () {
                _unsubscribeFromTopic(topic);
              },
            ))
        .toList();*/
        return sortedTopics.map((String topic)=>ListTile(
          
          title: Text("Message"),
          leading: Text(topic,style: TextStyle(fontFamily: "GoogleSans",fontWeight: FontWeight.w600),),
          trailing: IconButton(icon: Icon(Icons.delete_sweep,),
                                onPressed: (){
                                 // setState(() {
                                    // /topics.remove(topic);
                                    _unsubscribeFromTopic(topic);
                                 // });
                                  print(topics);
                                  
                                  
                                },),
        )
      ).toList();
  }

  void _connect() async {
    /// First create a client, the client is constructed with a broker name, client identifier
    /// and port if needed. The client identifier (short ClientId) is an identifier of each MQTT
    /// client connecting to a MQTT broker. As the word identifier already suggests, it should be unique per broker.
    /// The broker uses it for identifying the client and the current state of the client. If you don’t need a state
    /// to be hold by the broker, in MQTT 3.1.1 you can set an empty ClientId, which results in a connection without any state.
    /// A condition is that clean session connect flag is true, otherwise the connection will be rejected.
    /// The client identifier can be a maximum length of 23 characters. If a port is not specified the standard port
    /// of 1883 is used.
    /// If you want to use websockets rather than TCP see below.
    client = mqtt.MqttClient(brokerObj.hostname,brokerObj.portNo);

    /// A websocket URL must start with ws:// or wss:// or Dart will throw an exception, consult your websocket MQTT broker
    /// for details.
    /// To use websockets add the following lines -:
    // client.useWebSocket = true;

    /// This flag causes the mqtt client to use an alternate method to perform the WebSocket handshake. This is needed for certain
    /// matt clients (Particularly Amazon Web Services IOT) that will not tolerate additional message headers in their get request
    // client.useAlternateWebSocketImplementation = true;
    // client.port = 443; // ( or whatever your WS port is)
    /// Note do not set the secure flag if you are using wss, the secure flags is for TCP sockets only.

    /// Set logging on if needed, defaults to off
    client.logging(on: true);

    /// If you intend to use a keep alive value in your connect message that is not the default(60s)
    /// you must set it here
    client.keepAlivePeriod = 30;

    /// Add the unsolicited disconnection callback
    client.onDisconnected = _onDisconnected;

    /// Create a connection message to use or use the default one. The default one sets the
    /// client identifier, any supplied username/password, the default keepalive interval(60s)
    /// and clean session, an example of a specific one below.
    final mqtt.MqttConnectMessage connMess = mqtt.MqttConnectMessage()
        .withClientIdentifier('Mqtt_MyClientUniqueId2')
        // Must agree with the keep alive set above or not set
        .startClean() // Non persistent session for testing
        .keepAliveFor(30)
        // If you set this you must set a will message
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .withWillQos(mqtt.MqttQos.atLeastOnce);
    print('MQTT client connecting....');
    client.connectionMessage = connMess;

    /// Connect the client, any errors here are communicated by raising of the appropriate exception. Note
    /// in some circumstances the broker will just disconnect us, see the spec about this, we however will
    /// never send malformed messages.
    try {
      await client.connect();
    } catch (e) {
      print(e);
      _disconnect();
    }

    /// Check if we are connected
    if (client.connectionState == mqtt.MqttConnectionState.connected) {
      print('MQTT client connected');
      setState(() {
        connectionState = client.connectionState;
      });
    } else {
      print('ERROR: MQTT client connection failed - '
          'disconnecting, state is ${client.connectionState}');
      _disconnect();
    }

    /// The client has a change notifier object(see the Observable class) which we then listen to to get
    /// notifications of published updates to each subscribed topic.
    subscription = client.updates.listen(_onMessage);
  }

  void _disconnect() {
    client.disconnect();
    _onDisconnected();
  }

  void lo(){
    
  }

  void _onDisconnected() {
    setState(() {
      topics.clear();
      connectionState = client.connectionState;
      client = null;
      //subscription.cancel();
      subscription = null;
    });
    print('MQTT client disconnected');
  }

  void _publishMessage(String pubTopic,String pubMessage){
 //this is for publishing
  print("for publishing");
  /// Lets publish to our topic
  /// Use the payload builder rather than a raw buffer
  /// Our known topic to publish to
 final mqtt.MqttClientPayloadBuilder builder = mqtt.MqttClientPayloadBuilder();
  
  builder.addString(pubMessage);

  /// Subscribe to it
  print('EXAMPLE::Subscribing to the Dart/Mqtt_client/testtopic topic');
  client.subscribe(pubTopic, mqtt.MqttQos.exactlyOnce);

  /// Publish it
  print('EXAMPLE::Publishing our topic');
  client.publishMessage(pubTopic, mqtt.MqttQos.exactlyOnce, builder.payload);

  }

  void _onMessage(List<mqtt.MqttReceivedMessage> event) {
    
    print(event.length);
    final mqtt.MqttPublishMessage recMess =
        event[0].payload as mqtt.MqttPublishMessage;
    final String message =
        mqtt.MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    /// The above may seem a little convoluted for users only interested in the
    /// payload, some users however may be interested in the received publish message,
    /// lets not constrain ourselves yet until the package has been in the wild
    /// for a while.
    /// The payload is a byte buffer, this will be specific to the topic
    print('MQTT message: topic is <${event[0].topic}>, '
        'payload is <-- ${message} -->');
    print(client.connectionState);
    print("THis message is from on MeSAAGE");
    setState(() {
      print("Got a message bro ");
      print(subobj.length);
      print(event[0].topic);
       if(topicController.text == event[0].topic){
        print("Bro this is from the same topics");
        pubmessage=message;
      }

      int i=0;
      for(i=0;i<subobj.length;i++){
        if(subobj[i].topic == event[0].topic)
        {
          subobj[i].message = message;
          print("bro ${subobj[i].message}");
        }
      }
     

      

      
  
      
      messages.add(Message(
        topic: event[0].topic,
        message: message,
        qos: recMess.payload.header.qos,
      ));
      try {
        /*
        messageController.animateTo(
          0.0,
          duration: Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
        */
      } catch (_) {
        // ScrollController not attached to any scroll views.
      }
    });
  }


    void _subscribeToTopicForPublishing(String topic) {
    if (connectionState == mqtt.MqttConnectionState.connected) {
      setState(() {
        //subobj.add(SubObj(topic: topic,message: ''));
        print("inside sub function $subobj");

          
       // if (topics.add(topic.trim())) {
          print('Subscribing to ${topic.trim()}');
          client.subscribe(topic, mqtt.MqttQos.exactlyOnce);
       // }
      });
    }
  }

  void _subscribeToTopic(String topic) {
    if (connectionState == mqtt.MqttConnectionState.connected) {
      setState(() {
        subobj.add(SubObj(topic: topic,message: ''));
        print("inside sub function $subobj");

        
        if (topics.add(topic.trim())) {
          print('Subscribing to ${topic.trim()}');
          client.subscribe(topic, mqtt.MqttQos.exactlyOnce);
        }
      });
    }
  }

  void _unsubscribeFromTopic(String topic) {
    if (connectionState == mqtt.MqttConnectionState.connected) {
      setState(() {
        print("Before Deleting $subobj");
        print("Inside unsubscribe ");
      //  print(subobj.remove();
        print("After Deleting $subobj");

        if (topics.remove(topic.trim())) {
          print('Unsubscribing from ${topic.trim()}');
          client.unsubscribe(topic);
        }
      });
    }
  }
    void _unsubscribeFromTopicSURYA(SubObj subObj ){
    if (connectionState == mqtt.MqttConnectionState.connected) {
      setState(() {
        print("Before Deleting $subobj");
        print("Inside unsubscribe ");
        print(subobj.remove(subObj));
        print("After Deleting $subobj");
        client.unsubscribe(subObj.topic);
        print("Unsubscribing from $subObj");

       
      });
    }
  }


 
}