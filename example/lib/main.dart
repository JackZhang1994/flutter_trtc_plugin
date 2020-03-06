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
  int _sdkAppId = 1400324442;
  String _secretKey = 'dcfa262b7ccac8e29e163c8d824138ebb6530331ff625d9e21305259a35714ac';

  String _currentUserId;
  String _userSig;
  int _roomId = 58994078;

  bool _frontCamera = true;
  bool _muteLocalVideo = false;
  bool _muteLocalAudio = false;
  bool _audioSpeaker = true;
  int _localMirror = TrtcVideoMirrorType.TRTC_VIDEO_MIRROR_TYPE_AUTO;
  bool _mirror = false;

  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '1513');
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
                bottom: 240,
                left: 0,
                right: 0,
                child: _renderWidget(),
              ),
              Positioned(
                bottom: 200,
                left: 0,
                right: 0,
                child: Container(
                  height: 40,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            fillColor: Colors.lightGreenAccent,
                            filled: true,
                          ),
                        ),
                      ),
                      FlatButton(
                        onPressed: () async {
                          _currentUserId = _controller.text?.toString();
                          _userSig = await TrtcBase.getUserSig(_sdkAppId, _secretKey, _currentUserId);
                          showTips('获取UserSig成功');
                        },
                        child: Text('获取UserSig'),
                      ),
                    ],
                  ),
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
                    crossAxisCount: 3,
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
                          TrtcRoom.enterRoom(_sdkAppId, _currentUserId, _userSig, _roomId, 0);
                        },
                        child: Text('进入房间'),
                      ),
                      FlatButton(
                        onPressed: () {
                          TrtcVideo.setVideoEncoderParam();
                        },
                        child: Text('设置视频编码器相关参数'),
                      ),
                      FlatButton(
                        onPressed: () {
                          String msg;
                          switch (_localMirror) {
                            case TrtcVideoMirrorType.TRTC_VIDEO_MIRROR_TYPE_AUTO:
                              _localMirror = TrtcVideoMirrorType.TRTC_VIDEO_MIRROR_TYPE_ENABLE;
                              msg = '前置摄像头和后置摄像头都镜像';
                              break;

                            case TrtcVideoMirrorType.TRTC_VIDEO_MIRROR_TYPE_ENABLE:
                              _localMirror = TrtcVideoMirrorType.TRTC_VIDEO_MIRROR_TYPE_DISABLE;
                              msg = '前置摄像头和后置摄像头都不镜像';
                              break;

                            default:
                              _localMirror = TrtcVideoMirrorType.TRTC_VIDEO_MIRROR_TYPE_AUTO;
                              msg = '前置摄像头镜像，后置摄像头不镜像';
                              break;
                          }
                          TrtcVideo.setLocalViewMirror(_localMirror);
                          showTips(msg);
                        },
                        child: Text('本地摄像头镜像'),
                      ),
                      FlatButton(
                        onPressed: () {
                          String msg;
                          _mirror = !_mirror;
                          if (_mirror) {
                            msg = '开启推流镜像';
                          } else {
                            msg = '关闭推流镜像';
                          }
                          TrtcVideo.setVideoEncoderMirror(_mirror);
                          showTips(msg);
                        },
                        child: Text('输出画面镜像'),
                      ),
                      FlatButton(
                        onPressed: () {
                          TrtcVideo.muteLocalVideo(_muteLocalVideo);
                          _muteLocalVideo = !_muteLocalVideo;
                          String msg = _muteLocalVideo ? '停止推送本地的视频' : '恢复推送本地的视频';
                          showTips(msg);
                        },
                        child: Text('摄像头控制'),
                      ),
                      FlatButton(
                        onPressed: () {
                          TrtcAudio.muteLocalAudio(_muteLocalAudio);
                          _muteLocalAudio = !_muteLocalAudio;
                          String msg = _muteLocalAudio ? '停止推送本地的音频' : '恢复推送本地的音频';
                          showTips(msg);
                        },
                        child: Text('麦克风控制'),
                      ),
                      FlatButton(
                        onPressed: () {
                          TrtcVideo.switchCamera();
                          _frontCamera = !_frontCamera;
                          String msg = _frontCamera ? '前置摄像头' : '后置摄像头';
                          showTips('切换为$msg');
                        },
                        child: Text('切换摄像头'),
                      ),
                      FlatButton(
                        onPressed: () {
                          _audioSpeaker = !_audioSpeaker;
                          TrtcAudio.setAudioRoute(_audioSpeaker
                              ? TrtcAudioRouter.TRTC_AUDIO_ROUTE_SPEAKER
                              : TrtcAudioRouter.TRTC_AUDIO_ROUTE_EARPIECE);
                          String msg = _audioSpeaker ? '扬声器' : '听筒';
                          showTips('切换为$msg');
                        },
                        child: Text('声音播放控制'),
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

  Widget _renderWidget() {
    if (_widgetMap == null || _widgetMap.isEmpty) {
      return SizedBox();
    } else {
      return GridView.count(
        crossAxisSpacing: 2.0,
        mainAxisSpacing: 2.0,
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        children: _videoWidgetList(),
      );
    }
  }

  /// 渲染层集合
  List<Widget> _videoWidgetList() {
    var list = List<Widget>();
    if (_widgetMap.isNotEmpty) {
      list.addAll(_widgetMap.values);
    }
    return list;
  }

  void _onError(int errCode, String errMsg) {
    String msg = 'onError: errCode = $errCode, errMsg = $errMsg';
    showTips(msg);
  }

  void _onWarning(int warningCode, String warningMsg) {
    if (warningCode == TrtcWarningCode.WARNING_VIDEO_PLAY_LAG) {
      TrtcVideo.setNetworkQosParam(preference: TrtcVideoQosPreference.TRTC_VIDEO_QOS_PREFERENCE_SMOOTH);
    }
    String msg = 'onWarning: warningCode = $warningCode, warningMsg = $warningMsg';
    showTips(msg);
  }

  void _onEnterRoom(int result) {
    String msg;
    if (result > 0) {
      msg = '进入房间耗时$result毫秒';
      TrtcAudio.startLocalAudio();
      Widget widget = TrtcVideo.createPlatformView(_currentUserId, (viewId) {
        _viewIdMap[_currentUserId] = viewId;
        TrtcVideo.setLocalViewFillMode(TrtcVideoRenderMode.TRTC_VIDEO_RENDER_MODE_FILL);
        TrtcVideo.startLocalPreview(true, _viewIdMap[_currentUserId]);
      });
      _widgetMap[_currentUserId] = widget;
      setState(() {});
    } else {
      msg = '进入房间失败，错误码$result';
    }
    debugPrint(msg);
    showTips(msg);
  }

  void _onExitRoom(int reason) {
    String msg;
    if (reason == 0) {
      msg = '用户主动离开房间';
      _widgetMap.clear();
      _viewIdMap.clear();
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
        Widget widget = TrtcVideo.createPlatformView(userId, (viewId) {
          _viewIdMap[userId] = viewId;
          TrtcVideo.setRemoteViewFillMode(userId, TrtcVideoRenderMode.TRTC_VIDEO_RENDER_MODE_FILL);
          TrtcVideo.startRemoteView(userId, viewId);
        });
        _widgetMap[userId] = widget;
        setState(() {});
      }
    } else {
      if (_viewIdMap.containsKey(userId) && _widgetMap.containsKey(userId)) {
        TrtcVideo.stopRemoteView(userId);
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

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
