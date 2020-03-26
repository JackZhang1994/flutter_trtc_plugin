import 'package:flutter/services.dart';
import 'package:flutter_trtc_plugin/flutter_trtc_plugin.dart';

class TrtcSubStream {
  static const MethodChannel _channel = const MethodChannel('flutter_trtc_plugin');

  /// 开始显示远端用户的屏幕分享画面
  ///
  /// [userId] 对方的用户标识
  /// [viewId] 视图ID
  /// @discussion 请在 [TrtcBase._onUserSubStreamAvailable] 回调后再调用这个接口。
  static Future<void> startRemoteSubStreamView(String userId, int viewId) async {
    return await _channel.invokeMethod('startRemoteSubStreamView', {'userId': userId, 'viewId': viewId});
  }

  /// 停止显示远端用户的屏幕分享画面
  ///
  /// [userId] 对方的用户标识
  static Future<void> stopRemoteSubStreamView(String userId) async {
    return await _channel.invokeMethod('stopRemoteSubStreamView', {'userId': userId});
  }

  /// 设置屏幕分享画面的显示模式
  ///
  /// [userId] 对方的用户标识
  /// [mode] 填充或适应模式，默认值：填充（FILL）。详见[TrtcVideoRenderMode]
  static Future<void> setRemoteSubStreamViewFillMode(String userId, int mode) async {
    return await _channel.invokeMethod('setRemoteSubStreamViewFillMode', {'userId': userId, 'mode': mode});
  }

  /// 设置屏幕分享画面的顺时针旋转角度
  ///
  /// [userId] 对方的用户标识
  /// [rotation] 顺时针旋转角度，默认值：不旋转。详见[TrtcVideoRotation]
  static Future<void> setRemoteSubStreamViewRotation(String userId, int rotation) async {
    return await _channel.invokeMethod('setRemoteSubStreamViewRotation', {'userId': userId, 'rotation': rotation});
  }
}
