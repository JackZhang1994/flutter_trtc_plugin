package com.jvtd.flutter_trtc_plugin;

import android.os.Bundle;
import android.util.Log;

import com.tencent.trtc.TRTCCloudListener;

import java.lang.ref.WeakReference;
import java.util.HashMap;

import io.flutter.plugin.common.EventChannel;

/**
 * SDK 回调实现类，这里对TRTCCloudListener做了一个封装
 */
public class TrtcCloudListenerImpl extends TRTCCloudListener
{
  private static final String TAG = TrtcCloudListenerImpl.class.getName();

  private WeakReference<EventChannel.EventSink> mWefListener;

  public TrtcCloudListenerImpl(EventChannel.EventSink eventSink)
  {
    super();
    mWefListener = new WeakReference<>(eventSink);
  }

  @Override
  public void onError(int errCode, String errMsg, Bundle extraInfo)
  {
    Log.i(TAG, "onError: errCode = " + errCode + " errMsg = " + errMsg);
    EventChannel.EventSink eventSink = mWefListener.get();
    if (eventSink != null)
    {
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
  public void onWarning(int warningCode, String warningMsg, Bundle extraInfo)
  {
    Log.i(TAG, "onWarning: warningCode = " + warningCode + " warningMsg = " + warningMsg);
    EventChannel.EventSink eventSink = mWefListener.get();
    if (eventSink != null)
    {
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
  public void onEnterRoom(long elapsed)
  {
    Log.i(TAG, "onEnterRoom: elapsed = " + elapsed);
    final EventChannel.EventSink eventSink = mWefListener.get();
    if (eventSink != null)
    {
      HashMap<String, Object> returnMap = new HashMap<>();
      HashMap<String, Object> method = new HashMap<>();
      method.put("name", "onEnterRoom");
      method.put("result", elapsed);
      returnMap.put("method", method);
      eventSink.success(returnMap);
    }
  }

  @Override
  public void onExitRoom(int reason)
  {
    Log.i(TAG, "onExitRoom: reason = " + reason);
    final EventChannel.EventSink eventSink = mWefListener.get();
    if (eventSink != null)
    {
      HashMap<String, Object> returnMap = new HashMap<>();
      HashMap<String, Object> method = new HashMap<>();
      method.put("name", "onExitRoom");
      method.put("reason", reason);
      returnMap.put("method", method);
      eventSink.success(returnMap);
    }
  }


  @Override
  public void onRemoteUserEnterRoom(String userId)
  {
    Log.i(TAG, "onRemoteUserEnterRoom: userId = " + userId);
    EventChannel.EventSink eventSink = mWefListener.get();
    if (eventSink != null)
    {
      HashMap<String, Object> returnMap = new HashMap<>();
      HashMap<String, Object> method = new HashMap<>();
      method.put("name", "onRemoteUserEnterRoom");
      method.put("userId", userId);
      returnMap.put("method", method);
      eventSink.success(returnMap);
    }
  }

  @Override
  public void onRemoteUserLeaveRoom(String userId, int reason)
  {
    Log.i(TAG, "onRemoteUserLeaveRoom: userId = " + userId + " reason = " + reason);
    EventChannel.EventSink eventSink = mWefListener.get();
    if (eventSink != null)
    {
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
  public void onUserVideoAvailable(final String userId, boolean available)
  {
    Log.i(TAG, "onUserVideoAvailable: userId = " + userId + " available = " + available);
    EventChannel.EventSink eventSink = mWefListener.get();
    if (eventSink != null)
    {
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
  public void onUserAudioAvailable(String userId, boolean available)
  {
    Log.i(TAG, "onUserAudioAvailable: userId = " + userId + " available = " + available);
    EventChannel.EventSink eventSink = mWefListener.get();
    if (eventSink != null)
    {
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
  public void onConnectionLost()
  {
    Log.i(TAG, "onConnectionLost");
    EventChannel.EventSink eventSink = mWefListener.get();
    if (eventSink != null)
    {
      HashMap<String, Object> returnMap = new HashMap<>();
      HashMap<String, Object> method = new HashMap<>();
      method.put("name", "onConnectionLost");
      returnMap.put("method", method);
      eventSink.success(returnMap);
    }
  }

  @Override
  public void onTryToReconnect()
  {
    Log.i(TAG, "onTryToReconnect");
    EventChannel.EventSink eventSink = mWefListener.get();
    if (eventSink != null)
    {
      HashMap<String, Object> returnMap = new HashMap<>();
      HashMap<String, Object> method = new HashMap<>();
      method.put("name", "onTryToReconnect");
      returnMap.put("method", method);
      eventSink.success(returnMap);
    }
  }

  @Override
  public void onConnectionRecovery()
  {
    Log.i(TAG, "onConnectionRecovery");
    EventChannel.EventSink eventSink = mWefListener.get();
    if (eventSink != null)
    {
      HashMap<String, Object> returnMap = new HashMap<>();
      HashMap<String, Object> method = new HashMap<>();
      method.put("name", "onConnectionRecovery");
      returnMap.put("method", method);
      eventSink.success(returnMap);
    }
  }

  @Override
  public void onFirstVideoFrame(String userId, int streamType, int width, int height)
  {
    Log.i(TAG, "onFirstVideoFrame");
    EventChannel.EventSink eventSink = mWefListener.get();
    if (eventSink != null)
    {
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
  public void onFirstAudioFrame(String userId)
  {
    Log.i(TAG, "onFirstAudioFrame");
    EventChannel.EventSink eventSink = mWefListener.get();
    if (eventSink != null)
    {
      HashMap<String, Object> returnMap = new HashMap<>();
      HashMap<String, Object> method = new HashMap<>();
      method.put("name", "onFirstAudioFrame");
      method.put("userId", userId);
      returnMap.put("method", method);
      eventSink.success(returnMap);
    }
  }
}
