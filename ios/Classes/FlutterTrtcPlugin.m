#import "FlutterTrtcPlugin.h"
#import "TRTCPlatformViewFactory.h"
#import "TRTCCloud.h"
#import "TRTCCloudDef.h"
#import "TRTCCloudDelegate.h"
#import "TRTCCloudManager.h"
#import "TRTCVideoView.h"
#import "GenerateTestUserSig.h"
#import "FLTVideoPlayer.h"
#import "FLTFrameUpdater.h"
#import "FLTDownLoadManager.h"

static NSString * const PLUGIN_METHOD_NAME = @"flutter_trtc_plugin";/** 方法*/
static NSString * const PLUGIN_EVENT_NAME = @"flutter_trtc_plugin_callback";/** 事件*/
static NSString * const PLUGIN_VIEW_NAME = @"flutter_trtc_plugin/view";/** 视图*/

static NSString * const sharedInstance = @"sharedInstance";/** 初始化*/
static NSString * const destroySharedInstance = @"destroySharedInstance";/** 销毁单例*/
static NSString * const getUserSig = @"getUserSig";/** 获取签名*/
static NSString * const enterRoom = @"enterRoom";/** 进入房间*/
static NSString * const exitRoom = @"exitRoom";/** 退出房间*/
static NSString * const switchRole = @"switchRole";/** 角色切换*/
static NSString * const setDefaultStreamRecvMode = @"setDefaultStreamRecvMode";/** 设置音视频数据接收模式（需要在进房前设置才能生效）*/
static NSString * const destroyPlatformView = @"destroyPlatformView";/** 移除视图*/
static NSString * const startLocalPreview = @"startLocalPreview";/** 开启本地视频的预览画面*/
static NSString * const stopLocalPreview = @"stopLocalPreview";/** 停止本地视频采集及预览*/
static NSString * const startRemoteView = @"startRemoteView";/** 开始显示远端视频画面*/
static NSString * const stopRemoteView = @"stopRemoteView";/** 停止显示远端视频画面，同时不再拉取该远端用户的视频数据流*/
static NSString * const stopAllRemoteView = @"stopAllRemoteView";/** 停止显示所有远端视频画面，同时不再拉取远端用户的视频数据流*/
static NSString * const muteLocalVideo = @"muteLocalVideo";/** 静音本地的音频*/
static NSString * const setLocalViewFillMode = @"setLocalViewFillMode";/** 设置本地图像的渲染模式*/
static NSString * const setLocalViewRotation = @"setLocalViewRotation";/** 设置本地图像的顺时针旋转角度*/
static NSString * const setRemoteViewFillMode = @"setRemoteViewFillMode";/** 设置远端图像的渲染模式*/
static NSString * const setRemoteViewRotation = @"setRemoteViewRotation";/** 设置远端图像的顺时针旋转角度*/
static NSString * const startLocalAudio = @"startLocalAudio";/** 开启本地音频的采集和上行*/
static NSString * const stopLocalAudio = @"stopLocalAudio";/** 关闭本地音频的采集和上行*/
static NSString * const muteLocalAudio = @"muteLocalAudio";/** 静音本地的音频*/
static NSString * const setAudioRoute = @"setAudioRoute";/** 设置音频路由*/
static NSString * const muteRemoteAudio = @"muteRemoteAudio";/** 静音某一个用户的声音，同时不再拉取该远端用户的音频数据流*/
static NSString * const muteAllRemoteAudio = @"muteAllRemoteAudio";/** 静音所有用户的声音，同时不再拉取远端用户的音频数据流*/
static NSString * const switchCamera = @"switchCamera";/** 切换摄像头*/
static NSString * const setVideoEncoderParam = @"setVideoEncoderParam";/** 设置视频编码器相关参数*/
static NSString * const setNetworkQosParam = @"setNetworkQosParam";/** 设置网络流控相关参数*/
static NSString * const setLocalViewMirror = @"setLocalViewMirror";/** 设置本地摄像头预览画面的镜像模式*/
static NSString * const setVideoEncoderMirror = @"setVideoEncoderMirror";/** 设置编码器输出的画面镜像模式*/
static NSString * const startAudioRecording = @"startAudioRecording";/** 开始录音*/
static NSString * const stopAudioRecording = @"stopAudioRecording";/** 停止录音*/
static NSString * const startRemoteSubStreamView = @"startRemoteSubStreamView";/**  开始显示远端用户的屏幕分享画面*/
static NSString * const stopRemoteSubStreamView = @"stopRemoteSubStreamView";/**  停止显示远端用户的屏幕分享画面。*/
static NSString * const setRemoteSubStreamViewFillMode = @"setRemoteSubStreamViewFillMode";/**  设置屏幕分享画面的显示模式。*/
static NSString * const setRemoteSubStreamViewRotation = @"setRemoteSubStreamViewRotation";/**  设置屏幕分享画面的顺时针旋转角度。*/



@interface FlutterTrtcPlugin()<TRTCCloudDelegate,FlutterStreamHandler>
@property(nonatomic,strong) TRTCCloud *trtc;
@property(nonatomic,strong) FlutterMethodChannel* channel;
@property (nonatomic, strong) NSObject<FlutterPluginRegistrar> *registrar;
@property(nonatomic,strong) TRTCCloudManager* manager;

// 音频相关
@property(readonly, nonatomic) NSObject<FlutterTextureRegistry>* registry;
@property(readonly, nonatomic) NSObject<FlutterBinaryMessenger>* messenger;
//@property(readonly, nonatomic) NSMutableDictionary* players;
@property(readonly, nonatomic) NSMutableDictionary* downLoads;

@end

@implementation FlutterTrtcPlugin
{
    volatile FlutterEventSink _eventSink;
    FLTVideoPlayer* player ;
}
-(instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar{
    if(self =[super init]){
        _trtc = nil;
        _registrar = registrar;
        _registry = [registrar textures];
        _messenger = [registrar messenger];
        // _players = [NSMutableDictionary dictionaryWithCapacity:1];
        _downLoads = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    return  self;
}
-(void)dealloc{
    [TRTCPlatformViewFactory release];
    if(self.trtc)
        self.trtc = nil;
}

- (bool)numberToBoolValue:(NSNumber *)number {
    
    return [number isKindOfClass:[NSNull class]] ? false : [number boolValue];
}
- (int)numberToIntValue:(NSNumber *)number {
    
    return [number isKindOfClass:[NSNull class]] ? 0 : [number intValue];
}
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    
    FlutterTrtcPlugin* instance = [[FlutterTrtcPlugin alloc]initWithRegistrar:registrar];
    /*Create Method Channel.*/
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:PLUGIN_METHOD_NAME
                                     binaryMessenger:[registrar messenger]];
    
    [registrar addMethodCallDelegate:instance channel:channel];
    /*Create Event Channel.*/
    FlutterEventChannel * eventChannel = [FlutterEventChannel eventChannelWithName:PLUGIN_EVENT_NAME binaryMessenger:[registrar messenger]];
    [eventChannel setStreamHandler:instance];
    
    /*registrarView*/
    [registrar registerViewFactory:[TRTCPlatformViewFactory shareInstance] withId:PLUGIN_VIEW_NAME];
    
}

#pragma mark - flutter_trtc_plugin
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *args = call.arguments;
    if ([sharedInstance isEqualToString:call.method]) {
        [self initTrtcManager];
    }else if ([destroySharedInstance isEqualToString:call.method]) {
        [self destroySharedIntance];
    }else if ([getUserSig isEqualToString:call.method]) {
        NSString *  userId =args[@"userId"];
        int sdkAppId = [self numberToIntValue:args[@"sdkAppId"]];
        NSString * secretKey =args[@"secretKey"];
        result([GenerateTestUserSig genTestUserSig:sdkAppId secretKey:secretKey userId:userId]);
    }else if ([enterRoom isEqualToString:call.method]) {
        TRTCParams * params = [[TRTCParams alloc]init];
        params.roomId = [self numberToIntValue:args[@"roomId"]];
        params.sdkAppId = [self numberToIntValue:args[@"sdkAppId"]];
        params.userId = args[@"userId"];
        params.userSig = args[@"userSig"];
        params.role = [self numberToIntValue:args[@"role"]];
        NSString* streamId = args[@"streamId"];
        if(streamId != nil && streamId.length > 0){
            params.streamId = streamId;
        }
        int scene = [self numberToIntValue:args[@"scene"]];
        [self.trtc enterRoom:params appScene:scene];
        result(@(YES));
    }else if ([exitRoom isEqualToString:call.method]) {
        [self.trtc exitRoom];
        result(@(YES));
    }else if ([switchRole isEqualToString:call.method]) {
        int role = [self numberToIntValue:args[@"role"]];
        [self.trtc switchRole:role];
        result(@(YES));
    }else if ([setDefaultStreamRecvMode isEqualToString:call.method]) {
        BOOL isReceivedAudio = [self numberToBoolValue:args[@"isReceivedAudio"]];
        BOOL isReceivedVideo = [self numberToBoolValue:args[@"isReceivedVideo"]];
        [self.trtc setDefaultStreamRecvMode:isReceivedAudio video:isReceivedVideo];
    }else if ([destroyPlatformView isEqualToString:call.method]) {
        int viewID = [self numberToIntValue:args[@"viewId"]];
        BOOL success = [[TRTCPlatformViewFactory shareInstance] removeView:@(viewID)];
        result(@(success));
    }else if ([startLocalPreview isEqualToString:call.method]) {
        BOOL frontCamera =[self numberToBoolValue:args[@"frontCamera"]];
        int viewID = [self numberToIntValue:args[@"viewId"]];
        TRTCVideoView * view = [[TRTCPlatformViewFactory shareInstance] getPlatformView:@(viewID)];
        if(view) {
            [self.trtc startLocalPreview:frontCamera view:[view getUIView]];
            result(@(YES));
        } else {
            result(@(NO));
        }
    }else if ([stopLocalPreview isEqualToString:call.method]) {
        [self.trtc stopLocalPreview];
    }else if ([startRemoteView isEqualToString:call.method]) {
        NSString * userId = args[@"userId"];
        int viewID = [self numberToIntValue:args[@"viewId"]];
        TRTCVideoView * view = [[TRTCPlatformViewFactory shareInstance] getPlatformView:@(viewID)];
        if(view){
            [self.trtc startRemoteView:userId view:[view getUIView]];
            result(@(YES));
        }else{
            result(@(NO));
        }
    }else if ([stopRemoteView isEqualToString:call.method]) {
        NSString * userId = args[@"userId"];
        [self.trtc stopRemoteView:userId];
    }else if ([stopAllRemoteView isEqualToString:call.method]) {
        [self.trtc stopAllRemoteView];
    }else if ([muteLocalVideo isEqualToString:call.method]) {
        BOOL mote =[self numberToBoolValue:args[@"mote"]];
        [self.trtc muteLocalAudio:mote];
    }else if ([setLocalViewFillMode isEqualToString:call.method]) {
        int mode = [self numberToIntValue:args[@"mode"]];
        [self.trtc setLocalViewFillMode:mode];
    }else if ([setLocalViewRotation isEqualToString:call.method]) {
        int rotation = [self numberToIntValue:args[@"rotation"]];
        [self.trtc setLocalViewRotation:rotation];
    }else if ([setRemoteViewFillMode isEqualToString:call.method]) {
        NSString * userId = args[@"userId"];
        int mode = [self numberToIntValue:args[@"mode"]];
        [self.trtc setRemoteViewFillMode:userId mode:mode];
    }else if ([setRemoteViewRotation isEqualToString:call.method]) {
        NSString * userId = args[@"userId"];
        int rotation = [self numberToIntValue:args[@"rotation"]];
        [self.trtc setRemoteViewRotation:userId rotation:rotation];
    }else if ([startLocalAudio isEqualToString:call.method]) {
        [self.trtc startLocalAudio];
    }else if ([stopLocalAudio isEqualToString:call.method]) {
        [self.trtc stopLocalAudio];
    }else if ([muteLocalAudio isEqualToString:call.method]) {
        int mote = [self numberToIntValue:args[@"mote"]];
        [self.trtc muteLocalAudio:mote];
    }else if ([setAudioRoute isEqualToString:call.method]) {
        int route = [self numberToIntValue:args[@"route"]];
        [self.trtc setAudioRoute:route];
    }else if ([muteRemoteAudio isEqualToString:call.method]) {
        NSString * userId = args[@"userId"];
        BOOL mote = [self numberToBoolValue:args[@"mote"]];
        [self.trtc muteRemoteAudio:userId mute:mote];
    }else if ([muteAllRemoteAudio isEqualToString:call.method]) {
        BOOL mote = [self numberToBoolValue:args[@"mote"]];
        [self.trtc muteAllRemoteAudio:mote];
    }else if ([switchCamera isEqualToString:call.method]) {
        [self.trtc switchCamera];
    }else if ([setVideoEncoderParam isEqualToString:call.method]) {
        int videoResolution = [self numberToIntValue:args[@"videoResolution"]];
        int resMode =[self numberToIntValue:args[@"videoResolutionMode"]];
        int videoFps = [self numberToIntValue:args[@"videoFps"]];
        int videoBitrate = [self numberToIntValue:args[@"videoBitrate"]];
        BOOL enableAdjustRes =[self numberToBoolValue:args[@"enableAdjustRes"]];
        TRTCVideoEncParam * endParam = [[TRTCVideoEncParam alloc]init];
        endParam.videoResolution = videoResolution;
        endParam.resMode = resMode;
        endParam.videoFps = videoFps;
        endParam.videoBitrate = videoBitrate;
        endParam.enableAdjustRes = enableAdjustRes;
        [self.trtc setVideoEncoderParam:endParam];
    }else if ([setNetworkQosParam isEqualToString:call.method]) {
        int preference = [self numberToIntValue:args[@"preference"]];
        int controlMode =[self numberToIntValue:args[@"controlMode"]];
        TRTCNetworkQosParam * qosParam = [[TRTCNetworkQosParam alloc]init];
        qosParam.preference = preference;
        qosParam.controlMode = controlMode;
        [self.trtc setNetworkQosParam:qosParam];
    }else if ([setLocalViewMirror isEqualToString:call.method]) {
        int mirrorType = [self numberToIntValue:args[@"mirrorType"]];
        [self.trtc setLocalViewMirror:mirrorType];
    }else if ([setVideoEncoderMirror isEqualToString:call.method]) {
        BOOL mirror =[self numberToBoolValue:args[@"mirror"]];
        [self.trtc setVideoEncoderMirror:mirror];
    }else if ([startAudioRecording isEqualToString:call.method]) {
        NSString * path = args[@"path"];
        TRTCAudioRecordingParams * params = [[TRTCAudioRecordingParams alloc]init];
        params.filePath = path;
        result(@([self.trtc startAudioRecording:params]));
    }else if ([stopAudioRecording isEqualToString:call.method]) {
        [self.trtc stopAudioRecording];
    }else if ([startRemoteSubStreamView isEqualToString:call.method]) {
        NSString * userId = args[@"userId"];
        int viewId = [self numberToIntValue:args[@"viewId"]];
        TRTCVideoView * view = [[TRTCPlatformViewFactory shareInstance] getPlatformView:@(viewId)];
        if(view){
            [self.trtc startRemoteSubStreamView:userId view:[view getUIView]];
            result(@(YES));
        }else{
            result(@(NO));
        }
    }else if ([stopRemoteSubStreamView isEqualToString:call.method]) {
        NSString * userId = args[@"userId"];
        [self.trtc stopRemoteSubStreamView:userId];
    }else if ([setRemoteSubStreamViewFillMode isEqualToString:call.method]) {
        NSString * userId = args[@"userId"];
        int mode = [self numberToIntValue:args[@"mode"]];
        [self.trtc setRemoteSubStreamViewFillMode:userId mode:mode];
    }else if ([setRemoteSubStreamViewRotation isEqualToString:call.method]) {
        NSString * userId = args[@"userId"];
        int rotation = [self numberToIntValue:args[@"rotation"]];
        [self.trtc setRemoteSubStreamViewRotation:userId rotation:rotation];
    }else if ([@"init" isEqualToString:call.method]) {
            [self disposeAllPlayers];
            result(nil);
        }else if([@"create" isEqualToString:call.method]){
            NSLog(@"FLTVideo  create");
            [self disposeAllPlayers];
            FLTFrameUpdater* frameUpdater = [[FLTFrameUpdater alloc] initWithRegistry:_registry];
    //        FLTVideoPlayer*
            player= [[FLTVideoPlayer alloc] initWithCall:call frameUpdater:frameUpdater registry:_registry messenger:_messenger];
            if (player) {
                [self onPlayerSetup:player frameUpdater:frameUpdater result:result];
            }
            result(nil);
        }else if([@"download" isEqualToString:call.method]){
            
             NSDictionary* argsMap = call.arguments;
             NSString* urlOrFileId = argsMap[@"urlOrFileId"];
            NSLog(@"下载相关   startdownload  %@", urlOrFileId);
            
            NSString* channelUrl =[NSString stringWithFormat:@"flutter_trtc_plugin_download_event%@",urlOrFileId];
            NSLog(@"%@", channelUrl);
            FlutterEventChannel* eventChannel = [FlutterEventChannel
                                                 eventChannelWithName:channelUrl
                                                 binaryMessenger:_messenger];
           FLTDownLoadManager* downLoadManager = [[FLTDownLoadManager alloc] initWithMethodCall:call result:result];
           [eventChannel setStreamHandler:downLoadManager];
           downLoadManager.eventChannel =eventChannel;
           [downLoadManager downLoad];
           
           _downLoads[urlOrFileId] = downLoadManager;
           NSLog(@"下载相关   start 数组大小  %lu", (unsigned long)_downLoads.count);
            
            
            result(nil);
        }else if([@"stopDownload" isEqualToString:call.method]){
            NSDictionary* argsMap = call.arguments;
            NSString* urlOrFileId = argsMap[@"urlOrFileId"];
            NSLog(@"下载相关    stopDownload  %@", urlOrFileId);
            FLTDownLoadManager* downLoadManager =   _downLoads[urlOrFileId];
            if(downLoadManager!=nil){
               [downLoadManager stopDownLoad];
            }else{
                NSLog(@"下载相关   对象为空  %lu", (unsigned long)_downLoads.count);
            }
            
            
           
            result(nil);
        }else if([@"play" isEqualToString:call.method]||[@"pause" isEqualToString:call.method]||[@"seekTo" isEqualToString:call.method]||[@"setRate" isEqualToString:call.method]||[@"setBitrateIndex" isEqualToString:call.method]||[@"dispose" isEqualToString:call.method]){
            [self onMethodCall:call result:result];
        }else {
        result(FlutterMethodNotImplemented);
    }
}

-(void) onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result{
    
    NSDictionary* argsMap = call.arguments;
   // int64_t textureId = ((NSNumber*)argsMap[@"textureId"]).unsignedIntegerValue;
    if([NSNull null]==argsMap[@"textureId"]) {
        return;
    }
    int64_t textureId = ((NSNumber*)argsMap[@"textureId"]).unsignedIntegerValue;
//    FLTVideoPlayer* player = _players[@(textureId)];

    if([@"play" isEqualToString:call.method]){
        [player resume];
        result(nil);
    }else if([@"pause" isEqualToString:call.method]){
        [player pause];
        result(nil);
    }else if([@"seekTo" isEqualToString:call.method]){
        NSLog(@"跳转到指定位置----------");
        [player seekTo:[[argsMap objectForKey:@"location"] intValue]];
        result(nil);
    }else if([@"setRate" isEqualToString:call.method]){ //播放速率
        NSLog(@"修改播放速率----------");
        float rate = [[argsMap objectForKey:@"rate"] floatValue];
        if (rate<0||rate>2) {
            result(nil);
            return;
        }
        [player setRate:rate];
        result(nil);
        
    }else if([@"setBitrateIndex" isEqualToString:call.method]){
        NSLog(@"修改播放清晰度----------");
        int  index = [[argsMap objectForKey:@"index"] intValue];
        [player setBitrateIndex:index];
        result(nil);
    }else if([@"dispose" isEqualToString:call.method]){
         NSLog(@"FLTVideo  dispose   ----   ");
        [_registry unregisterTexture:textureId];
       // [_players removeObjectForKey:@(textureId)];
        //_players= nil;
        [self disposeAllPlayers];
        result(nil);
    }else{
        result(FlutterMethodNotImplemented);
    }
    
}

- (void)onPlayerSetup:(FLTVideoPlayer*)player
         frameUpdater:(FLTFrameUpdater*)frameUpdater
               result:(FlutterResult)result {
//    _players[@(player.textureId)] = player;
    result(@{@"textureId" : @(player.textureId)});
    
}

-(void) disposeAllPlayers{
     NSLog(@"FLTVideo 初始化播放器状态----------");
    // Allow audio playback when the Ring/Silent switch is set to silent
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    if(player){
        [player dispose];
        player = nil;
    }
}

#pragma mark- 初始化API
-(void)initTrtcManager{
    self.trtc = [TRTCCloud sharedInstance];
    [self.trtc setDelegate:self];
    
}
-(void)destroySharedIntance{
    [TRTCCloud destroySharedIntance];
}
#pragma mark - flutter_trtc_plugin_callback
#pragma mark- 进房监听
- (void)onEnterRoom:(NSInteger)result {
    FlutterEventSink sink = _eventSink;
    if(sink) {
        sink(@{@"method": @{@"name": @"onEnterRoom",@"result": @(result),}});
    }
    
}
#pragma mark- 退房监听
-(void)onExitRoom:(NSInteger)reason{
    FlutterEventSink sink = _eventSink;
    if(sink) {
        sink(@{@"method": @{@"name": @"onExitRoom",@"reason": @(reason),}});
    }
}
-(void)onSwitchRole:(TXLiteAVError)errCode errMsg:(id)errMsg{
    FlutterEventSink sink = _eventSink;
    if (sink) {
        sink(@{@"method": @{@"name": @"onSwitchRole",@"errCode":@(errCode),@"errMsg":errMsg}});
    }
}
#pragma mark- 远程进房监听
-(void)onRemoteUserEnterRoom:(NSString *)userId{
    FlutterEventSink sink = _eventSink;
    if(sink) {
        sink(@{@"method": @{@"name": @"onRemoteUserEnterRoom",@"userId": userId}});
    }
}
#pragma mark- 远程退房监听
-(void)onRemoteUserLeaveRoom:(NSString *)userId reason:(NSInteger)reason{
    FlutterEventSink sink = _eventSink;
    if(sink) {
        sink(@{@"method": @{@"name": @"onRemoteUserLeaveRoom",@"userId": userId,@"reason":@(reason)}});
    }
}
#pragma mark - 视频监听
-(void)onUserVideoAvailable:(NSString *)userId available:(BOOL)available{
    FlutterEventSink sink = _eventSink;
    if(sink) {
        sink(@{@"method": @{@"name": @"onUserVideoAvailable",@"userId": userId,@"available":@(available)}});
    }
}
#pragma mark - 音频监听
-(void)onUserAudioAvailable:(NSString *)userId available:(BOOL)available{
    FlutterEventSink sink = _eventSink;
    if(sink) {
        sink(@{@"method": @{@"name": @"onUserAudioAvailable",@"userId": userId,@"available":@(available)}});
    }
    
}
#pragma mark- 失去连接监听
-(void)onConnectionLost{
    FlutterEventSink sink = _eventSink;
    if(sink) {
        sink(@{@"method": @{@"name": @"onConnectionLost"}});
    }
}
#pragma mark - 尝试连接监听
-(void)onTryToReconnect{
    FlutterEventSink sink = _eventSink;
    if(sink) {
        sink(@{@"method": @{@"name": @"onTryToReconnect"}});
    }
}
#pragma mark- 连接回复监听
-(void)onConnectionRecovery{
    FlutterEventSink sink = _eventSink;
    if(sink) {
        sink(@{@"method": @{@"name": @"onConnectionRecovery"}});
    }
}
#pragma mark- 错误监听
-(void)onError:(TXLiteAVError)errCode errMsg:(NSString *)errMsg extInfo:(NSDictionary *)extInfo{
    FlutterEventSink sink = _eventSink;
    if(sink) {
        sink(@{@"method": @{@"name": @"onError",@"errCode":@(errCode),@"errMsg":errMsg}});
    }
}
#pragma mark - 警告监听
-(void)onWarning:(TXLiteAVWarning)warningCode warningMsg:(NSString *)warningMsg extInfo:(NSDictionary *)extInfo{
    FlutterEventSink sink = _eventSink;
    if(sink) {
        sink(@{@"method": @{@"name": @"onWarning",@"warningCode":@(warningCode),@"warningMsg":warningMsg}});
    }
}
#pragma mark -- 屏幕分享监听
- (void)onUserSubStreamAvailable:(NSString *)userId available:(BOOL)available{
    FlutterEventSink sink = _eventSink;
    if(sink) {
        sink(@{@"method": @{@"name": @"onUserSubStreamAvailable",@"userId":userId,@"available":@(available)}});
    }
}
#pragma mark - FlutterStreamHandler methods

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    NSLog(@"%@", [NSString stringWithFormat:@"[Flutter-Native] onCancel sink, object: %@", arguments]);
    _eventSink = nil;
    return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    _eventSink = events;
    [[TRTCPlatformViewFactory shareInstance] setEventSink:events];
    NSLog(@"%@", [NSString stringWithFormat:@"[Flutter-Native] onListen sink: %p, object: %@", _eventSink, arguments]);
    return nil;
}

@end
