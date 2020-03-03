package com.jvtd.flutter_trtc_plugin;

import android.app.Activity;
import android.app.Application;

import androidx.annotation.NonNull;

import com.tencent.trtc.TRTCCloud;
import com.tencent.trtc.TRTCCloudDef;

import java.lang.ref.WeakReference;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * FlutterTrtcPlugin
 */
public class FlutterTrtcPlugin implements FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler, ActivityAware
{
  private static final String PLUGIN_METHOD_NAME = "flutter_trtc_plugin";
  private static final String PLUGIN_EVENT_NAME = "flutter_trtc_plugin_callback";

  private MethodChannel mMethodChannel;
  private EventChannel mEventChannel;
  private Application mApplication;
  private WeakReference<Activity> mActivity;

  private TRTCCloud mTRTCCloud;

  /**
   * 新的加载方式
   *
   * @author Jack Zhang
   * create at 2020-03-02 16:21
   */
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding)
  {
    mApplication = (Application) flutterPluginBinding.getApplicationContext();

    mMethodChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), PLUGIN_METHOD_NAME);
    mMethodChannel.setMethodCallHandler(this);

    mEventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), PLUGIN_EVENT_NAME);
    mEventChannel.setStreamHandler(this);

  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding binding)
  {
    mActivity = new WeakReference<>(binding.getActivity());
  }

  @Override
  public void onDetachedFromActivityForConfigChanges()
  {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding)
  {

  }

  @Override
  public void onDetachedFromActivity()
  {
    mActivity = null;
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result)
  {
    if (call.method.equals("sharedInstance"))
    {
      mTRTCCloud = TRTCCloud.sharedInstance(mApplication);
    } else if (call.method.equals("setDefaultStreamRecvMode"))
    {
      boolean isReceivedAudio = numberToBoolValue((Boolean) call.argument("isReceivedAudio"));
      boolean isReceivedVideo = numberToBoolValue((Boolean) call.argument("isReceivedVideo"));
      mTRTCCloud.setDefaultStreamRecvMode(isReceivedAudio, isReceivedVideo);
    } else if (call.method.equals("enterRoom"))
    {
      int sdkAppId = numberToIntValue((Number) call.argument("sdkAppId"));// 应用标识 [必填]
      String userId = call.argument("userId");// 用户标识 [必填]
      String userSig = call.argument("userSig");// 用户签名 [必填]
      int roomId = numberToIntValue((Number) call.argument("roomId"));// 房间号码 [必填]
      int scene = numberToIntValue((Number) call.argument("scene"));// 应用场景，目前支持视频通话（VideoCall）、在线直播（Live）、语音通话（AudioCall）、语音聊天室（VoiceChatRoom）四种场景。
      TRTCCloudDef.TRTCParams param = new TRTCCloudDef.TRTCParams();
      param.sdkAppId = sdkAppId;
      param.userId = userId;
      param.userSig = userSig;
      param.roomId = roomId;
      mTRTCCloud.enterRoom(param, scene);


    } else
    {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding)
  {
    mMethodChannel.setMethodCallHandler(null);
    mMethodChannel = null;
    mEventChannel.setStreamHandler(null);
    mEventChannel = null;
  }

  @Override
  public void onListen(Object arguments, EventChannel.EventSink events)
  {

  }

  @Override
  public void onCancel(Object arguments)
  {

  }

  private boolean numberToBoolValue(Boolean number)
  {

    return number != null && number;
  }

  private int numberToIntValue(Number number)
  {

    return number != null ? number.intValue() : 0;
  }

  private long numberToLongValue(Number number)
  {

    return number != null ? number.longValue() : 0;
  }

  private float numberToFloatValue(Number number)
  {

    return number != null ? number.floatValue() : .0f;
  }


}
