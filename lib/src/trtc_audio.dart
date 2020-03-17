import 'package:flutter/services.dart';
import 'package:flutter_trtc_plugin/flutter_trtc_plugin.dart';

class TrtcAudio {
  static const MethodChannel _channel = const MethodChannel('flutter_trtc_plugin');

  /// 开启本地音频的采集和上行
  ///
  /// @discussion 当开启本地音频的采集和上行，房间里的其它成员会收到 [TrtcBase.registerCallback] 中的 onUserAudioAvailable(true) 回调通知。
  /// @discussion 该函数会启动麦克风采集，并将音频数据传输给房间里的其他用户。 SDK 不会默认开启本地音频采集和上行，您需要调用该函数开启，否则房间里的其他用户将无法听到您的声音。
  /// @discussion 该函数会检查麦克风的使用权限，如果当前 App 没有麦克风权限，SDK 会向用户申请开启。
  static Future<void> startLocalAudio() async {
    return await _channel.invokeMethod('startLocalAudio');
  }

  /// 关闭本地音频的采集和上行
  ///
  /// @discussion 当关闭本地音频的采集和上行，房间里的其它成员会收到 [TrtcBase.registerCallback] 中的 onUserAudioAvailable(false) 回调通知。
  static Future<void> stopLocalAudio() async {
    return await _channel.invokeMethod('stopLocalAudio');
  }

  /// 静音本地的音频
  ///
  /// [mote] true：屏蔽；false：开启，默认值：false
  /// @discussion 当静音本地音频后，房间里的其它成员会收到 [TrtcBase.registerCallback] 中的 onUserAudioAvailable(false) 回调通知。
  /// @discussion 与 stopLocalAudio 不同之处在于，muteLocalAudio 并不会停止发送音视频数据，而是继续发送码率极低的静音包。
  /// @discussion 由于 MP4 等视频文件格式，对于音频的连续性是要求很高的，使用 stopLocalAudio 会导致录制出的 MP4 不易播放， 因此在对录制质量要求很高的场景中，建议选择 muteLocalAudio，从而录制出兼容性更好的 MP4 文件。
  static Future<void> muteLocalAudio(bool mote) async {
    return await _channel.invokeMethod('muteLocalAudio', {'mote': mote});
  }

  /// 设置音频路由
  ///
  /// [route] 音频路由，即声音由哪里输出（扬声器、听筒）。详见[TrtcAudioRouter]
  /// @discussion 微信和手机 QQ 视频通话功能的免提模式就是基于音频路由实现的。
  /// @discussion 一般手机都有两个扬声器，一个是位于顶部的听筒扬声器，声音偏小；一个是位于底部的立体声扬声器，声音偏大。
  /// @discussion 设置音频路由的作用就是决定声音使用哪个扬声器播放。
  static Future<void> setAudioRoute(int route) async {
    return await _channel.invokeMethod('setAudioRoute', {'route': route});
  }

  /// 静音某一个用户的声音，同时不再拉取该远端用户的音频数据流
  ///
  /// [userId] 对方的用户 ID
  /// [mote] true：静音；false：非静音
  static Future<void> muteRemoteAudio(String userId, bool mote) async {
    return await _channel.invokeMethod('muteRemoteAudio', {'userId': userId, 'mote': mote});
  }

  /// 静音所有用户的声音，同时不再拉取远端用户的音频数据流
  ///
  /// [mote] true：静音；false：非静音
  static Future<void> muteAllRemoteAudio(bool mote) async {
    return await _channel.invokeMethod('muteAllRemoteAudio', {'mote': mote});
  }

  /// 开始录音
  ///
  /// [path] 录音的文件地址
  /// 该方法调用后， SDK 会将通话过程中的所有音频（包括本地音频，远端音频，BGM 等）录制到一个文件里。
  /// 无论是否进房，调用该接口都生效。 如果调用 exitRoom 时还在录音，录音会自动停止。
  /// return 0：成功；-1：录音已开始；-2：文件或目录创建失败；-3：后缀指定的音频格式不支持
  static Future<int> startAudioRecording(String path) async {
    return await _channel.invokeMethod('startAudioRecording', {'path': path});
  }

  /// 停止录音
  ///
  /// 如果调用 exitRoom 时还在录音，录音会自动停止。
  static Future<void> stopAudioRecording() async {
    return await _channel.invokeMethod('stopAudioRecording');
  }
}
