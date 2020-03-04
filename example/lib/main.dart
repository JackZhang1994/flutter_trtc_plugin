import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_trtc_plugin/flutter_trtc_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  HashMap<String, int> viewIdMap = HashMap<String, int>();
  String _currentUserId = '1513';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Column(
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  TrtcBase.sharedInstance();
                },
                child: Text('初始化SDK'),
              ),
              FlatButton(
                onPressed: () {
                  String sig =
                      'eJwtzE0LgkAUheH-MttC7p07Eya0KAgznBKKgtkZTnXpA9Mxgui-J*ryPAfer9inu*DtKhEJGYAYd5sL9-R85o5RIw1eF7e8LLkQESoAkkop2T-uU3LlRDQBFQL05vnRCuqQCORU09DgSxvdaLNcWLJII9zG1jS59pQdXklmTle8VyuzPvo4aep0PhO-P-6YLtQ_';
                  TrtcRoom.enterRoom(1400324442, _currentUserId, sig, 58994078, 0);
                },
                child: Text('进入房间'),
              ),
              Container(
                  height: 200,
                  width: 200,
                  child: TrtcVideo.createPlatformView((viewId) {
                    viewIdMap[_currentUserId] = viewId;
                  })),
              FlatButton(
                onPressed: () {
                  TrtcVideo.startLocalPreview(true, viewIdMap[_currentUserId]);
                },
                child: Text('开启本地预览'),
              ),
            ],
          )),
    );
  }
}
