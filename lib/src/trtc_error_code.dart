/// 错误码表
class TrtcErrorCode {
  /// 基础错误码
  static final int ERR_NULL = 0; // 无错误

  /// 进房相关错误码
  /// TRTCCloud.enterRoom() 在进房失败时会触发此类错误码，您可以通过回调函数 TRTCCloudDelegate.onEnterRoom() 和 TRTCCloudDelegate.OnError() 捕获相关通知。
  static final int ERR_ROOM_ENTER_FAIL = -3301; // 进入房间失败
  static final int ERR_ENTER_ROOM_PARAM_NULL = -3316; // 进房参数为空，请检查 enterRoom:appScene: 接口调用是否传入有效的 param
  static final int ERR_SDK_APPID_INVALID = -3317; // 进房参数 sdkAppId 错误
  static final int ERR_ROOM_ID_INVALID = -3318; // 进房参数 roomId 错误
  static final int ERR_USER_ID_INVALID = -3319; // 进房参数 userID 不正确
  static final int ERR_USER_SIG_INVALID = -3320; // 进房参数 userSig 不正确
  static final int ERR_ROOM_REQUEST_ENTER_ROOM_TIMEOUT = -3308; // 请求进房超时，请检查网络
  static final int ERR_SERVER_INFO_SERVICE_SUSPENDED = -100013; // 服务不可用。请检查：套餐包剩余分钟数是否大于0，腾讯云账号是否欠费

  /// 退房相关错误码
  /// TRTCCloud.exitRoom() 在退房失败时会触发此类错误码，您可以通过回调函数 TRTCCloudDelegate.OnError() 捕获相关通知。
  static final int ERR_ROOM_REQUEST_QUIT_ROOM_TIMEOUT = -3325; // 请求退房超时

  /// 设备（摄像头、麦克风、扬声器）相关错误码
  /// 您可以通过回调函数 TRTCCloudDelegate.OnError() 捕获相关通知。
  static final int ERR_CAMERA_START_FAIL =
      -1301; // 打开摄像头失败，例如在 Windows 或 Mac 设备，摄像头的配置程序（驱动程序）异常，禁用后重新启用设备，或者重启机器，或者更新配置程序
  static final int ERR_CAMERA_NOT_AUTHORIZED = -1314; // 摄像头设备未授权，通常在移动设备出现，可能是权限被用户拒绝了
  static final int ERR_CAMERA_SET_PARAM_FAIL = -1315; // 摄像头参数设置出错（参数不支持或其它）
  static final int ERR_CAMERA_OCCUPY = -1316; // 摄像头正在被占用中，可尝试打开其他摄像头
  static final int ERR_MIC_START_FAIL =
      -1302; // 打开麦克风失败，例如在 Windows 或 Mac 设备，麦克风的配置程序（驱动程序）异常，禁用后重新启用设备，或者重启机器，或者更新配置程序
  static final int ERR_MIC_NOT_AUTHORIZED = -1317; // 麦克风设备未授权，通常在移动设备出现，可能是权限被用户拒绝了
  static final int ERR_MIC_SET_PARAM_FAIL = -1318; // 麦克风设置参数失败
  static final int ERR_MIC_OCCUPY = -1319; // 麦克风正在被占用中，例如移动设备正在通话时，打开麦克风会失败
  static final int ERR_MIC_STOP_FAIL = -1320; // 停止麦克风失败
  static final int ERR_SPEAKER_START_FAIL =
      -1321; // 打开扬声器失败，例如在 Windows 或 Mac 设备，扬声器的配置程序（驱动程序）异常，禁用后重新启用设备，或者重启机器，或者更新配置程序
  static final int ERR_SPEAKER_SET_PARAM_FAIL = -1322; // 扬声器设置参数失败
  static final int ERR_SPEAKER_STOP_FAIL = -1323; // 停止扬声器失败

  /// 编解码相关错误码
  /// 您可以通过回调函数 TRTCCloudDelegate.OnError() 捕获相关通知。
  static final int ERR_VIDEO_ENCODE_FAIL = -1303; // 视频帧编码失败，例如 iOS 设备切换到其他应用时，硬编码器可能被系统释放，再切换回来时，硬编码器重启前，可能会抛出
  static final int ERR_UNSUPPORTED_RESOLUTION = -1305; // 不支持的视频分辨率
  static final int ERR_AUDIO_ENCODE_FAIL = -1304; // 音频帧编码失败，例如传入自定义音频数据，SDK 无法处理
  static final int ERR_UNSUPPORTED_SAMPLERATE = -1306; // 不支持的音频采样率

}
