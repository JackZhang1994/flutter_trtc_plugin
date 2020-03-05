package com.jvtd.flutter_trtc_plugin;

import android.content.Context;

import com.tencent.rtmp.ui.TXCloudVideoView;
import com.tencent.trtc.TRTCCloud;
import com.tencent.trtc.TRTCCloudDef;

import org.json.JSONException;
import org.json.JSONObject;

import io.flutter.plugin.common.EventChannel;

/**
 * 封装了 TRTCCloud 的基本功能，方便直接调用
 */
public class TrtcCloudManager
{
  private static final String TAG = TrtcCloudListenerImpl.class.getName();

  private Context mContext;
  private TRTCCloud mTRTCCloud;                 // SDK 核心类


  /**
   * 美颜相关
   */
  private int mBeautyLevel = 5;        // 美颜等级
  private int mWhiteningLevel = 3;        // 美白等级
  private int mRuddyLevel = 2;        // 红润等级
  private int mBeautyStyle = TRTCCloudDef.TRTC_BEAUTY_STYLE_SMOOTH;// 美颜风格

  public TrtcCloudManager(Context context)
  {
    mContext = context;
  }

  public void setEvents(EventChannel.EventSink events)
  {
    mTRTCCloud.setListener(new TrtcCloudListenerImpl(events));
  }

  public void sharedInstance()
  {
    mTRTCCloud = TRTCCloud.sharedInstance(mContext);
  }

  public void destroySharedInstance()
  {
    mTRTCCloud.setListener(null);
    TRTCCloud.destroySharedInstance();
  }

  public void enterRoom(TRTCCloudDef.TRTCParams param, int scene)
  {
    if (mTRTCCloud != null)
    {
      mTRTCCloud.enterRoom(param, scene);
    }
  }

  public void exitRoom()
  {
    if (mTRTCCloud != null)
    {
      mTRTCCloud.exitRoom();
    }
  }

  public void setDefaultStreamRecvMode(boolean isReceivedAudio, boolean isReceivedVideo)
  {
    if (mTRTCCloud != null)
    {
      mTRTCCloud.setDefaultStreamRecvMode(isReceivedAudio, isReceivedVideo);
    }
  }

  public void startLocalPreview(boolean frontCamera, int viewId)
  {
    TrtcPlatformView trtcPlatformView = TrtcPlatformViewFactory.shareInstance().getPlatformView(viewId);
    if (trtcPlatformView == null)
    {
      return;
    }
    TXCloudVideoView txCloudVideoView = (TXCloudVideoView) trtcPlatformView.getView();
    if (txCloudVideoView == null)
    {
      return;
    }
    if (mTRTCCloud != null)
    {
      mTRTCCloud.startLocalPreview(frontCamera, txCloudVideoView);
    }
  }

  public void stopLocalPreview()
  {
    if (mTRTCCloud != null)
    {
      mTRTCCloud.stopLocalPreview();
    }
  }

  public void startRemoteView(String userId, int viewId)
  {
    TrtcPlatformView trtcPlatformView = TrtcPlatformViewFactory.shareInstance().getPlatformView(viewId);
    if (trtcPlatformView == null)
    {
      return;
    }
    TXCloudVideoView txCloudVideoView = (TXCloudVideoView) trtcPlatformView.getView();
    if (txCloudVideoView == null)
    {
      return;
    }
    if (mTRTCCloud != null)
    {
      mTRTCCloud.startRemoteView(userId, txCloudVideoView);
    }
  }

  public void stopRemoteView(String userId)
  {
    if (mTRTCCloud != null)
    {
      mTRTCCloud.stopRemoteView(userId);
    }
  }

  public void stopAllRemoteView()
  {
    if (mTRTCCloud != null)
    {
      mTRTCCloud.stopAllRemoteView();
    }
  }

  public void muteLocalVideo(boolean mute)
  {
    if (mTRTCCloud != null)
    {
      mTRTCCloud.muteLocalVideo(mute);
    }
  }

  public void setLocalViewFillMode(int mode)
  {
    if (mTRTCCloud != null)
    {
      mTRTCCloud.setLocalViewFillMode(mode);
    }
  }

  public void setRemoteViewFillMode(String userId, int mode)
  {
    if (mTRTCCloud != null)
    {
      mTRTCCloud.setRemoteViewFillMode(userId, mode);
    }
  }

  public void setVideoEncoderParam(TRTCCloudDef.TRTCVideoEncParam endParam)
  {
    if (mTRTCCloud != null)
    {
      mTRTCCloud.setVideoEncoderParam(endParam);
    }
  }

  public void setNetworkQosParam(TRTCCloudDef.TRTCNetworkQosParam qosParam)
  {
    if (mTRTCCloud != null)
    {
      mTRTCCloud.setNetworkQosParam(qosParam);
    }
  }

  public void setLocalViewMirror(int mirrorType)
  {
    if (mTRTCCloud != null)
    {
      mTRTCCloud.setLocalViewMirror(mirrorType);
    }
  }

  public void setVideoEncoderMirror(boolean mirror)
  {
    if (mTRTCCloud != null)
    {
      mTRTCCloud.setVideoEncoderMirror(mirror);
    }
  }

  public void startLocalAudio()
  {
    if (mTRTCCloud != null)
    {
      mTRTCCloud.startLocalAudio();
    }
  }

  public void stopLocalAudio()
  {
    if (mTRTCCloud != null)
    {
      mTRTCCloud.stopLocalAudio();
    }
  }

  public void muteLocalAudio(boolean mute)
  {
    if (mTRTCCloud != null)
    {
      mTRTCCloud.muteLocalAudio(mute);
    }
  }

  public void setAudioRoute(int route)
  {
    if (mTRTCCloud != null)
    {
      mTRTCCloud.setAudioRoute(route);
    }
  }

  public void muteRemoteAudio(String userId, boolean mote)
  {
    if (mTRTCCloud != null)
    {
      mTRTCCloud.muteRemoteAudio(userId, mote);
    }
  }

  public void muteAllRemoteAudio(boolean mote)
  {
    if (mTRTCCloud != null)
    {
      mTRTCCloud.muteAllRemoteAudio(mote);
    }
  }

  public void switchCamera()
  {
    if (mTRTCCloud != null)
    {
      mTRTCCloud.switchCamera();
    }
  }


//  /**
//   * 对进房的设置进行初始化
//   *
//   * @param isCustomCaptureAndRender 是否为自采集，开启该模式，SDK 只保留编码和发送能力
//   */
//  public void initTRTCManager(boolean isCustomCaptureAndRender, boolean isReceivedAudio, boolean isReceivedVideo)
//  {
//    AudioConfig audioConfig = ConfigHelper.getInstance().getAudioConfig();
//    VideoConfig videoConfig = ConfigHelper.getInstance().getVideoConfig();
//
//
//    // 是否为自采集，请在调用 SDK 相关配置前优先设置好，避免时序导致的异常问题。
//    if (isCustomCaptureAndRender)
//    {
//      mTRTCCloud.enableCustomVideoCapture(isCustomCaptureAndRender);
//      mTRTCCloud.enableCustomAudioCapture(isCustomCaptureAndRender);
//    }
//
//    // 对接收模式进行操作
//
//    // 设置美颜参数
//    mTRTCCloud.setBeautyStyle(TRTCCloudDef.TRTC_BEAUTY_STYLE_SMOOTH, 5, 5, 5);
//
//    // 设置视频渲染模式
//    setVideoFillMode(videoConfig.isVideoFillMode());
//
//    // 设置视频旋转角
//    setLocalVideoRotation(videoConfig.getLocalRotation());
//
//    // 是否开启免提
//    //enableAudioHandFree(audioConfig.isAudioHandFreeMode());
//
//    // 是否开启重力感应
//    enableGSensor(videoConfig.isEnableGSensorMode());
//
//    // 是否开启媒体音量
//    //setSystemVolumeType(audioConfig.getAudioVolumeType());
//
//    // 采样率设置
//    enable16KSampleRate(audioConfig.isEnable16KSampleRate());
//
//    // AGC设置
//    enableAGC(audioConfig.isAGC());
//
//    // ANS设置
//    enableANS(audioConfig.isANS());
//
//    // 是否开启推流画面镜像
//    enableVideoEncMirror(videoConfig.isRemoteMirror());
//
//    // 设置本地画面是否镜像预览
//    setLocalViewMirror(videoConfig.getMirrorType());
//
//    // 是否开启水印
//    enableWatermark(videoConfig.isWatermark());
//
//    // 【关键】设置 TRTC 推流参数
//    setTRTCCloudParam();
//  }
//
//  /**
//   * 设置 TRTC 推流参数
//   */
//  public void setTRTCCloudParam()
//  {
//    setBigSteam();
//    setQosParam();
//    setSmallSteam();
//  }
//
//  public void setBigSteam()
//  {
//    // 大画面的编码器参数设置
//    // 设置视频编码参数，包括分辨率、帧率、码率等等，这些编码参数来自于 videoConfig 的设置
//    // 注意（1）：不要在码率很低的情况下设置很高的分辨率，会出现较大的马赛克
//    // 注意（2）：不要设置超过25FPS以上的帧率，因为电影才使用24FPS，我们一般推荐15FPS，这样能将更多的码率分配给画质
//    VideoConfig videoConfig = ConfigHelper.getInstance().getVideoConfig();
//    TRTCCloudDef.TRTCVideoEncParam encParam = new TRTCCloudDef.TRTCVideoEncParam();
//    encParam.videoResolution = videoConfig.getVideoResolution();
//    encParam.videoFps = videoConfig.getVideoFps();
//    encParam.videoBitrate = videoConfig.getVideoBitrate();
//    encParam.videoResolutionMode = videoConfig.isVideoVertical() ? TRTCCloudDef.TRTC_VIDEO_RESOLUTION_MODE_PORTRAIT : TRTCCloudDef.TRTC_VIDEO_RESOLUTION_MODE_LANDSCAPE;
//    if (mAppScene == TRTCCloudDef.TRTC_APP_SCENE_VIDEOCALL)
//    {
//      encParam.enableAdjustRes = true;
//    }
//    mTRTCCloud.setVideoEncoderParam(encParam);
//  }
//
//  public void setQosParam()
//  {
//    VideoConfig videoConfig = ConfigHelper.getInstance().getVideoConfig();
//    TRTCCloudDef.TRTCNetworkQosParam qosParam = new TRTCCloudDef.TRTCNetworkQosParam();
//    qosParam.controlMode = videoConfig.getQosMode();
//    qosParam.preference = videoConfig.getQosPreference();
//    mTRTCCloud.setNetworkQosParam(qosParam);
//  }
//
//  public void setSmallSteam()
//  {
//    //小画面的编码器参数设置
//    //TRTC SDK 支持大小两路画面的同时编码和传输，这样网速不理想的用户可以选择观看小画面
//    //注意：iPhone & Android 不要开启大小双路画面，非常浪费流量，大小路画面适合 Windows 和 MAC 这样的有线网络环境
//    VideoConfig videoConfig = ConfigHelper.getInstance().getVideoConfig();
//
//    TRTCCloudDef.TRTCVideoEncParam smallParam = new TRTCCloudDef.TRTCVideoEncParam();
//    smallParam.videoResolution = TRTCCloudDef.TRTC_VIDEO_RESOLUTION_160_90;
//    smallParam.videoFps = videoConfig.getVideoFps();
//    smallParam.videoBitrate = 100;
//    smallParam.videoResolutionMode = videoConfig.isVideoVertical() ? TRTCCloudDef.TRTC_VIDEO_RESOLUTION_MODE_PORTRAIT : TRTCCloudDef.TRTC_VIDEO_RESOLUTION_MODE_LANDSCAPE;
//
//    mTRTCCloud.enableEncSmallVideoStream(videoConfig.isEnableSmall(), smallParam);
//    mTRTCCloud.setPriorRemoteVideoStreamType(videoConfig.isPriorSmall() ? TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_SMALL : TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_BIG);
//  }
//
//
//  /**
//   * 系统音量类型
//   *
//   * @param type {@link TRTCCloudDef#TRTCSystemVolumeTypeAuto}
//   */
//  public void setSystemVolumeType(int type)
//  {
//    mTRTCCloud.setSystemVolumeType(type);
//  }


  /**
   * 声音采样率
   *
   * @param enable true 开启16k采样率 false 开启48k采样率
   */
  public void enable16KSampleRate(boolean enable)
  {
    JSONObject jsonObject = new JSONObject();
    try
    {
      jsonObject.put("api", "setAudioSampleRate");
      JSONObject params = new JSONObject();
      params.put("sampleRate", enable ? 16000 : 48000);
      jsonObject.put("params", params);
      mTRTCCloud.callExperimentalAPI(jsonObject.toString());
    } catch (JSONException e)
    {
      e.printStackTrace();
    }
  }

  /**
   * 是否开启自动增益补偿功能, 可以自动调麦克风的收音量到一定的音量水平
   *
   * @param enable
   */
  public void enableAGC(boolean enable)
  {
    JSONObject jsonObject = new JSONObject();
    try
    {
      jsonObject.put("api", "enableAudioAGC");
      JSONObject params = new JSONObject();
      params.put("enable", enable ? 1 : 0);
      jsonObject.put("params", params);
      mTRTCCloud.callExperimentalAPI(jsonObject.toString());
    } catch (JSONException e)
    {
      e.printStackTrace();
    }
  }

  /**
   * 回声消除器，可以消除各种延迟的回声
   *
   * @param enable
   */
  public void enableAEC(boolean enable)
  {
    JSONObject jsonObject = new JSONObject();
    try
    {
      jsonObject.put("api", "enableAudioAEC");
      JSONObject params = new JSONObject();
      params.put("enable", enable ? 1 : 0);
      jsonObject.put("params", params);
      mTRTCCloud.callExperimentalAPI(jsonObject.toString());
    } catch (JSONException e)
    {
      e.printStackTrace();
    }
  }

  /**
   * 背景噪音抑制功能，可探测出背景固定频率的杂音并消除背景噪音
   *
   * @param enable
   */
  public void enableANS(boolean enable)
  {
    JSONObject jsonObject = new JSONObject();
    try
    {
      jsonObject.put("api", "enableAudioANS");
      JSONObject params = new JSONObject();
      params.put("enable", enable ? 1 : 0);
      jsonObject.put("params", params);
      mTRTCCloud.callExperimentalAPI(jsonObject.toString());
    } catch (JSONException e)
    {
      e.printStackTrace();
    }
  }
}
