import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_trtc_plugin/flutter_trtc_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

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
          body: (defaultTargetPlatform == TargetPlatform.iOS)
              ? Container(
                  margin: EdgeInsets.only(left: 10, top: 10),
                  height: 126,
                  width: 126,
                  child: UiKitView(
                    viewType: "platform_video_view",
                    creationParams: <String, dynamic>{"text": '视频会议'},
                    creationParamsCodec: const StandardMessageCodec(),
                  ))
              : Column(
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
                            'eJwtjNEKgjAUQP-lPofczU2m0EutMhEKkgjfpC25VGJzZBD9e6I*nnPgfKHIT8HbOkiABwiLkcnYxtONRh2jZELOpTP3qm3JQMIEYsiFEHwq9tOSs5BEKBTi5Dw9B8OkCoeDjNX8oHrY7ncGyzLb9KRfrsHsotfRcZuyWqdN4a*2Oyvt88PqkfVL*P0Ba9EwCA__';
                        TrtcRoom.enterRoom(1400324442, '123', sig, 58994078, 0);
                      },
                      child: Text('进入房间'),
                    ),
                  ],
                )),
    );
  }
}
