package com.jvtd.flutter_trtc_plugin;

import android.content.Context;
import android.view.View;

import com.tencent.rtmp.ui.TXCloudVideoView;

import java.util.HashMap;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.platform.PlatformView;

public class TrtcPlatformView implements PlatformView
{
  private TXCloudVideoView mTXCloudVideoView;

  public TrtcPlatformView(Context context, final int viewId, final EventChannel.EventSink events)
  {
    this.mTXCloudVideoView = new TXCloudVideoView(context);
    mTXCloudVideoView.setOnClickListener(new View.OnClickListener()
    {
      @Override
      public void onClick(View v)
      {
        if (events != null)
        {
          HashMap<String, Object> returnMap = new HashMap<>();
          HashMap<String, Object> method = new HashMap<>();
          method.put("name", "onTrtcViewClick");
          method.put("viewId", viewId);
          returnMap.put("method", method);
          events.success(returnMap);
        }
      }
    });
  }

  @Override
  public View getView()
  {
    return mTXCloudVideoView;
  }

  @Override
  public void dispose()
  {
    if (mTXCloudVideoView != null)
    {
      mTXCloudVideoView = null;
    }
  }
}
