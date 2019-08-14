import 'dart:async';

import 'package:flutter/services.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'models/message.dart';
import 'dialogs/send_message.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  final clientIdController = TextEditingController();
  final hostnameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final portController = TextEditingController();
  

  PageController _pageController;
  int _page = 0;

  String broker = '165.22.209.7';
  String clientId  = "mqtt_pro_client";
  String username ;
  String password;
  String  port ;
  mqtt.MqttClient client;
  mqtt.MqttConnectionState connectionState;

  StreamSubscription subscription;

  TextEditingController topicController = TextEditingController();
  Set<String> topics = Set<String>();

  List<Message> messages = <Message>[];
  ScrollController messageController = ScrollController();

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
    void navigationTapped(int page) {
      _pageController.animateToPage(page,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }

    void onPageChanged(int page) {
      setState(() {
        this._page = page;
      });
    }

    return MaterialApp(
      title: 'MQTT CLIENT',
      debugShowCheckedModeBanner: false,
       theme: ThemeData(
              //* Custom Google Font
              fontFamily: "GoogleSans",
              accentColor: Colors.blue,
              accentColorBrightness: Brightness.light,
              selectedRowColor: Colors.blue,
              primarySwatch: Colors.blue,
              primaryColor:  Colors.white,
              disabledColor: Colors.grey,
              cardColor:  Colors.grey,
              canvasColor:
                  Colors.white,
              brightness:
                   Brightness.light,
              buttonTheme: Theme.of(context).buttonTheme.copyWith(
                  colorScheme:  ColorScheme.light()),
              appBarTheme: AppBarTheme(
                elevation: 0.0,
              ),
            ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(broker),
              SizedBox(
                width: 8.0,
              ),
              Icon(connectionStateIcon),
            ],
          ),
        ),
        floatingActionButton: _page == 2
            ? Builder(builder: (BuildContext context) {
                return FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute<String>(
                          builder: (BuildContext context) =>
                              SendMessageDialog(client: client),
                          fullscreenDialog: true,
                        ));
                  },
                );
              })
            : null,
        bottomNavigationBar: BottomNavigationBar(
          onTap: navigationTapped,
          currentIndex: _page,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.cloud,color: Colors.black,),
              title: Text('MQTT Server',style: TextStyle(color: Colors.black),),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.playlist_add),
              title: Text('Subscriptions'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              title: Text('Messages'),
            ),
          ],
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: <Widget>[
            _buildBrokerPageMain(connectionStateIcon),
            //_buildBrokerPage(connectionStateIcon),
            _buildSubscriptionsPage(),
            _buildMessagesPage(),
          ],
        ),
      ),
    );
  }


  Column _buildBrokerPageMain(IconData connectionStateIcon) {
    return Column(
      
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Container(
          padding: EdgeInsets.all(10.0),
          child: Image.asset("cloud.png",height: 80.0,width: 80.0,),
        )
            , 
        /*Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              broker,
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(width: 8.0),
            Icon(connectionStateIcon),
          ],
        ),*/
        new SizedBox(height: 20.0,),
        new Container(
            padding: EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ClientID',
            contentPadding: EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 15.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
            style: TextStyle(color: Colors.green[300], fontWeight: FontWeight.w300,),
            cursorColor: Colors.green[300],
            autofocus: false,
            keyboardType: TextInputType.text,
            controller: clientIdController,
            ),
        ),
        SizedBox(height: 20.0),
           new Container(
          padding: EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
          child: TextField(
            controller: hostnameController,
             decoration: InputDecoration(
            hintText: 'HostName',
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
            style: TextStyle(color: Colors.green[300], fontWeight: FontWeight.w300,),
            cursorColor: Colors.green[300],
            autofocus: false,
            keyboardType: TextInputType.text,
            //controller: myController,
            ),
        ),
        SizedBox(height: 20.0),
         new Container(
          padding: EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
          child: TextField(
             decoration: InputDecoration(
            hintText: 'Username',
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
            style: TextStyle(color: Colors.green[300], fontWeight: FontWeight.w300,),
            cursorColor: Colors.green[300],
            autofocus: false,
            keyboardType: TextInputType.text,
            controller: usernameController,
            ),
        ),
         new SizedBox(height: 20.0),
        new Container(
          padding: EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
          child: TextField(
             decoration: InputDecoration(
            hintText: 'Password',
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
            style: TextStyle(color: Colors.green[300], fontWeight: FontWeight.w300,),
            cursorColor: Colors.green[300],
            autofocus: false,
            keyboardType: TextInputType.text,
            controller: passwordController,
            ),
        ),
        SizedBox(height: 20.0),
      
      
        new Container(
          padding: EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
          child: TextField(
             decoration: InputDecoration(
            hintText: 'PORT',
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
            style: TextStyle(color: Colors.green[300], fontWeight: FontWeight.w300,),
            cursorColor: Colors.green[300],
            autofocus: false,
            keyboardType: TextInputType.text,
            controller: portController,
            ),
        ),

      
          
            
        SizedBox(height: 8.0),
        RaisedButton(
          shape: StadiumBorder(),
            color: Colors.blue,
            colorBrightness: Brightness.dark,
          child: Text(
            
              client?.connectionState == mqtt.MqttConnectionState.connected
                  ? 'Disconnect'
                  : 'Connect'),
          onPressed: () {
            print(clientIdController.text);
            if (client?.connectionState == mqtt.MqttConnectionState.connected) {
              _disconnect();
            } else {
              _connect();
            }
          },
        ),
      ],
    );
  }

  Column _buildBrokerPage(IconData connectionStateIcon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
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
        ),
      ],
    );
  }

  Column _buildMessagesPage() {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            controller: messageController,
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
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }


Future<void> statusbar() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);


}

  @override
  void initState() {
    
    statusbar();
    _pageController = PageController();
    super.initState();
    
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
    return sortedTopics
        .map((String topic) => Chip(
              label: Text(topic),
              onDeleted: () {
                _unsubscribeFromTopic(topic);
              },
            ))
        .toList();
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
    client = mqtt.MqttClient(hostnameController.text,portController.text);

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
    setState(() {
      messages.add(Message(
        topic: event[0].topic,
        message: message,
        qos: recMess.payload.header.qos,
      ));
      try {
        messageController.animateTo(
          0.0,
          duration: Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      } catch (_) {
        // ScrollController not attached to any scroll views.
      }
    });
  }

  void _subscribeToTopic(String topic) {
    if (connectionState == mqtt.MqttConnectionState.connected) {
      setState(() {
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
        if (topics.remove(topic.trim())) {
          print('Unsubscribing from ${topic.trim()}');
          client.unsubscribe(topic);
        }
      });
    }
  }
}