package com.jvtd.flutter_trtc_plugin;

import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.collection.LongSparseArray;

import com.tencent.trtc.TRTCCloudDef;

import java.util.HashMap;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.view.FlutterNativeView;
import io.flutter.view.TextureRegistry;

/**
 * FlutterTrtcPlugin
 */
public class FlutterTrtcPlugin implements MethodCallHandler, EventChannel.StreamHandler {
    private static final String TAG = "FlutterTrtcPlugin";

    private static final String PLUGIN_METHOD_NAME = "flutter_trtc_plugin";
    private static final String PLUGIN_EVENT_NAME = "flutter_trtc_plugin_callback";
    private static final String PLUGIN_VIEW_NAME = "flutter_trtc_plugin/view";

    private static final String PLUGIN_VIDEO_EVENT_NAME = "flutter_trtc_plugin_video_event";
    private static final String PLUGIN_DOWNLOAD_EVENT_NAME = "flutter_trtc_plugin_download_event";

    private TrtcCloudManager mManager;
    private Context mContext;
    private final LongSparseArray<TencentPlayer> videoPlayers;
    private final HashMap<String, TencentDownload> downloadManagerMap;
    private final PluginRegistry.Registrar registrar;

    private FlutterTrtcPlugin(PluginRegistry.Registrar registrar) {
        mContext = registrar.context();    //获取应用程序的Context
        mManager = new TrtcCloudManager(mContext);
        this.registrar = registrar;
        this.videoPlayers = new LongSparseArray<>();
        this.downloadManagerMap = new HashMap<>();
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(PluginRegistry.Registrar registrar) {
        final FlutterTrtcPlugin plugin = new FlutterTrtcPlugin(registrar);
        MethodChannel methodChannel = new MethodChannel(registrar.messenger(), PLUGIN_METHOD_NAME);
        methodChannel.setMethodCallHandler(plugin);

        EventChannel eventChannel = new EventChannel(registrar.messenger(), PLUGIN_EVENT_NAME);
        eventChannel.setStreamHandler(plugin);


        boolean success = registrar.platformViewRegistry().registerViewFactory(PLUGIN_VIEW_NAME, TrtcPlatformViewFactory.shareInstance());
        Log.i(TAG, "Register PlatformView的状态为：" + success);

        registrar.addViewDestroyListener(
                new PluginRegistry.ViewDestroyListener() {
                    @Override
                    public boolean onViewDestroy(FlutterNativeView flutterNativeView) {
                        plugin.onDestroy();
                        return false;
                    }
                }
        );
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        TextureRegistry textures = registrar.textures();
        String method = call.method;
        if (method == null) {
            result.notImplemented();
            return;
        }
        switch (method) {
            case "sharedInstance":
                mManager.sharedInstance();
                break;

            case "destroySharedInstance":
                mManager.destroySharedInstance();
                break;

            case "getUserSig":
                int appId = numberToIntValue((Number) call.argument("sdkAppId"));
                String secretKey = call.argument("secretKey");
                String uid = call.argument("userId");
                result.success(GenerateTestUserSig.genTestUserSig(appId, secretKey, uid));
                break;

            case "enterRoom":
                int sdkAppId = numberToIntValue((Number) call.argument("sdkAppId"));// 应用标识 [必填]
                String userId = call.argument("userId");// 用户标识 [必填]
                String userSig = call.argument("userSig");// 用户签名 [必填]
                int roomId = numberToIntValue((Number) call.argument("roomId"));// 房间号码 [必填]
                int scene = numberToIntValue((Number) call.argument("scene"));// 应用场景，目前支持视频通话（VideoCall）、在线直播（Live）、语音通话（AudioCall）、语音聊天室（VoiceChatRoom）四种场景。
                int role = numberToIntValue((Number) call.argument("role"));// 直播场景下的角色
                String streamId = call.argument("streamId");// 流ID
                TRTCCloudDef.TRTCParams param = new TRTCCloudDef.TRTCParams();
                param.sdkAppId = sdkAppId;
                param.userId = userId;
                param.userSig = userSig;
                param.roomId = roomId;
                if (role != 0) {
                    param.role = role;
                }
                if (streamId != null && streamId.length() > 0) {
                    param.streamId = streamId;
                }
                mManager.enterRoom(param, scene);
                break;

            case "exitRoom":
                mManager.exitRoom();
                break;
            case "startSpeedTest":
                int sdkAppIdSpeedTest = numberToIntValue((Number) call.argument("sdkAppId"));// 应用标识 [必填]
                String userIdSpeedTest = call.argument("userId");// 用户标识 [必填]
                String userSigSpeedTest = call.argument("userSig");// 用户签名 [必填]
                mManager.startSpeedTest(sdkAppIdSpeedTest, userIdSpeedTest, userSigSpeedTest);
                break;
            case "stopSpeedTest":
                mManager.stopSpeedTest();
                break;

            case "switchRole":
                int role1 = numberToIntValue((Number) call.argument("role"));
                mManager.switchRole(role1);
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

            case "setRemoteViewRotation":
                String userId9 = call.argument("userId");
                int rotation2 = numberToIntValue((Number) call.argument("rotation"));
                mManager.setRemoteViewRotation(userId9, rotation2);
                break;

            case "setVideoEncoderParam":
                int videoResolution = numberToIntValue((Number) call.argument("videoResolution"));
                int videoResolutionMode = numberToIntValue((Number) call.argument("videoResolutionMode"));
                int videoFps = numberToIntValue((Number) call.argument("videoFps"));
                int videoBitrate = numberToIntValue((Number) call.argument("videoBitrate"));
                boolean enableAdjustRes = numberToBoolValue((Boolean) call.argument("enableAdjustRes"));
                TRTCCloudDef.TRTCVideoEncParam endParam = new TRTCCloudDef.TRTCVideoEncParam();
                endParam.videoResolution = videoResolution;
                endParam.videoResolutionMode = videoResolutionMode;
                endParam.videoFps = videoFps;
                endParam.videoBitrate = videoBitrate;
                endParam.enableAdjustRes = enableAdjustRes;
                mManager.setVideoEncoderParam(endParam);
                break;

            case "setNetworkQosParam":
                int preference = numberToIntValue((Number) call.argument("preference"));
                int controlMode = numberToIntValue((Number) call.argument("controlMode"));
                TRTCCloudDef.TRTCNetworkQosParam qosParam = new TRTCCloudDef.TRTCNetworkQosParam();
                qosParam.preference = preference;
                qosParam.controlMode = controlMode;
                mManager.setNetworkQosParam(qosParam);
                break;

            case "setLocalViewMirror":
                int mirrorType = numberToIntValue((Number) call.argument("mirrorType"));
                mManager.setLocalViewMirror(mirrorType);
                break;

            case "setVideoEncoderMirror":
                boolean mirror = numberToBoolValue((Boolean) call.argument("mirror"));
                mManager.setVideoEncoderMirror(mirror);
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

            case "startAudioRecording":
                String path = call.argument("path");
                TRTCCloudDef.TRTCAudioRecordingParams params = new TRTCCloudDef.TRTCAudioRecordingParams();
                params.filePath = path;
                result.success(mManager.startAudioRecording(params));
                break;

            case "stopAudioRecording":
                mManager.stopAudioRecording();
                break;

            case "switchCamera":
                mManager.switchCamera();
                break;

            case "startRemoteSubStreamView":
                String userId5 = call.argument("userId");// 用户标识 [必填]
                int viewId3 = numberToIntValue((Number) call.argument("viewId"));
                mManager.startRemoteSubStreamView(userId5, viewId3);
                break;

            case "stopRemoteSubStreamView":
                String userId6 = call.argument("userId");// 用户标识 [必填]
                mManager.stopRemoteSubStreamView(userId6);
                break;

            case "setRemoteSubStreamViewFillMode":
                String userId7 = call.argument("userId");
                int mode2 = numberToIntValue((Number) call.argument("mode"));
                mManager.setRemoteSubStreamViewFillMode(userId7, mode2);
                break;

            case "setRemoteSubStreamViewRotation":
                String userId8 = call.argument("userId");
                int rotation = numberToIntValue((Number) call.argument("rotation"));
                mManager.setRemoteSubStreamViewRotation(userId8, rotation);
                break;

            case "init":
                disposeAllPlayers();
                break;
            case "create":
                TextureRegistry.SurfaceTextureEntry handle = textures.createSurfaceTexture();
                EventChannel eventChannel = new EventChannel(registrar.messenger(), PLUGIN_VIDEO_EVENT_NAME + handle.id());
                TencentPlayer player = new TencentPlayer(registrar, eventChannel, handle, call, result);
                videoPlayers.put(handle.id(), player);
                break;
            case "download":
                String urlOrFileId = call.argument("urlOrFileId");
                EventChannel downloadEventChannel = new EventChannel(registrar.messenger(), PLUGIN_DOWNLOAD_EVENT_NAME + urlOrFileId);
                TencentDownload tencentDownload = new TencentDownload(registrar, downloadEventChannel, call, result);
                downloadManagerMap.put(urlOrFileId, tencentDownload);
                break;
            case "stopDownload":
                String urlOrFileId1 = call.argument("urlOrFileId");
                TencentDownload download = downloadManagerMap.get(urlOrFileId1);
                if (download != null) {
                    download.stopDownload();
                }
                result.success(null);
                break;
            case "play":
            case "pause":
            case "seekTo":
            case "setRate":
            case "setBitrateIndex":
            case "dispose":
                long textureId = numberToLongValue((Number) call.argument("textureId"));
                TencentPlayer tencentPlayer = videoPlayers.get(textureId);
                if (tencentPlayer == null) {
                    result.error(
                            "Unknown textureId",
                            "No video player associated with texture id " + textureId,
                            null);
                    return;
                }
                onMethodCall(call, result, textureId, tencentPlayer);
                break;

            default:
                result.notImplemented();
                break;
        }
    }

    // 视频相关
    private void onMethodCall(MethodCall call, Result result, long textureId, TencentPlayer player) {
        switch (call.method) {
            case "play":
                player.play();
                result.success(null);
                break;
            case "pause":
                player.pause();
                result.success(null);
                break;
            case "seekTo":
                int location = numberToIntValue((Number) call.argument("location"));
                player.seekTo(location);
                result.success(null);
                break;
            case "setRate":
                float rate = numberToFloatValue((Number) call.argument("rate"));
                player.setRate(rate);
                result.success(null);
                break;
            case "setBitrateIndex":
                int bitrateIndex = numberToIntValue((Number) call.argument("index"));
                player.setBitrateIndex(bitrateIndex);
                result.success(null);
                break;
            case "dispose":
                player.dispose();
                videoPlayers.remove(textureId);
                result.success(null);
                break;
            default:
                result.notImplemented();
                break;
        }

    }


    private void disposeAllPlayers() {
        for (int i = 0; i < videoPlayers.size(); i++) {
            videoPlayers.valueAt(i).dispose();
        }
        videoPlayers.clear();
    }

    private void onDestroy() {
        disposeAllPlayers();
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        mManager.setEvents(events);
        TrtcPlatformViewFactory.shareInstance().setEventSink(events);
    }

    @Override
    public void onCancel(Object arguments) {
    }

    private boolean numberToBoolValue(Boolean number) {

        return number != null && number;
    }

    private int numberToIntValue(Number number) {

        return number != null ? number.intValue() : 0;
    }

    private long numberToLongValue(Number number) {

        return number != null ? number.longValue() : 0;
    }

    private float numberToFloatValue(Number number) {

        return number != null ? number.floatValue() : .0f;
    }
}
