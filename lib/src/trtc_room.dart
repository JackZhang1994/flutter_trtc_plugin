import 'package:flutter/services.dart';
import 'package:flutter_trtc_plugin/flutter_trtc_plugin.dart';

class TrtcRoom {
  static const MethodChannel _channel = const MethodChannel('flutter_trtc_plugin');

  /// 进入房间
  ///
  /// [sdkAppId] 应用标识
  /// [userId] 用户标识
  /// [userSig] 用户签名
  /// [roomId] 房间号码
  /// [scene] 应用场景, 详见 [TrtcAppScene] 定义
  /// @discussion 调用接口后，您会收到来自 [TrtcBase.registerCallback] 中的 onEnterRoom(result) 回调
  /// @discussion 当 scene 选择为 TRTC_APP_SCENE_LIVE 或 TRTC_APP_SCENE_VOICE_CHATROOM 时，您必须通过 TRTCParams 中的 role 字段指定当前用户的角色。
  /// @discussion 不管进房是否成功，enterRoom 都必须与 exitRoom 配对使用，在调用 exitRoom 前再次调用 enterRoom 函数会导致不可预期的错误问题。
  static Future<void> enterRoom(int sdkAppId, String userId, String userSig, int roomId, int scene) async {
    return await _channel.invokeMethod(
        'enterRoom', {'sdkAppId': sdkAppId, 'userId': userId, 'userSig': userSig, 'roomId': roomId, 'scene': scene});
  }

  /// 离开房间
  ///
  /// @discussion 调用 exitRoom() 接口会执行退出房间的相关逻辑，例如释放音视频设备资源和编解码器资源等。
  /// @discussion 待资源释放完毕，SDK 会通过 [TrtcBase.registerCallback] 中的 onExitRoom() 回调通知到您。
  /// @discussion 如果您要再次调用 [enterRoom] 或者切换到其他的音视频 SDK，请等待 onExitRoom() 回调到来之后再执行相关操作。
  /// @discussion 否则可能会遇到摄像头或麦克风被占用等各种异常问题，例如常见的 Android 媒体音量和通话音量切换问题等等。
  static Future<void> exitRoom() async {
    return await _channel.invokeMethod('exitRoom');
  }

  /// 设置音视频数据接收模式（需要在进房前设置才能生效）
  ///
  /// [isReceivedAudio] true：自动接收音频数据；false：需要调用 muteRemoteAudio 进行请求或取消。默认值：true
  /// [isReceivedVideo] true：自动接收视频数据；false：需要调用 startRemoteView/stopRemoteView 进行请求或取消。默认值：true
  /// @discussion 为实现进房秒开的绝佳体验，SDK 默认进房后自动接收音视频。即在您进房成功的同时，您将立刻收到远端所有用户的音视频数据。
  /// @discussion 若您没有调用 startRemoteView，视频数据将自动超时取消。
  /// @discussion 若您主要用于语音聊天等没有自动接收视频数据需求的场景，您可以根据实际需求选择接收模式。
  static Future<void> setDefaultStreamRecvMode(bool isReceivedAudio, bool isReceivedVideo) async {
    return await _channel.invokeMethod(
        'setDefaultStreamRecvMode', {'isReceivedAudio': isReceivedAudio, 'isReceivedVideo': isReceivedVideo});
  }
}
