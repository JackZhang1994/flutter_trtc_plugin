class TrtcAppScene {
  /// 视频通话场景，支持720P、1080P高清画质，单个房间最多支持300人同时在线，最高支持50人同时发言。
  /// 适合：[1对1视频通话]、[300人视频会议]、[在线问诊]、[视频聊天]、[远程面试]等。
  static const int TRTC_APP_SCENE_VIDEOCALL = 0;

  /// 视频互动直播，支持平滑上下麦，切换过程无需等待，主播延时小于300ms；支持十万级别观众同时播放，播放延时低至1000ms。
  /// 适合：[视频低延时直播]、[十万人互动课堂]、[视频直播 PK]、[视频相亲房]、[互动课堂]、[远程培训]、[超大型会议]等。
  /// 注意：此场景下，您必须通过 TRTCParams 中的 role 字段指定当前用户的角色。
  static const int TRTC_APP_SCENE_LIVE = 1;

  /// 语音通话场景，支持 48kHz，支持双声道。单个房间最多支持300人同时在线，最高支持50人同时发言。
  /// 适合：[1对1语音通话]、[300人语音会议]、[语音聊天]、[语音会议]、[在线狼人杀]等。
  static const int TRTC_APP_SCENE_AUDIOCALL = 2;

  /// 语音互动直播，支持平滑上下麦，切换过程无需等待，主播延时小于300ms；支持十万级别观众同时播放，播放延时低至1000ms。
  /// 适合：[语音低延时直播]、[语音直播连麦]、[语聊房]、[K 歌房]、[FM 电台]等。
  /// 注意：此场景下，您必须通过 TRTCParams 中的 role 字段指定当前用户的角色。
  static const int TRTC_APP_SCENE_VOICE_CHATROOM = 3;
}

class TrtcVideoStreamType {
  /// 主画面视频流，最常用的一条线路，一般用来传输摄像头的视频数据。
  static const int TRTC_VIDEO_STREAM_TYPE_BIG = 0;

  /// 小画面视频流，跟主画面的内容相同，但是分辨率和码率更低。
  static const int TRTC_VIDEO_STREAM_TYPE_SMALL = 1;

  /// 辅流，一般用于屏幕分享，以及远程播片（例如老师放一段视频给学生）。
  static const int TRTC_VIDEO_STREAM_TYPE_SUB = 2;
}

class TrtcVideoRenderMode {
  /// 图像铺满屏幕，超出显示视窗的视频部分将被裁剪
  static const int TRTC_VIDEO_RENDER_MODE_FILL = 0;

  /// 图像长边填满屏幕，短边区域会被填充黑色
  static const int TRTC_VIDEO_RENDER_MODE_FIT = 1;
}

class TrtcAudioRouter {
  /// 扬声器
  static const int TRTC_AUDIO_ROUTE_SPEAKER = 0;

  /// 听筒
  static const int TRTC_AUDIO_ROUTE_EARPIECE = 1;
}
