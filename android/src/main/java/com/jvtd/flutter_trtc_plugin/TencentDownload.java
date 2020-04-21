package com.jvtd.flutter_trtc_plugin;

import com.tencent.rtmp.TXPlayerAuthBuilder;
import com.tencent.rtmp.downloader.ITXVodDownloadListener;
import com.tencent.rtmp.downloader.TXVodDownloadDataSource;
import com.tencent.rtmp.downloader.TXVodDownloadManager;
import com.tencent.rtmp.downloader.TXVodDownloadMediaInfo;

import java.util.HashMap;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * 作者:chenlei
 * 时间:2020/4/21 11:55 AM
 */
public class TencentDownload implements ITXVodDownloadListener {
    private TencentQueuingEventSink eventSink = new TencentQueuingEventSink();

    private final EventChannel eventChannel;

    private final Registrar mRegistrar;

    private String fileId;

    private TXVodDownloadManager downloader;

    private TXVodDownloadMediaInfo txVodDownloadMediaInfo;


    void stopDownload() {
        if (downloader != null && txVodDownloadMediaInfo != null) {
            downloader.stopDownload(txVodDownloadMediaInfo);
        }
    }


    TencentDownload(
            Registrar mRegistrar,
            EventChannel eventChannel,
            MethodCall call,
            Result result) {
        this.eventChannel = eventChannel;
        this.mRegistrar = mRegistrar;


        downloader = TXVodDownloadManager.getInstance();
        downloader.setListener(this);
        downloader.setDownloadPath(call.argument("savePath").toString());
        String urlOrFileId = call.argument("urlOrFileId").toString();

        if (urlOrFileId.startsWith("http")) {
            txVodDownloadMediaInfo = downloader.startDownloadUrl(urlOrFileId);
        } else {
            TXPlayerAuthBuilder auth = new TXPlayerAuthBuilder();
            auth.setAppId(((Number) call.argument("appId")).intValue());
            auth.setFileId(urlOrFileId);
            int quanlity = ((Number) call.argument("quanlity")).intValue();
            String templateName = "HLS-标清-SD";
            if (quanlity == 2) {
                templateName = "HLS-标清-SD";
            } else if (quanlity == 3) {
                templateName = "HLS-高清-HD";
            } else if (quanlity == 4) {
                templateName = "HLS-全高清-FHD";
            }
            TXVodDownloadDataSource source = new TXVodDownloadDataSource(auth, templateName);
            txVodDownloadMediaInfo = downloader.startDownload(source);
        }

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
        result.success(null);
    }

    @Override
    public void onDownloadStart(TXVodDownloadMediaInfo txVodDownloadMediaInfo) {
        dealCallToFlutterData("start", txVodDownloadMediaInfo);

    }

    @Override
    public void onDownloadProgress(TXVodDownloadMediaInfo txVodDownloadMediaInfo) {
        dealCallToFlutterData("progress", txVodDownloadMediaInfo);

    }

    @Override
    public void onDownloadStop(TXVodDownloadMediaInfo txVodDownloadMediaInfo) {
        dealCallToFlutterData("stop", txVodDownloadMediaInfo);
    }

    @Override
    public void onDownloadFinish(TXVodDownloadMediaInfo txVodDownloadMediaInfo) {
        dealCallToFlutterData("complete", txVodDownloadMediaInfo);
    }

    @Override
    public void onDownloadError(TXVodDownloadMediaInfo txVodDownloadMediaInfo, int i, String s) {
        HashMap<String, Object> targetMap = TencentDownloadUtil.convertToMap(txVodDownloadMediaInfo);
        targetMap.put("downloadStatus", "error");
        targetMap.put("error", "code:" + i + "  msg:" + s);
        if (txVodDownloadMediaInfo.getDataSource() != null) {
            targetMap.put("quanlity", txVodDownloadMediaInfo.getDataSource().getQuality());
            targetMap.putAll(TencentDownloadUtil.convertToMap(txVodDownloadMediaInfo.getDataSource().getAuthBuilder()));
        }
        eventSink.success(targetMap);
    }

    @Override
    public int hlsKeyVerify(TXVodDownloadMediaInfo txVodDownloadMediaInfo, String s, byte[] bytes) {
        return 0;
    }

    private void dealCallToFlutterData(String type, TXVodDownloadMediaInfo txVodDownloadMediaInfo) {
        HashMap<String, Object> targetMap = TencentDownloadUtil.convertToMap(txVodDownloadMediaInfo);
        targetMap.put("downloadStatus", type);
        if (txVodDownloadMediaInfo.getDataSource() != null) {
            targetMap.put("quanlity", txVodDownloadMediaInfo.getDataSource().getQuality());
            targetMap.putAll(TencentDownloadUtil.convertToMap(txVodDownloadMediaInfo.getDataSource().getAuthBuilder()));
        }
        eventSink.success(targetMap);
    }
}
