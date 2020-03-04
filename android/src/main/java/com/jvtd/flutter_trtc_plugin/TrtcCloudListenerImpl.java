package com.jvtd.flutter_trtc_plugin;

import android.os.Bundle;
import android.util.Log;

import com.tencent.trtc.TRTCCloudListener;

import java.lang.ref.WeakReference;

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
      // TODO
//      eventSink.onError(errCode, errMsg, extraInfo);
    }
  }

  @Override
  public void onWarning(int warningCode, String warningMsg, Bundle extraInfo)
  {
    Log.i(TAG, "onWarning: warningCode = " + warningCode + " warningMsg = " + warningMsg);
    EventChannel.EventSink eventSink = mWefListener.get();
    if (eventSink != null)
    {
//      listener.onWarning(warningCode, warningMsg, extraInfo);
    }
  }

  @Override
  public void onEnterRoom(long elapsed)
  {
    Log.i(TAG, "onEnterRoom: elapsed = " + elapsed);
    final EventChannel.EventSink eventSink = mWefListener.get();
    if (eventSink != null)
    {
//      listener.onEnterRoom(elapsed);
    }
  }

  @Override
  public void onExitRoom(int reason)
  {
    Log.i(TAG, "onExitRoom: reason = " + reason);
    final EventChannel.EventSink eventSink = mWefListener.get();
    if (eventSink != null)
    {
//      eventSink.onExitRoom(reason);
    }
  }


  @Override
  public void onRemoteUserEnterRoom(String userId)
  {
    Log.i(TAG, "onRemoteUserEnterRoom: userId = " + userId);
    EventChannel.EventSink eventSink = mWefListener.get();
    if (eventSink != null)
    {
//      eventSink.onRemoteUserEnterRoom(userId);
    }
  }

  @Override
  public void onRemoteUserLeaveRoom(String userId, int reason)
  {
    Log.i(TAG, "onRemoteUserLeaveRoom: userId = " + userId + " reason = " + reason);
    EventChannel.EventSink eventSink = mWefListener.get();
    if (eventSink != null)
    {
//      eventSink.onRemoteUserLeaveRoom(userId, reason);
    }
  }

  @Override
  public void onUserVideoAvailable(final String userId, boolean available)
  {
    Log.i(TAG, "onUserVideoAvailable: userId = " + userId + " available = " + available);
    EventChannel.EventSink eventSink = mWefListener.get();
    if (eventSink != null)
    {
//      eventSink.onUserVideoAvailable(userId, available);
    }
  }

  @Override
  public void onUserAudioAvailable(String userId, boolean available)
  {
    Log.i(TAG, "onUserAudioAvailable: userId = " + userId + " available = " + available);
    EventChannel.EventSink eventSink = mWefListener.get();
    if (eventSink != null)
    {
//      listener.onUserAudioAvailable(userId, available);
    }
  }

  @Override
  public void onConnectionLost()
  {
    Log.i(TAG, "onConnectionLost");
    EventChannel.EventSink eventSink = mWefListener.get();
    if (eventSink != null)
    {
//      eventSink.onConnectionLost();
    }
  }

  @Override
  public void onTryToReconnect()
  {
    Log.i(TAG, "onTryToReconnect");
    EventChannel.EventSink eventSink = mWefListener.get();
    if (eventSink != null)
    {
//      eventSink.onTryToReconnect();
    }
  }

  @Override
  public void onConnectionRecovery()
  {
    Log.i(TAG, "onConnectionRecovery");
    EventChannel.EventSink eventSink = mWefListener.get();
    if (eventSink != null)
    {
//      eventSink.onConnectionRecovery();
    }
  }
}
