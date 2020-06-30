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
  /// [role] 直播场景下的角色，SDK 用这个参数确定用户是主播还是观众[直播场景下必填，通话场景下不填写], 默认值：主播（TRTCRoleAnchor）。详见 [TrtcRole] 定义
  /// [streamId] 绑定腾讯云直播 CDN 流 ID[非必填]，设置之后，您就可以在腾讯云直播 CDN 上通过标准直播方案（FLV或HLS）播放该用户的音视频流。
  /// @discussion 调用接口后，您会收到来自 [TrtcBase.registerCallback] 中的 onEnterRoom(result) 回调
  /// @discussion 当 scene 选择为 TRTC_APP_SCENE_LIVE 或 TRTC_APP_SCENE_VOICE_CHATROOM 时，您必须通过 TRTCParams 中的 role 字段指定当前用户的角色。
  /// @discussion 不管进房是否成功，enterRoom 都必须与 exitRoom 配对使用，在调用 exitRoom 前再次调用 enterRoom 函数会导致不可预期的错误问题。
  static Future<void> enterRoom(int sdkAppId, String userId, String userSig, int roomId, int scene, {int role, String streamId}) async {
    return await _channel.invokeMethod('enterRoom', {'sdkAppId': sdkAppId, 'userId': userId, 'userSig': userSig, 'roomId': roomId, 'scene': scene, 'role': role, 'streamId': streamId});
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
    return await _channel.invokeMethod('setDefaultStreamRecvMode', {'isReceivedAudio': isReceivedAudio, 'isReceivedVideo': isReceivedVideo});
  }

  /// 切换角色，仅适用于直播场景[TrtcAppScene.TRTC_APP_SCENE_LIVE] 和 [TrtcAppScene.TRTC_APP_SCENE_VOICE_CHATROOM]
  ///
  /// 在直播场景下，一个用户可能需要在“观众”和“主播”之间来回切换。 您可以在进房前通过 TRTCParams 中的 role 字段确定角色，也可以通过 switchRole 在进房后切换角色。
  /// [role] 目标角色，默认为主播，详见[TrtcRole]
  static Future<void> switchRole(int role) async {
    return await _channel.invokeMethod('switchRole');
  }

  /// 开始进行网络测速（视频通话期间请勿测试，以免影响通话质量）
  ///
  /// [sdkAppId]	应用标识
  /// [userId]	用户标识
  /// [userSig]	用户签名
  /// 测速结果将会用于优化 SDK 接下来的服务器选择策略，因此推荐您在用户首次通话前先进行一次测速，这将有助于我们选择最佳的服务器。
  /// 同时，如果测试结果非常不理想，您可以通过醒目的 UI 提示用户选择更好的网络。
  /// 测试结果通过 TRTCCloudListener.onSpeedTest 回调出来。
  static Future<void> startSpeedTest(int sdkAppId, String userId, String userSig) async {
    return await _channel.invokeMethod('startSpeedTest', {'sdkAppId': sdkAppId, 'userId': userId, 'userSig': userSig});
  }

  /// 停止服务器测速
  static Future<void> stopSpeedTest() async{
    return await _channel.invokeMethod('stopSpeedTest');
  }
}
