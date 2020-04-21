package com.jvtd.flutter_trtc_plugin;

import android.content.res.AssetManager;
import android.os.Bundle;
import android.util.Base64;
import android.view.Surface;

import com.tencent.rtmp.ITXVodPlayListener;
import com.tencent.rtmp.TXLiveConstants;
import com.tencent.rtmp.TXPlayerAuthBuilder;
import com.tencent.rtmp.TXVodPlayConfig;
import com.tencent.rtmp.TXVodPlayer;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.view.TextureRegistry;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * 作者:chenlei
 * 时间:2020/4/21 11:31 AM
 */
public class TencentPlayer implements ITXVodPlayListener {
    private TXVodPlayer mVodPlayer;
    TXVodPlayConfig mPlayConfig;
    private Surface surface;
    TXPlayerAuthBuilder authBuilder;

    private final TextureRegistry.SurfaceTextureEntry textureEntry;

    private TencentQueuingEventSink eventSink = new TencentQueuingEventSink();

    private final EventChannel eventChannel;

    private final Registrar mRegistrar;



    TencentPlayer(
            Registrar mRegistrar,
            EventChannel eventChannel,
            TextureRegistry.SurfaceTextureEntry textureEntry,
            MethodCall call,
            Result result) {
        this.eventChannel = eventChannel;
        this.textureEntry = textureEntry;
        this.mRegistrar = mRegistrar;


        mVodPlayer = new TXVodPlayer(mRegistrar.context());

        setPlayConfig(call);

        setTencentPlayer(call);

        setFlutterBridge(eventChannel, textureEntry, result);

        setPlaySource(call);
    }


    private void setPlayConfig(MethodCall call) {
        mPlayConfig = new TXVodPlayConfig();
        if (call.argument("cachePath") != null) {
            mPlayConfig.setCacheFolderPath(call.argument("cachePath").toString());//        mPlayConfig.setCacheFolderPath(Environment.getExternalStorageDirectory().getPath() + "/nellcache");
            mPlayConfig.setMaxCacheItems(1);
        } else {
            mPlayConfig.setCacheFolderPath(null);
            mPlayConfig.setMaxCacheItems(0);
        }
        if (call.argument("headers") != null) {
            mPlayConfig.setHeaders((Map<String, String>) call.argument("headers"));
        }

        mPlayConfig.setProgressInterval(((Number) call.argument("progressInterval")).intValue());
        mVodPlayer.setConfig(this.mPlayConfig);
    }

    private  void setTencentPlayer(MethodCall call) {
        mVodPlayer.setVodListener(this);
//            mVodPlayer.enableHardwareDecode(true);
        mVodPlayer.setLoop((boolean) call.argument("loop"));
        if (call.argument("startTime") != null) {
            mVodPlayer.setStartTime(((Number)call.argument("startTime")).floatValue());
        }
        mVodPlayer.setAutoPlay((boolean) call.argument("autoPlay"));

    }

    private void setFlutterBridge(EventChannel eventChannel, TextureRegistry.SurfaceTextureEntry textureEntry, Result result) {
        // 注册android向flutter发事件
        eventChannel.setStreamHandler(
                new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object o, EventChannel.EventSink sink) {
                        eventSink.setDelegate(sink);
                    }

                    @Override
                    public void onCancel(Object o) {
                        eventSink.setDelegate(null);
                    }
                }
        );

        surface = new Surface(textureEntry.surfaceTexture());
        mVodPlayer.setSurface(surface);


        Map<String, Object> reply = new HashMap<>();
        reply.put("textureId", textureEntry.id());
        result.success(reply);
    }

    private void setPlaySource(MethodCall call) {
        // network FileId播放
        if (call.argument("auth") != null) {
            authBuilder = new TXPlayerAuthBuilder();
            Map authMap = (Map<String, Object>)call.argument("auth");
            authBuilder.setAppId(((Number)authMap.get("appId")).intValue());
            authBuilder.setFileId(authMap.get("fileId").toString());
            mVodPlayer.startPlay(authBuilder);
        } else {
            // asset播放
            if (call.argument("asset") != null) {
                String assetLookupKey = mRegistrar.lookupKeyForAsset(call.argument("asset").toString());
                AssetManager assetManager = mRegistrar.context().getAssets();
                try {
                    InputStream inputStream = assetManager.open(assetLookupKey);
                    String cacheDir = mRegistrar.context().getCacheDir().getAbsoluteFile().getPath();
                    String fileName = Base64.encodeToString(assetLookupKey.getBytes(), Base64.DEFAULT);
                    File file = new File(cacheDir, fileName + ".mp4");
                    FileOutputStream fileOutputStream = new FileOutputStream(file);
                    if(!file.exists()){
                        file.createNewFile();
                    }
                    int ch = 0;
                    while((ch=inputStream.read()) != -1) {
                        fileOutputStream.write(ch);
                    }
                    inputStream.close();
                    fileOutputStream.close();

                    mVodPlayer.startPlay(file.getPath());
                } catch (IOException e) {
                    e.printStackTrace();
                }
            } else {
                // file、 network播放
                mVodPlayer.startPlay(call.argument("uri").toString());
            }
        }
    }

    // 播放器监听1
    @Override
    public void onPlayEvent(TXVodPlayer player, int event, Bundle param) {
        switch (event) {
            //准备阶段
            case TXLiveConstants.PLAY_EVT_VOD_PLAY_PREPARED:
                Map<String, Object> preparedMap = new HashMap<>();
                preparedMap.put("event", "initialized");
                preparedMap.put("duration", (int) player.getDuration());
                preparedMap.put("width", player.getWidth());
                preparedMap.put("height", player.getHeight());
                eventSink.success(preparedMap);
                break;
            case TXLiveConstants.PLAY_EVT_PLAY_PROGRESS:
                Map<String, Object> progressMap = new HashMap<>();
                progressMap.put("event", "progress");
                progressMap.put("progress", param.getInt(TXLiveConstants.EVT_PLAY_PROGRESS_MS));
                progressMap.put("duration", param.getInt(TXLiveConstants.EVT_PLAY_DURATION_MS));
                progressMap.put("playable", param.getInt(TXLiveConstants.EVT_PLAYABLE_DURATION_MS));
                eventSink.success(progressMap);
                break;
            case TXLiveConstants.PLAY_EVT_PLAY_LOADING:
                Map<String, Object> loadingMap = new HashMap<>();
                loadingMap.put("event", "loading");
                eventSink.success(loadingMap);
                break;
            case TXLiveConstants.PLAY_EVT_VOD_LOADING_END:
                Map<String, Object> loadingendMap = new HashMap<>();
                loadingendMap.put("event", "loadingend");
                eventSink.success(loadingendMap);
                break;
            case TXLiveConstants.PLAY_EVT_PLAY_END:
                Map<String, Object> playendMap = new HashMap<>();
                playendMap.put("event", "playend");
                eventSink.success(playendMap);
                break;
            case TXLiveConstants.PLAY_ERR_NET_DISCONNECT:
                Map<String, Object> disconnectMap = new HashMap<>();
                disconnectMap.put("event", "disconnect");
                if (mVodPlayer != null) {
                    mVodPlayer.setVodListener(null);
                    mVodPlayer.stopPlay(true);
                }
                eventSink.success(disconnectMap);
                break;
        }
        if (event < 0) {
            Map<String, Object> errorMap = new HashMap<>();
            errorMap.put("event", "error");
            errorMap.put("errorInfo", param.getString(TXLiveConstants.EVT_DESCRIPTION));
            eventSink.success(errorMap);
        }
    }

    // 播放器监听2
    @Override
    public void onNetStatus(TXVodPlayer txVodPlayer, Bundle param) {
        Map<String, Object> netStatusMap = new HashMap<>();
        netStatusMap.put("event", "netStatus");
        netStatusMap.put("netSpeed", param.getInt(TXLiveConstants.NET_STATUS_NET_SPEED));
        netStatusMap.put("cacheSize", param.getInt(TXLiveConstants.NET_STATUS_V_SUM_CACHE_SIZE));
        eventSink.success(netStatusMap);
    }

    void play() {
        if (!mVodPlayer.isPlaying()) {
            mVodPlayer.resume();
        }
    }

    void pause() {
        mVodPlayer.pause();
    }

    void seekTo(int location) {
        mVodPlayer.seek(location);
    }

    void setRate(float rate) {
        mVodPlayer.setRate(rate);
    }

    void setBitrateIndex(int index) {
        mVodPlayer.setBitrateIndex(index);
    }

    void dispose() {
        if (mVodPlayer != null) {
            mVodPlayer.setVodListener(null);
            mVodPlayer.stopPlay(true);
        }
        textureEntry.release();
        eventChannel.setStreamHandler(null);
        if (surface != null) {
            surface.release();
        }
    }
}
