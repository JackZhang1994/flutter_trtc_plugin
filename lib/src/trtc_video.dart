import 'package:flutter/services.dart';
import 'package:flutter_trtc_plugin/flutter_trtc_plugin.dart';

class TrtcVideo {
  static const MethodChannel _channel = const MethodChannel('flutter_trtc_plugin');

  /// 创建PlatformView
  ///
  /// [userId] 用户标识
  /// [streamType] 视频类型, 详见 [TrtcVideoStreamType] 定义
  static Future<void> createPlatformView(String userId, int streamType) async {
    return await _channel.invokeMethod('createPlatformView', {'userId': userId, 'streamType': streamType});
  }

  /// 销毁PlatformView
  ///
  /// [userId] 用户标识
  /// [streamType] 视频类型, 详见 [TrtcVideoStreamType] 定义
  static Future<void> destroyPlatformView(String userId, int streamType) async {
    return await _channel.invokeMethod('destroyPlatformView', {'userId': userId, 'streamType': streamType});
  }

  /// 开启本地视频的预览画面
  ///
  /// [frontCamera] true：前置摄像头；false：后置摄像头
  static Future<void> startLocalPreview(bool frontCamera) async {
    return await _channel.invokeMethod('startLocalPreview', {'frontCamera': frontCamera});
  }

  /// 停止本地视频采集及预览
  static Future<void> stopLocalPreview() async {
    return await _channel.invokeMethod('stopLocalPreview');
  }

  /// 开始显示远端视频画面
  ///
  /// [userId] 对方的用户标识
  /// @discussion 在收到 SDK 的 [TrtcBase.registerCallback] 中的 onUserVideoAvailable(userId, true) 通知时，可以获知该远程用户开启了视频，
  /// @discussion 此后调用 [startRemoteView] 接口加载该用户的远程画面，可以用 loading 动画优化加载过程中的等待体验。
  static Future<void> startRemoteView(String userId) async {
    return await _channel.invokeMethod('startRemoteView', {'userId': userId});
  }

  /// 停止显示远端视频画面，同时不再拉取该远端用户的视频数据流
  ///
  /// [userId] 对方的用户标识
  /// @discussion 调用此接口后，SDK 会停止接收该用户的远程视频流，同时会清理相关的视频显示资源。
  static Future<void> stopRemoteView(String userId) async {
    return await _channel.invokeMethod('stopRemoteView', {'userId': userId});
  }

  /// 停止显示所有远端视频画面，同时不再拉取远端用户的视频数据流
  ///
  /// @discussion 如果有屏幕分享的画面在显示，则屏幕分享的画面也会一并被关闭。
  static Future<void> stopAllRemoteView() async {
    return await _channel.invokeMethod('stopAllRemoteView');
  }

  /// 是否停止推送本地的视频数据
  ///
  /// [mote] true：屏蔽；false：开启，默认值：false
  /// @discussion 当停止推送本地视频后，房间里的其它成员将会收到 [TrtcBase.registerCallback] 中的 onUserVideoAvailable 回调通知
  static Future<void> muteLocalVideo(bool mote) async {
    return await _channel.invokeMethod('muteLocalVideo', {'mote': mote});
  }

  /// 设置本地图像的渲染模式
  ///
  /// [mode] 填充或适应模式，默认值：填充（FILL）。详见[TrtcVideoRenderMode]
  static Future<void> setLocalViewFillMode(int mode) async {
    return await _channel.invokeMethod('setLocalViewFillMode', {'mode': mode});
  }

  /// 设置远端图像的渲染模式
  ///
  /// [userId] 对方的用户标识
  /// [mode] 填充或适应模式，默认值：填充（FILL）。详见[TrtcVideoRenderMode]
  static Future<void> setRemoteViewFillMode(String userId, int mode) async {
    return await _channel.invokeMethod('setRemoteViewFillMode', {'userId': userId, 'mode': mode});
  }

  /// 切换摄像头
  static Future<void> switchCamera() async {
    return await _channel.invokeMethod('switchCamera');
  }
}
