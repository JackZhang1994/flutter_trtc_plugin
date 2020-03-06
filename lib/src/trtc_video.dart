import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_trtc_plugin/flutter_trtc_plugin.dart';

class TrtcVideo {
  static const MethodChannel _channel = const MethodChannel('flutter_trtc_plugin');

  /// 创建PlatformView
  static Widget createPlatformView(String userId, Function(int viewID) onViewCreated) {
    if (TargetPlatform.iOS == defaultTargetPlatform) {
      return UiKitView(
          key: ObjectKey(userId),
          viewType: 'flutter_trtc_plugin_view',
          onPlatformViewCreated: (int viewId) {
            if (onViewCreated != null) {
              onViewCreated(viewId);
            }
          });
    } else if (TargetPlatform.android == defaultTargetPlatform) {
      return AndroidView(
        key: ObjectKey(userId),
        viewType: 'flutter_trtc_plugin_view',
        onPlatformViewCreated: (int viewID) {
          if (onViewCreated != null) {
            onViewCreated(viewID);
          }
        },
      );
    }
    return null;
  }

  /// 销毁PlatformView
  ///
  /// [viewId] 视图ID
  static Future<bool> destroyPlatformView(int viewId) async {
    return await _channel.invokeMethod('destroyPlatformView', {'viewId': viewId});
  }

  /// 开启本地视频的预览画面
  ///
  /// [frontCamera] true：前置摄像头；false：后置摄像头
  /// [viewId] 视图ID
  static Future<void> startLocalPreview(bool frontCamera, int viewId) async {
    return await _channel.invokeMethod('startLocalPreview', {'frontCamera': frontCamera, 'viewId': viewId});
  }

  /// 停止本地视频采集及预览
  static Future<void> stopLocalPreview() async {
    return await _channel.invokeMethod('stopLocalPreview');
  }

  /// 开始显示远端视频画面
  ///
  /// [userId] 对方的用户标识
  /// [viewId] 视图ID
  /// @discussion 在收到 SDK 的 [TrtcBase.registerCallback] 中的 onUserVideoAvailable(userId, true) 通知时，可以获知该远程用户开启了视频，
  /// @discussion 此后调用 [startRemoteView] 接口加载该用户的远程画面，可以用 loading 动画优化加载过程中的等待体验。
  static Future<void> startRemoteView(String userId, int viewId) async {
    return await _channel.invokeMethod('startRemoteView', {'userId': userId, 'viewId': viewId});
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

  /// 设置视频编码器相关参数
  ///
  /// [videoResolution] 视频分辨率, 默认640 * 360
  /// [videoResolutionMode] 分辨率模式，默认Portrait
  /// [videoFps] 视频采集帧率，默认15fps
  /// [videoBitrate] 视频上行码率，默认600
  /// [enableAdjustRes] 是否允许调整分辨率，建议视频会议设为true
  static Future<void> setVideoEncoderParam({
    int videoResolution = TrtcVideoResolution.TRTC_VIDEO_RESOLUTION_640_360,
    int videoResolutionMode = TrtcVideoResolutionMode.TRTC_VIDEO_RESOLUTION_MODE_PORTRAIT,
    int videoFps = 15,
    int videoBitrate = 600,
    bool enableAdjustRes = true,
  }) async {
    return await _channel.invokeMethod('setVideoEncoderParam', {
      'videoResolution': videoResolution,
      'videoResolutionMode': videoResolutionMode,
      'videoFps': videoFps,
      'videoBitrate': videoBitrate,
      'enableAdjustRes': enableAdjustRes,
    });
  }

  /// 设置网络流控相关参数
  ///
  /// [preference] 弱网下选择“保清晰”或“保流畅”，默认值[TrtcVideoQosPreference.TRTC_VIDEO_QOS_PREFERENCE_CLEAR]
  /// [controlMode] 视频分辨率（云端控制 - 客户端控制），只能使用[TrtcVideoQosControl.VIDEO_QOS_CONTROL_SERVER]
  static Future<void> setNetworkQosParam({
    @required int preference,
    int controlMode = TrtcVideoQosControl.VIDEO_QOS_CONTROL_SERVER,
  }) async {
    return await _channel.invokeMethod('setNetworkQosParam', {
      'preference': preference,
      'controlMode': controlMode,
    });
  }

  /// 设置本地摄像头预览画面的镜像模式
  ///
  /// [mirrorType] 镜像模式，详见[TrtcVideoMirrorType]，默认值[TrtcVideoMirrorType.TRTC_VIDEO_MIRROR_TYPE_AUTO]
  static Future<void> setLocalViewMirror(int mirrorType) async {
    return await _channel.invokeMethod('setLocalViewMirror', {'mirrorType': mirrorType});
  }

  /// 设置编码器输出的画面镜像模式
  ///
  /// [mirror] 是否镜像，true：镜像；false：不镜像；默认值：false
  static Future<void> setVideoEncoderMirror(bool mirror) async {
    return await _channel.invokeMethod('setVideoEncoderMirror', {'mirror': mirror});
  }
}
