package com.jvtd.flutter_trtc_plugin;

import android.os.Bundle;
import android.util.Log;

import com.tencent.trtc.TRTCCloudDef;
import com.tencent.trtc.TRTCCloudListener;

import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import io.flutter.plugin.common.EventChannel;

/**
 * SDK 回调实现类，这里对TRTCCloudListener做了一个封装
 */
public class TrtcCloudListenerImpl extends TRTCCloudListener {
    private static final String TAG = TrtcCloudListenerImpl.class.getName();

    private WeakReference<EventChannel.EventSink> mWefListener;

    public TrtcCloudListenerImpl(EventChannel.EventSink eventSink) {
        super();
        mWefListener = new WeakReference<>(eventSink);
    }

    @Override
    public void onError(int errCode, String errMsg, Bundle extraInfo) {
        Log.i(TAG, "onError: errCode = " + errCode + " errMsg = " + errMsg);
        EventChannel.EventSink eventSink = mWefListener.get();
        if (eventSink != null) {
            HashMap<String, Object> returnMap = new HashMap<>();
            HashMap<String, Object> method = new HashMap<>();
            method.put("name", "onError");
            method.put("errCode", errCode);
            method.put("errMsg", errMsg);
            returnMap.put("method", method);
            eventSink.success(returnMap);
        }
    }

    @Override
    public void onWarning(int warningCode, String warningMsg, Bundle extraInfo) {
        Log.i(TAG, "onWarning: warningCode = " + warningCode + " warningMsg = " + warningMsg);
        EventChannel.EventSink eventSink = mWefListener.get();
        if (eventSink != null) {
            HashMap<String, Object> returnMap = new HashMap<>();
            HashMap<String, Object> method = new HashMap<>();
            method.put("name", "onWarning");
            method.put("warningCode", warningCode);
            method.put("warningMsg", warningMsg);
            returnMap.put("method", method);
            eventSink.success(returnMap);
        }
    }

    @Override
    public void onEnterRoom(long elapsed) {
        Log.i(TAG, "onEnterRoom: elapsed = " + elapsed);
        final EventChannel.EventSink eventSink = mWefListener.get();
        if (eventSink != null) {
            HashMap<String, Object> returnMap = new HashMap<>();
            HashMap<String, Object> method = new HashMap<>();
            method.put("name", "onEnterRoom");
            method.put("result", elapsed);
            returnMap.put("method", method);
            eventSink.success(returnMap);
        }
    }

    @Override
    public void onExitRoom(int reason) {
        Log.i(TAG, "onExitRoom: reason = " + reason);
        final EventChannel.EventSink eventSink = mWefListener.get();
        if (eventSink != null) {
            HashMap<String, Object> returnMap = new HashMap<>();
            HashMap<String, Object> method = new HashMap<>();
            method.put("name", "onExitRoom");
            method.put("reason", reason);
            returnMap.put("method", method);
            eventSink.success(returnMap);
        }
    }

    @Override
    public void onSwitchRole(int errCode, String errMsg) {
        Log.i(TAG, "onSwitchRole: errCode = " + errCode + ", errMsg = " + errMsg);
        final EventChannel.EventSink eventSink = mWefListener.get();
        if (eventSink != null) {
            HashMap<String, Object> returnMap = new HashMap<>();
            HashMap<String, Object> method = new HashMap<>();
            method.put("name", "onSwitchRole");
            method.put("errCode", errCode);
            method.put("errMsg", errMsg);
            returnMap.put("method", method);
            eventSink.success(returnMap);
        }
    }

    @Override
    public void onRemoteUserEnterRoom(String userId) {
        Log.i(TAG, "onRemoteUserEnterRoom: userId = " + userId);
        EventChannel.EventSink eventSink = mWefListener.get();
        if (eventSink != null) {
            HashMap<String, Object> returnMap = new HashMap<>();
            HashMap<String, Object> method = new HashMap<>();
            method.put("name", "onRemoteUserEnterRoom");
            method.put("userId", userId);
            returnMap.put("method", method);
            eventSink.success(returnMap);
        }
    }

    @Override
    public void onRemoteUserLeaveRoom(String userId, int reason) {
        Log.i(TAG, "onRemoteUserLeaveRoom: userId = " + userId + " reason = " + reason);
        EventChannel.EventSink eventSink = mWefListener.get();
        if (eventSink != null) {
            HashMap<String, Object> returnMap = new HashMap<>();
            HashMap<String, Object> method = new HashMap<>();
            method.put("name", "onRemoteUserLeaveRoom");
            method.put("userId", userId);
            method.put("reason", reason);
            returnMap.put("method", method);
            eventSink.success(returnMap);
        }
    }

    @Override
    public void onUserVideoAvailable(final String userId, boolean available) {
        Log.i(TAG, "onUserVideoAvailable: userId = " + userId + " available = " + available);
        EventChannel.EventSink eventSink = mWefListener.get();
        if (eventSink != null) {
            HashMap<String, Object> returnMap = new HashMap<>();
            HashMap<String, Object> method = new HashMap<>();
            method.put("name", "onUserVideoAvailable");
            method.put("userId", userId);
            method.put("available", available);
            returnMap.put("method", method);
            eventSink.success(returnMap);
        }
    }

    @Override
    public void onUserAudioAvailable(String userId, boolean available) {
        Log.i(TAG, "onUserAudioAvailable: userId = " + userId + " available = " + available);
        EventChannel.EventSink eventSink = mWefListener.get();
        if (eventSink != null) {
            HashMap<String, Object> returnMap = new HashMap<>();
            HashMap<String, Object> method = new HashMap<>();
            method.put("name", "onUserAudioAvailable");
            method.put("userId", userId);
            method.put("available", available);
            returnMap.put("method", method);
            eventSink.success(returnMap);
        }
    }

    @Override
    public void onUserSubStreamAvailable(String userId, boolean available) {
        Log.i(TAG, "onUserSubStreamAvailable: userId = " + userId + " available = " + available);
        EventChannel.EventSink eventSink = mWefListener.get();
        if (eventSink != null) {
            HashMap<String, Object> returnMap = new HashMap<>();
            HashMap<String, Object> method = new HashMap<>();
            method.put("name", "onUserSubStreamAvailable");
            method.put("userId", userId);
            method.put("available", available);
            returnMap.put("method", method);
            eventSink.success(returnMap);
        }
    }

    @Override
    public void onConnectionLost() {
        Log.i(TAG, "onConnectionLost");
        EventChannel.EventSink eventSink = mWefListener.get();
        if (eventSink != null) {
            HashMap<String, Object> returnMap = new HashMap<>();
            HashMap<String, Object> method = new HashMap<>();
            method.put("name", "onConnectionLost");
            returnMap.put("method", method);
            eventSink.success(returnMap);
        }
    }

    @Override
    public void onTryToReconnect() {
        Log.i(TAG, "onTryToReconnect");
        EventChannel.EventSink eventSink = mWefListener.get();
        if (eventSink != null) {
            HashMap<String, Object> returnMap = new HashMap<>();
            HashMap<String, Object> method = new HashMap<>();
            method.put("name", "onTryToReconnect");
            returnMap.put("method", method);
            eventSink.success(returnMap);
        }
    }

    @Override
    public void onConnectionRecovery() {
        Log.i(TAG, "onConnectionRecovery");
        EventChannel.EventSink eventSink = mWefListener.get();
        if (eventSink != null) {
            HashMap<String, Object> returnMap = new HashMap<>();
            HashMap<String, Object> method = new HashMap<>();
            method.put("name", "onConnectionRecovery");
            returnMap.put("method", method);
            eventSink.success(returnMap);
        }
    }

    @Override
    public void onSpeedTest(TRTCCloudDef.TRTCSpeedTestResult trtcSpeedTestResult, int finishedCount, int totalCount) {
        Log.i(TAG, "onSpeedTest");
        EventChannel.EventSink eventSink = mWefListener.get();
        if (eventSink != null) {
            HashMap<String, Object> returnMap = new HashMap<>();
            HashMap<String, Object> method = new HashMap<>();
            method.put("name", "onSpeedTest");
            HashMap<String, Object> speedRes = new HashMap<>();
            speedRes.put("ip",trtcSpeedTestResult.ip);
            speedRes.put("quality",trtcSpeedTestResult.quality);
            speedRes.put("upLostRate",trtcSpeedTestResult.ip);
            speedRes.put("downLostRate",trtcSpeedTestResult.downLostRate);
            speedRes.put("rtt",trtcSpeedTestResult.rtt);
            method.put("currentResult",speedRes);
            method.put("finishedCount",finishedCount);
            method.put("totalCount",totalCount);
            returnMap.put("method", method);
            eventSink.success(returnMap);
        }
    }

    @Override
    public void onFirstVideoFrame(String userId, int streamType, int width, int height) {
        Log.i(TAG, "onFirstVideoFrame");
        EventChannel.EventSink eventSink = mWefListener.get();
        if (eventSink != null) {
            HashMap<String, Object> returnMap = new HashMap<>();
            HashMap<String, Object> method = new HashMap<>();
            method.put("name", "onFirstVideoFrame");
            method.put("userId", userId);
            method.put("streamType", streamType);
            method.put("width", width);
            method.put("height", height);
            returnMap.put("method", method);
            eventSink.success(returnMap);
        }
    }

    @Override
    public void onFirstAudioFrame(String userId) {
        Log.i(TAG, "onFirstAudioFrame");
        EventChannel.EventSink eventSink = mWefListener.get();
        if (eventSink != null) {
            HashMap<String, Object> returnMap = new HashMap<>();
            HashMap<String, Object> method = new HashMap<>();
            method.put("name", "onFirstAudioFrame");
            method.put("userId", userId);
            returnMap.put("method", method);
            eventSink.success(returnMap);
        }
    }

    @Override
    public void onNetworkQuality(TRTCCloudDef.TRTCQuality trtcQuality, ArrayList<TRTCCloudDef.TRTCQuality> arrayList) {
        Log.i(TAG, "onNetworkQuality");
        EventChannel.EventSink eventSink = mWefListener.get();
        if (eventSink != null) {
            HashMap<String, Object> localQuality = new HashMap<>();
            localQuality.put("userId", trtcQuality.userId);
            localQuality.put("quality", trtcQuality.quality);

            ArrayList<HashMap<String, Object>> remoteQuality = new ArrayList<>();
            for (TRTCCloudDef.TRTCQuality quality : arrayList) {
                HashMap<String, Object> otherQuality = new HashMap<>();
                otherQuality.put("userId", quality.userId);
                otherQuality.put("quality", quality.quality);
                remoteQuality.add(otherQuality);
            }

            HashMap<String, Object> returnMap = new HashMap<>();
            HashMap<String, Object> method = new HashMap<>();
            method.put("name", "onNetworkQuality");
            method.put("localQuality", localQuality);
            method.put("remoteQuality", remoteQuality);

            returnMap.put("method", method);
            eventSink.success(returnMap);
        }
    }
}
