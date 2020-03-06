import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_trtc_plugin/flutter_trtc_plugin.dart';

class TrtcBase {
  static const MethodChannel _channel = const MethodChannel('flutter_trtc_plugin');

  /// 创建 TRTCCloud 单例
  static Future<void> sharedInstance() async {
    return await _channel.invokeMethod('sharedInstance');
  }

  /// 销毁 TRTCCloud 单例
  static Future<void> destroySharedInstance() async {
    return await _channel.invokeMethod('destroySharedInstance');
  }

  /// 获取UserSig
  static Future<String> getUserSig(int sdkAppId, String secretKey, String userId) async {
    return await _channel.invokeMethod('getUserSig', {'sdkAppId': sdkAppId, 'secretKey': secretKey, 'userId': userId});
  }

  /// 注册回调对象
  static void registerCallback({
    Function(int errCode, String errMsg) onError,
    Function(int warningCode, String warningMsg) onWarning,
    Function(int result) onEnterRoom,
    Function(int reason) onExitRoom,
    Function(String userId) onRemoteUserEnterRoom,
    Function(String userId, int reason) onRemoteUserLeaveRoom,
    Function(String userId, bool available) onUserVideoAvailable,
    Function(String userId, bool available) onUserAudioAvailable,
    Function() onConnectionLost,
    Function() onTryToReconnect,
    Function() onConnectionRecovery,
  }) async {
    _onError = onError;
    _onWarning = onWarning;
    _onEnterRoom = onEnterRoom;
    _onExitRoom = onExitRoom;
    _onRemoteUserEnterRoom = onRemoteUserEnterRoom;
    _onRemoteUserLeaveRoom = onRemoteUserLeaveRoom;
    _onUserVideoAvailable = onUserVideoAvailable;
    _onUserAudioAvailable = onUserAudioAvailable;
    _onConnectionLost = onConnectionLost;
    _onTryToReconnect = onTryToReconnect;
    _onConnectionRecovery = onConnectionRecovery;

    print('registerCallback 执行');

    _streamSubscription = TrtcEvent.listenEvent().listen(_eventListener, onError: (error) {
      PlatformException exception = error;
      print('registerCallback error: ${exception.message}');
    });
  }

  /// 销毁回调对象
  ///
  /// @discussion 当开发者不再需要接收回调时，必须显式调用本 API 销毁回调对象
  static void unregisterCallback() {
    _onError = null;
    _onWarning = null;
    _onEnterRoom = null;
    _onExitRoom = null;
    _onRemoteUserEnterRoom = null;
    _onRemoteUserLeaveRoom = null;
    _onUserVideoAvailable = null;
    _onUserAudioAvailable = null;
    _onConnectionLost = null;
    _onTryToReconnect = null;
    _onConnectionRecovery = null;

    _streamSubscription.cancel().then((_) {
      _streamSubscription = null;
      print('unregisterCallback success');
    }).catchError((error) {
      PlatformException exception = error;
      print('unregisterCallback error: ${exception.message}');
    });
  }

  /// 错误回调
  ///
  /// [errCode] 错误码
  /// [errMsg] 错误信息
  /// @discussion SDK 不可恢复的错误，一定要监听，并分情况给用户适当的界面提示。
  static void Function(int errCode, String errMsg) _onError;

  /// 警告回调
  ///
  /// [warningCode] 错误码
  /// [warningMsg] 错误信息
  /// @discussion 用于告知您一些非严重性问题，例如出现卡顿或者可恢复的解码失败。
  static void Function(int warningCode, String warningMsg) _onWarning;

  /// 已加入房间的回调
  ///
  /// [result] result > 0 时为进房耗时（ms），result < 0 时为进房错误码。
  /// @discussion 调用 [TrtcRoom.enterRoom] 接口执行进房操作后，会收到来自 SDK 的 onEnterRoom(result) 回调：
  /// @discussion 如果加入成功，result 会是一个正数（result > 0），代表加入房间的时间消耗，单位是毫秒（ms）。
  /// @discussion 如果加入失败，result 会是一个负数（result < 0），代表进房失败的错误码。 进房失败的错误码含义请参见[TrtcErrorCode]
  static void Function(int result) _onEnterRoom;

  /// 有用户加入当前房间
  ///
  /// [userId] 用户标识
  /// @discussion 通话场景下，用户没有角色的区别，任何用户进入房间都会触发该通知。
  /// @discussion 注意 [_onRemoteUserEnterRoom] 和 [_onRemoteUserLeaveRoom] 只适用于维护当前房间里的“成员列表”，
  /// @discussion 如果需要显示远程画面，建议使用监听 [_onUserVideoAvailable] 事件回调。
  static void Function(String userId) _onRemoteUserEnterRoom;

  /// 有用户离开当前房间
  ///
  /// [userId] 用户标识
  /// [reason] 离开原因，0表示用户主动退出房间，1表示用户超时退出，2表示被踢出房间。
  /// @discussion 通话场景下，用户没有角色的区别，任何用户的离开都会触发该通知。
  static void Function(String userId, int reason) _onRemoteUserLeaveRoom;

  /// 离开房间的事件回调
  ///
  /// [reason] 离开房间原因，0：主动调用 exitRoom 退房；1：被服务器踢出当前房间；2：当前房间整个被解散。
  /// @discussion 调用 [TrtcRoom.exitRoom] 接口会执行退出房间的相关逻辑，例如释放音视频设备资源和编解码器资源等。
  /// @discussion 待资源释放完毕，SDK 会通过 onExitRoom() 回调通知到您。
  /// @discussion 如果您要再次调用 [TrtcRoom.enterRoom] 或者切换到其他的音视频 SDK，请等待 onExitRoom() 回调到来之后再执行相关操作。
  /// @discussion 否则可能会遇到音频设备被占用等各种异常问题。
  static void Function(int reason) _onExitRoom;

  /// 用户是否开启摄像头视频
  ///
  /// [userId] 用户标识
  /// [available] 画面是否开启
  /// @discussion 当您收到 [_onUserVideoAvailable] 通知时，表示该路画面已经有可用的视频数据帧到达。
  /// @discussion 此时，您需要调用 [TrtcVideo.startRemoteView] 接口加载该用户的远程画面。
  static void Function(String userId, bool available) _onUserVideoAvailable;

  /// 用户是否开启音频上行
  ///
  /// [userId] 用户标识
  /// [available] 声音是否开启
  static void Function(String userId, bool available) _onUserAudioAvailable;

  /// SDK 跟服务器的连接断开
  static void Function() _onConnectionLost;

  /// SDK 尝试重新连接到服务器
  static void Function() _onTryToReconnect;

  /// SDK 跟服务器的连接恢复
  static void Function() _onConnectionRecovery;

  /// 用于接收native层事件流，开发者无需关注
  static StreamSubscription<dynamic> _streamSubscription;

  /// 用于处理native层事件流，开发者无需关注
  static void _eventListener(dynamic data) {
    final Map<dynamic, dynamic> args = data;
    switch (args['name']) {
      case 'onError':
        if (_onError != null) {
          int errCode = args['errCode'];
          String errMsg = args['errMsg'];
          _onError(errCode, errMsg);
        }
        break;

      case 'onWarning':
        if (_onWarning != null) {
          int warningCode = args['warningCode'];
          String warningMsg = args['warningMsg'];
          _onWarning(warningCode, warningMsg);
        }
        break;

      case 'onEnterRoom':
        if (_onEnterRoom != null) {
          int result = args['result'];
          _onEnterRoom(result);
        }
        break;

      case 'onExitRoom':
        if (_onExitRoom != null) {
          int reason = args['reason'];
          _onExitRoom(reason);
        }
        break;

      case 'onRemoteUserEnterRoom':
        if (_onRemoteUserEnterRoom != null) {
          String userId = args['userId'];
          _onRemoteUserEnterRoom(userId);
        }
        break;

      case 'onRemoteUserLeaveRoom':
        if (_onRemoteUserLeaveRoom != null) {
          String userId = args['userId'];
          int reason = args['reason'];
          _onRemoteUserLeaveRoom(userId, reason);
        }
        break;

      case 'onUserVideoAvailable':
        if (_onUserVideoAvailable != null) {
          String userId = args['userId'];
          bool available = args['available'];
          _onUserVideoAvailable(userId, available);
        }
        break;

      case 'onUserVideoAvailable':
        if (_onUserAudioAvailable != null) {
          String userId = args['userId'];
          bool available = args['available'];
          _onUserAudioAvailable(userId, available);
        }
        break;

      case 'onConnectionLost':
        if (_onConnectionLost != null) {
          _onConnectionLost();
        }
        break;

      case 'onTryToReconnect':
        if (_onTryToReconnect != null) {
          _onTryToReconnect();
        }
        break;

      case 'onConnectionRecovery':
        if (_onConnectionRecovery != null) {
          _onConnectionRecovery();
        }
        break;

      default:
        break;
    }
  }
}
