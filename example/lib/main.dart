import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_trtc_plugin/flutter_trtc_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  HashMap<String, int> _viewIdMap = HashMap<String, int>();
  HashMap<String, Widget> _widgetMap = HashMap<String, Widget>();
  String _currentUserId = '1513';
  String _userSig =
      'eJwtzE0LgkAUheH-MttC7p07Eya0KAgznBKKgtkZTnXpA9Mxgui-J*ryPAfer9inu*DtKhEJGYAYd5sL9-R85o5RIw1eF7e8LLkQESoAkkop2T-uU3LlRDQBFQL05vnRCuqQCORU09DgSxvdaLNcWLJII9zG1jS59pQdXklmTle8VyuzPvo4aep0PhO-P-6YLtQ_';
  int _roomId = 58994078;

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
          body: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                bottom: 200,
                left: 0,
                right: 0,
                child: GridView.count(
                  crossAxisSpacing: 2.0,
                  mainAxisSpacing: 2.0,
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  children: _renderWidgetList(),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  child: GridView.count(
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    crossAxisCount: 4,
                    childAspectRatio: 2,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          TrtcBase.sharedInstance();
                        },
                        child: Text('初始化SDK'),
                      ),
                      FlatButton(
                        onPressed: () {
                          TrtcBase.registerCallback(
                            onError: _onError,
                            onWarning: _onWarning,
                            onEnterRoom: _onEnterRoom,
                            onExitRoom: _onExitRoom,
                            onRemoteUserEnterRoom: _onRemoteUserEnterRoom,
                            onRemoteUserLeaveRoom: _onRemoteUserLeaveRoom,
                            onUserVideoAvailable: _onUserVideoAvailable,
                            onUserAudioAvailable: _onUserAudioAvailable,
                            onConnectionLost: _onConnectionLost,
                            onTryToReconnect: _onTryToReconnect,
                            onConnectionRecovery: _onConnectionRecovery,
                          );
                        },
                        child: Text('设置监听'),
                      ),
                      FlatButton(
                        onPressed: () {
                          TrtcRoom.enterRoom(1400324442, _currentUserId, _userSig, _roomId, 0).then((success){

                          });
                        },
                        child: Text('进入房间'),
                      ),
                      FlatButton(
                        onPressed: () {
                          if (_viewIdMap[_currentUserId] == null && _widgetMap[_currentUserId] == null) {
                            Widget widget = TrtcVideo.createPlatformView((viewId) {
                              _viewIdMap[_currentUserId] = viewId;
                              TrtcVideo.startLocalPreview(true, _viewIdMap[_currentUserId]);
                            });
                            _widgetMap[_currentUserId] = widget;
                            setState(() {});
                          } else {
                            TrtcVideo.startLocalPreview(true, _viewIdMap[_currentUserId]);
                          }
                        },
                        child: Text('开启本地预览'),
                      ),
                      FlatButton(
                        onPressed: () {
                          TrtcVideo.stopLocalPreview();
                        },
                        child: Text('停止本地预览'),
                      ),
                      FlatButton(
                        onPressed: () {
                          TrtcRoom.exitRoom();
                        },
                        child: Text('退出房间'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  /// 渲染层集合
  List<Widget> _renderWidgetList() {
    var list = List<Widget>();
    if (_widgetMap.isEmpty) {
      list.add(SizedBox());
    } else {
      list.addAll(_widgetMap.values.toList().map((widget) => Container(width: 150, child: widget)));
    }
    return list;
  }

  void _onError(int errCode, String errMsg) {
    String msg = 'onError: errCode = $errCode, errMsg = $errMsg';
    showTips(msg);
  }

  void _onWarning(int warningCode, String warningMsg) {
    String msg = 'onWarning: warningCode = $warningCode, warningMsg = $warningMsg';
    showTips(msg);
  }

  void _onEnterRoom(int result) {
    String msg;
    if (result > 0) {
      msg = '进入房间耗时$result毫秒';
    } else {
      msg = '进入房间失败，错误码$result';
    }
    showTips(msg);
  }

  void _onExitRoom(int reason) {
    String msg;
    if (reason == 0) {
      msg = '用户主动离开房间';
    } else if (reason == 1) {
      msg = '用户被踢出房间';
    } else {
      msg = '房间已解散';
    }
    showTips(msg);
  }

  void _onRemoteUserEnterRoom(String userId) {
    String msg = '用户$userId进入房间';
    showTips(msg);
  }

  void _onRemoteUserLeaveRoom(String userId, int reason) {
    String reasonStr;
    if (reason == 0) {
      reasonStr = '用户主动离开房间';
    } else if (reason == 1) {
      reasonStr = '用户超时退出房间';
    } else {
      reasonStr = '用户被踢出房间';
    }
    showTips('用户$userId离开房间，离开原因为：$reasonStr');
  }

  void _onUserVideoAvailable(String userId, bool available) {
    String availableStr = available ? '开启' : '关闭';
    showTips('用户$userId的画面$availableStr');

    if (available) {
      if (!_viewIdMap.containsKey(userId) && !_widgetMap.containsKey(userId)) {
        Widget widget = TrtcVideo.createPlatformView((viewId) {
          _viewIdMap[userId] = viewId;
        });
        _widgetMap[userId] = widget;
        setState(() {});
      }
    } else {
      if (_viewIdMap.containsKey(userId) && _widgetMap.containsKey(userId)) {
        TrtcVideo.destroyPlatformView(_viewIdMap[userId]).then((flag) {
          if (flag) {
            _viewIdMap.remove(userId);
            _widgetMap.remove(userId);
            setState(() {});
          }
        });
      }
    }
  }

  void _onUserAudioAvailable(String userId, bool available) {
    String availableStr = available ? '开启' : '关闭';
    showTips('用户$userId的音频$availableStr');
  }

  void _onConnectionLost() {
    showTips('连接已断开...');
  }

  void _onTryToReconnect() {
    showTips('正在重连中...');
  }

  void _onConnectionRecovery() {
    showTips('连接已恢复...');
  }

  void showTips(String msg) {
    Fluttertoast.showToast(msg: msg);
    print(msg);
  }
}
