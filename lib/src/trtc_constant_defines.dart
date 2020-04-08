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

class TrtcRole {
  /// 主播
  static const int TRTC_ROLE_ANCHOR = 20;

  /// 观众
  static const int TRTC_ROLE_AUDIENCE = 21;
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

class TrtcVideoResolution {
  static const int TRTC_VIDEO_RESOLUTION_120_120 = 1;
  static const int TRTC_VIDEO_RESOLUTION_160_160 = 3;
  static const int TRTC_VIDEO_RESOLUTION_270_270 = 5;
  static const int TRTC_VIDEO_RESOLUTION_480_480 = 7;
  static const int TRTC_VIDEO_RESOLUTION_160_120 = 50;
  static const int TRTC_VIDEO_RESOLUTION_240_180 = 52;
  static const int TRTC_VIDEO_RESOLUTION_280_210 = 54;
  static const int TRTC_VIDEO_RESOLUTION_320_240 = 56;
  static const int TRTC_VIDEO_RESOLUTION_400_300 = 58;
  static const int TRTC_VIDEO_RESOLUTION_480_360 = 60;
  static const int TRTC_VIDEO_RESOLUTION_640_480 = 62;
  static const int TRTC_VIDEO_RESOLUTION_960_720 = 64;
  static const int TRTC_VIDEO_RESOLUTION_160_90 = 100;
  static const int TRTC_VIDEO_RESOLUTION_256_144 = 102;
  static const int TRTC_VIDEO_RESOLUTION_320_180 = 104;
  static const int TRTC_VIDEO_RESOLUTION_480_270 = 106;
  static const int TRTC_VIDEO_RESOLUTION_640_360 = 108;
  static const int TRTC_VIDEO_RESOLUTION_960_540 = 110;
  static const int TRTC_VIDEO_RESOLUTION_1280_720 = 112;
}

class TrtcVideoResolutionMode {
  /// 横屏分辨率
  static const int TRTC_VIDEO_RESOLUTION_MODE_LANDSCAPE = 0;

  /// 竖屏分辨率
  static const int TRTC_VIDEO_RESOLUTION_MODE_PORTRAIT = 1;
}

class TrtcVideoQosControl {
  /// 客户端控制（用于 SDK 开发内部调试，客户请勿使用）
  static const int VIDEO_QOS_CONTROL_CLIENT = 0;

  /// 云端控制 （默认）
  static const int VIDEO_QOS_CONTROL_SERVER = 1;
}

class TrtcVideoQosPreference {
  /// 弱网下保流畅
  static const int TRTC_VIDEO_QOS_PREFERENCE_SMOOTH = 1;

  /// 弱网下保清晰
  static const int TRTC_VIDEO_QOS_PREFERENCE_CLEAR = 2;
}

class TrtcVideoMirrorType {
  /// SDK 决定镜像方式：前置摄像头镜像，后置摄像头不镜像
  static const int TRTC_VIDEO_MIRROR_TYPE_AUTO = 0;

  /// 前置摄像头和后置摄像头都镜像
  static const int TRTC_VIDEO_MIRROR_TYPE_ENABLE = 1;

  /// 前置摄像头和后置摄像头都不镜像
  static const int TRTC_VIDEO_MIRROR_TYPE_DISABLE = 2;
}

class TrtcVideoRotation {
  /// 不旋转
  static const int TRTC_VIDEO_ROTATION_0 = 0;

  /// 顺时针旋转90度
  static const int TRTC_VIDEO_ROTATION_90 = 1;

  /// 顺时针旋转180度
  static const int TRTC_VIDEO_ROTATION_180 = 2;

  /// 顺时针旋转270度
  static const int TRTC_VIDEO_ROTATION_270 = 3;
}
