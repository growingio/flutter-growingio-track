import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_growingio_track/flutter_growingio_track.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class MyButton extends StatelessWidget {

  final VoidCallback onPressed;
  final String text;

  const MyButton({
    Key key,
    @required this.text,
    @required this.onPressed
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return new FlatButton(onPressed: this.onPressed, child: new Text(this.text, style: TextStyle(fontSize: 20.0),));
  }

}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    platformVersion = 'Failed to get platform version.';

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  void _clickTrack(){
    GrowingIO.track('eventId');
    GrowingIO.track('testEventId', num: 23.0, variable: {'testKey': 'testValue', 'testNumKey': 233});
    GrowingIO.track('eventId', num: 23.0);
    GrowingIO.track('eventId', variable: {'testkey': 'testValue', 'testNumKey': 2333});
  }

  void _clickEvar(){
    GrowingIO.setEvar({
      'testKey': 'testValue', 'testNumKey': 2333.0
    });
  }

  void _clickSetPeopleVariable(){
    GrowingIO.setPeopleVariable({
      'testKey': 'testValue', 'testNumKey': 2333.0
    });
  }

  void _clickSetUserId(){
    GrowingIO.setUserId("testUserId");
  }

  void _clickClearUserId(){
    GrowingIO.clearUserId();
  }

  void _clickSetVisitor(){
    GrowingIO.setVisitor({
      "visitorKey": 'key', "visitorValue": 34
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new MyButton(text: "track", onPressed: _clickTrack),
              new MyButton(text: "setEvar", onPressed: _clickEvar),
              new MyButton(text: "setPeopleVariable", onPressed: _clickSetPeopleVariable),
              new MyButton(text: "setUserId", onPressed: _clickSetUserId),
              new MyButton(text: "clearUserId", onPressed: _clickClearUserId),
              new MyButton(text: "setVisitor", onPressed: _clickSetVisitor)
            ],
          ),
        ),
      ),
    );
  }
}
