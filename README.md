# 腾讯云音视频Flutter插件文档



## 基础部分



### 初始化SDK

| sharedInstance |      |      |
| -------------- | ---- | ---- |
|                |      |      |



### 销毁SDK

| destroySharedInstance |      |      |
| --------------------- | ---- | ---- |
|                       |      |      |



### 本地获取UserSig

| getUserSig       |          |      |
| ---------------- | -------- | ---- |
| int sdkAppId     |          |      |
| String secretKey |          |      |
| String userId    | 用户标识 |      |



## 房间部分



### 进入房间

| enterRoom      |          |                                                 |
| -------------- | -------- | :---------------------------------------------- |
| int sdkAppId   | 应用标识 |                                                 |
| String userId  | 用户标识 |                                                 |
| String userSig | 用户签名 |                                                 |
| int roomId     | 房间号码 |                                                 |
| int scene      | 应用场景 | 0-视频通话 1-在线直播、2-语音通话、3-语音聊天室 |
| int role       | 角色     | 20-主播 21-观众                                 |



### 离开房间

| exitRoom |      |      |
| -------- | ---- | ---- |
|          |      |      |



### 设置音视频数据接收模式，需要在进房前设置才能生效。

| setDefaultStreamRecvMode |                  |              |
| ------------------------ | ---------------- | ------------ |
| bool isReceivedAudio     | 自动接收音频数据 | 默认值：true |
| bool isReceivedVideo     | 自动接收视频数据 | 默认值：true |



## 视频部分



### 创建PlatformView

| createPlatformView                 |                              |      |
| ---------------------------------- | ---------------------------- | ---- |
| String userId                      | 用户ID                       |      |
| Function(int viewId) onViewCreated | 视图创建成功回调，返回视图ID |      |



### 销毁PlatformView

| destroyPlatformView |        |      |
| ------------------- | ------ | ---- |
| Int viewId          | 视图ID |      |



### 开启本地视频的预览画面

| startLocalPreview |                  |              |
| ----------------- | ---------------- | ------------ |
| bool frontCamera  | 是否为前置摄像头 | 默认值：true |
| int viewId        | 视图ID           |              |



### 停止本地视频采集及预览

| stopLocalPreview |      |      |
| ---------------- | ---- | ---- |
|                  |      |      |



### 开始显示远端视频画面

| startRemoteView |                |      |
| --------------- | -------------- | ---- |
| String userId   | 对方的用户标识 |      |
| int viewId      | 视图ID         |      |



###停止显示远端视频画面，同时不再拉取该远端用户的视频数据流 

| stopRemoteView |                |      |
| -------------- | -------------- | ---- |
| String userId  | 对方的用户标识 |      |



### 停止显示所有远端视频画面，同时不再拉取远端用户的视频数据流

| stopAllRemoteView |      |      |
| ----------------- | ---- | ---- |
|                   |      |      |



### 是否停止推送本地的视频数据

| muteLocalVideo |      |               |
| -------------- | ---- | ------------- |
| bool mote      | 屏蔽 | 默认值：false |



### 设置本地图像的渲染模式

| setLocalViewFillMode |                |                                                   |
| -------------------- | -------------- | ------------------------------------------------- |
| int mode             | 填充或适应模式 | 默认值：填充（FILL）。<br />FILL：填充；FIT：适应 |



### 设置远端图像的渲染模式

| setRemoteViewFillMode |            |                                                   |
| --------------------- | ---------- | ------------------------------------------------- |
| String userId         | 用户ID     |                                                   |
| int mode              | 填充或适应 | 默认值：填充（FILL）。<br />FILL：填充；FIT：适应 |



### 设置视频编码器相关参数

| setVideoEncoderParam    |                    |              |
| ----------------------- | ------------------ | ------------ |
| int videoResolution     | 视频分辨率         |              |
| int videoResolutionMode | 分辨率模式         | Portrait     |
| int videoFps            | 视频采集帧率       | 15fps或20fps |
| int videoBitrate        | 视频上行码率       |              |
| bool enableAdjustRes    | 是否允许调整分辨率 | true         |



### 设置网络流控相关参数

| setNetworkQosParam |                                     |      |
| ------------------ | ----------------------------------- | ---- |
| int preference     | 弱网下选择“保清晰”或“保流畅”        |      |
| int controlMode    | 视频分辨率（云端控制 - 客户端控制） |      |



### 设置本地摄像头预览画面的镜像模式

| setLocalViewMirror |          |                               |
| ------------------ | -------- | ----------------------------- |
| int mirrorType     | 镜像模式 | AUTO<br />ENABLE<br />DISABLE |



### 设置编码器输出的画面镜像模式

| setVideoEncoderMirror |          |                                          |
| --------------------- | -------- | ---------------------------------------- |
| bool mirror           | 是否镜像 | true：镜像；false：不镜像；默认值：false |



## 音频部分



### 开启本地音频的采集和上行

| startLocalAudio |      |      |
| --------------- | ---- | ---- |
|                 |      |      |



### 关闭本地音频的采集和上行

| stopLocalAudio |      |      |
| -------------- | ---- | ---- |
|                |      |      |



### 静音本地的音频

| muteLocalAudio |          |               |
| -------------- | -------- | ------------- |
| bool mute      | 静音状态 | 默认值：false |



### 设置音频路由

| setAudioRoute |          |                                                     |
| ------------- | -------- | --------------------------------------------------- |
| int route     | 音频路由 | 默认值：扬声器<br />SPEAKER：扬声器；EARPIECE：听筒 |



### 静音某一个用户的声音，同时不再拉取该远端用户的音频数据流

| muteRemoteAudio |               |                           |
| --------------- | ------------- | ------------------------- |
| String userId   | 对方的用户 ID |                           |
| bool mute       | 静音状态      | true：静音；false：非静音 |



### 静音所有用户的声音，同时不再拉取远端用户的音频数据流

| muteAllRemoteAudio |          |                           |
| ------------------ | -------- | ------------------------- |
| bool mute          | 静音状态 | true：静音；false：非静音 |



### 开始录音

| startAudioRecording |              |      |
| ------------------- | ------------ | ---- |
| String path         | 文件完整路径 |      |



### 结束录音

| stopAudioRecording |      |      |
| ------------------ | ---- | ---- |
|                    |      |      |



## 摄像头相关



### 切换摄像头

| switchCamera |      |      |
| ------------ | ---- | ---- |
|              |      |      |



## 辅流相关



### 开始显示远端用户的屏幕分享画面

| startRemoteSubStreamView |                |      |
| ------------------------ | -------------- | ---- |
| String userId            | 对方的用户标识 |      |
| int viewId               | 视图ID         |      |



###停止显示远端用户的屏幕分享画面

| stopRemoteSubStreamView |                |      |
| ----------------------- | -------------- | ---- |
| String userId           | 对方的用户标识 |      |



### 设置屏幕分享画面的显示模式

| setRemoteSubStreamViewFillMode |              |                                                   |
| ------------------------------ | ------------ | ------------------------------------------------- |
| String userId                  | 对方的用户ID |                                                   |
| int mode                       | 填充或适应   | 默认值：填充（FILL）。<br />FILL：填充；FIT：适应 |



###设置屏幕分享画面的顺时针旋转角度

| setRemoteSubStreamViewRotation |                |                |
| ------------------------------ | -------------- | -------------- |
| String userId                  | 对方的用户ID   |                |
| int rotation                   | 顺时针旋转角度 | 默认值：不旋转 |

### 

## 监听回调相关



### 注册回调

| registerCallback                                             |                                                |                                                              |
| ------------------------------------------------------------ | ---------------------------------------------- | ------------------------------------------------------------ |
| Function(int errCode, String errMsg) onError                 | 错误回调                                       | SDK 不可恢复的错误，一定要监听，并分情况给用户适当的界面提示。 |
| Function(int warningCode, String warningMsg) onWarning       | 警告回调                                       | 用于告知您一些非严重性问题，例如出现卡顿或者可恢复的解码失败。 |
| Function(int result) onEnterRoom                             | 已加入房间的回调                               | result > 0 时为进房耗时（ms），result < 0 时为进房错误码。   |
| Function(int reason) onExitRoom                              | 离开房间的事件回调                             | 离开房间原因，0：主动调用 exitRoom 退房；1：被服务器踢出当前房间；2：当前房间整个被解散。 |
| Function(String userId) onRemoteUserEnterRoom                | 有用户加入当前房间                             | 任何用户进入房间都会触发该通知<br />userId：用户标识         |
| Function(String userId, int reason) onRemoteUserLeaveRoom    | 有用户离开当前房间                             | 任何用户的离开都会触发该通知<br />userId：用户标识<br />reason：离开原因，0表示用户主动退出房间，1表示用户超时退出，2表示被踢出房间。 |
| Function(String userId, bool available) onUserVideoAvailable | 用户是否开启摄像头视频                         | userId：用户标识<br />available：画面是否开启                |
| Function(String userId, bool available) onUserAudioAvailable | 用户是否开启音频上行                           | userId：用户标识<br />available：声音是否开启                |
| Function(String userId, bool available) onUserSubStreamAvailable | 用户是否开启屏幕分享                           | userId：用户标识<br />available：屏幕分享是否开启            |
| Function(String userId, int streamType, int width, int height) onFirstVideoFrame | 开始渲染本地或远程用户的首帧画面               | [userId] 本地或远程用户 ID，如果 userId == null 代表本地，userId != null 代表远程 <br />[streamType] 视频流类型：摄像头或屏幕分享 <br />[width] 画面宽度 <br />[height] 画面高度 |
| Function(String userId) onFirstAudioFrame                    | 开始播放远程用户的首帧音频（本地声音暂不通知） | [userId] 远程用户 ID                                         |
| Function() onConnectionLost                                  | SDK 跟服务器的连接断开                         |                                                              |
| Function() onTryToReconnect                                  | SDK 尝试重新连接到服务器                       |                                                              |
| Function() onConnectionRecovery                              | SDK 跟服务器的连接恢复                         |                                                              |



### 取消注册回调

| unregisterCallback |      |      |
| ------------------ | ---- | ---- |
|                    |      |      |

