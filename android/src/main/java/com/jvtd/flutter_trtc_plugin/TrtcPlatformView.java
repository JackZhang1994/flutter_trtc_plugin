package com.jvtd.flutter_trtc_plugin;

import android.content.Context;
import android.view.View;

import com.tencent.rtmp.ui.TXCloudVideoView;

import io.flutter.plugin.platform.PlatformView;

public class TrtcPlatformView implements PlatformView
{
  private TXCloudVideoView mTXCloudVideoView;

  public TrtcPlatformView(Context context, int viewId)
  {
    this.mTXCloudVideoView = new TXCloudVideoView(context);
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
