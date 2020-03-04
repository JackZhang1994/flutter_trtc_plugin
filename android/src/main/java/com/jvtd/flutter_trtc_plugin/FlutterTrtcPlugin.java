package com.jvtd.flutter_trtc_plugin;

import android.app.Activity;
import android.app.Application;

import androidx.annotation.NonNull;

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
  private static final String PLUGIN_VIEW_NAME = "flutter_trtc_plugin_view";

  private MethodChannel mMethodChannel;
  private EventChannel mEventChannel;
  private EventChannel.EventSink mEvents;
  private Application mApplication;
  private WeakReference<Activity> mActivity;
  private TrtcCloudManager mManager;

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
    mManager = new TrtcCloudManager(mApplication);

    mMethodChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), PLUGIN_METHOD_NAME);
    mMethodChannel.setMethodCallHandler(this);

    mEventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), PLUGIN_EVENT_NAME);
    mEventChannel.setStreamHandler(this);

    flutterPluginBinding.getPlatformViewRegistry().registerViewFactory(PLUGIN_VIEW_NAME, TrtcPlatformViewFactory.shareInstance());
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
    String method = call.method;
    if (method == null)
    {
      result.notImplemented();
      return;
    }
    switch (method)
    {
      case "sharedInstance":
        mManager.sharedInstance();
        break;

      case "destroySharedInstance":
        mManager.destroySharedInstance();
        break;

      case "enterRoom":
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
        mManager.enterRoom(param, scene);
        break;

      case "exitRoom":
        mManager.exitRoom();
        break;

      case "setDefaultStreamRecvMode":
        boolean isReceivedAudio = numberToBoolValue((Boolean) call.argument("isReceivedAudio"));
        boolean isReceivedVideo = numberToBoolValue((Boolean) call.argument("isReceivedVideo"));
        mManager.setDefaultStreamRecvMode(isReceivedAudio, isReceivedVideo);
        break;

      case "destroyPlatformView":
        int viewId = numberToIntValue((Number) call.argument("viewId"));
        boolean success = TrtcPlatformViewFactory.shareInstance().removeView(viewId);
        result.success(success);
        break;

      case "startLocalPreview":
        boolean frontCamera = numberToBoolValue((Boolean) call.argument("frontCamera"));
        int viewId1 = numberToIntValue((Number) call.argument("viewId"));
        mManager.startLocalPreview(frontCamera, viewId1);
        break;

      case "stopLocalPreview":
        mManager.stopLocalPreview();
        break;

      case "startRemoteView":
        String userId1 = call.argument("userId");// 用户标识 [必填]
        int viewId2 = numberToIntValue((Number) call.argument("viewId"));
        mManager.startRemoteView(userId1, viewId2);
        break;

      case "stopRemoteView":
        String userId2 = call.argument("userId");// 用户标识 [必填]
        mManager.stopRemoteView(userId2);
        break;

      case "stopAllRemoteView":
        mManager.stopAllRemoteView();
        break;

      case "muteLocalVideo":
        boolean mote = numberToBoolValue((Boolean) call.argument("mote"));
        mManager.muteLocalVideo(mote);
        break;

      case "setLocalViewFillMode":
        int mode = numberToIntValue((Number) call.argument("mode"));
        mManager.setLocalViewFillMode(mode);
        break;

      case "setRemoteViewFillMode":
        String userId3 = call.argument("userId");
        int mode1 = numberToIntValue((Number) call.argument("mode"));
        mManager.setRemoteViewFillMode(userId3, mode1);
        break;

      case "startLocalAudio":
        mManager.startLocalAudio();
        break;

      case "stopLocalAudio":
        mManager.stopLocalAudio();
        break;

      case "muteLocalAudio":
        boolean mote1 = numberToBoolValue((Boolean) call.argument("mote"));
        mManager.muteLocalAudio(mote1);
        break;

      case "setAudioRoute":
        int route = numberToIntValue((Number) call.argument("route"));
        mManager.setAudioRoute(route);
        break;

      case "muteRemoteAudio":
        String userId4 = call.argument("userId");
        boolean mote2 = numberToBoolValue((Boolean) call.argument("mote"));
        mManager.muteRemoteAudio(userId4, mote2);
        break;

      case "muteAllRemoteAudio":
        boolean mote3 = numberToBoolValue((Boolean) call.argument("mote"));
        mManager.muteAllRemoteAudio(mote3);
        break;

      case "switchCamera":
        mManager.switchCamera();
        break;

      default:
        result.notImplemented();
        break;
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding)
  {
    mManager = null;
    mMethodChannel.setMethodCallHandler(null);
    mMethodChannel = null;
    mEventChannel.setStreamHandler(null);
    mEventChannel = null;
  }

  @Override
  public void onListen(Object arguments, EventChannel.EventSink events)
  {
    mManager.setEvents(events);
    mEvents = events;
  }

  @Override
  public void onCancel(Object arguments)
  {
    mEvents = null;
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
