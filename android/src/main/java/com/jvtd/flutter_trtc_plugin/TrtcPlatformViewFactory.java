package com.jvtd.flutter_trtc_plugin;

import android.content.Context;
import android.util.SparseArray;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;


public class TrtcPlatformViewFactory extends PlatformViewFactory
{

  private static TrtcPlatformViewFactory sInstance;

  private static EventChannel.EventSink mEvents;

  private SparseArray<TrtcPlatformView> mViews;

  public static TrtcPlatformViewFactory shareInstance()
  {
    if (sInstance == null)
    {
      sInstance = new TrtcPlatformViewFactory(StandardMessageCodec.INSTANCE);
    }
    return sInstance;
  }

  public void setEventSink(EventChannel.EventSink events)
  {
    if (mEvents == null)
    {
      mEvents = events;
    }
  }

  private TrtcPlatformViewFactory(MessageCodec<Object> createArgsCodec)
  {
    super(createArgsCodec);
    mViews = new SparseArray<>();
  }

  public void addView(int viewID, TrtcPlatformView view)
  {
    mViews.put(viewID, view);
  }

  public boolean removeView(int viewID)
  {
    if (mViews.get(viewID) == null)
    {
      return false;
    }
    mViews.remove(viewID);
    return true;
  }

  public TrtcPlatformView getPlatformView(int viewID)
  {
    return mViews.get(viewID);
  }

  @Override
  public PlatformView create(Context context, int viewID, Object args)
  {
    TrtcPlatformView view = new TrtcPlatformView(context, viewID, mEvents);
    addView(viewID, view);
    return view;
  }
}
