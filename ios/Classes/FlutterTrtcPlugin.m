#import "FlutterTrtcPlugin.h"
#import "TRTCPlatformViewFactory.h"
#import "TRTCCloud.h"
#import "TRTCCloudDelegate.h"
#import "TRTCCloudManager.h"
#import "TRTCVideoView.h"
#import "GenerateTestUserSig.h"
@interface FlutterTrtcPlugin()<TRTCCloudDelegate,FlutterStreamHandler>
@property(nonatomic,strong) TRTCCloud *trtc;
@property(nonatomic,strong) FlutterMethodChannel* channel;
@property (nonatomic, strong) NSObject<FlutterPluginRegistrar> *registrar;
@property(nonatomic,strong) TRTCCloudManager* manager;

@end

@implementation FlutterTrtcPlugin
{
    volatile FlutterEventSink _eventSink;
}
-(instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar{
    if(self =[super init]){
        _trtc = nil;
        _registrar = registrar;
        
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
                                     methodChannelWithName:@"flutter_trtc_plugin"
                                     binaryMessenger:[registrar messenger]];
    
    [registrar addMethodCallDelegate:instance channel:channel];
    /*Create Event Channel.*/
    FlutterEventChannel * eventChannel = [FlutterEventChannel eventChannelWithName:@"flutter_trtc_plugin_callback" binaryMessenger:[registrar messenger]];
    [eventChannel setStreamHandler:instance];
    
    // 添加注册我们创建的 view ，注意这里的 withId 需要和 flutter 侧的值相同 platform_video_view
    [registrar registerViewFactory:[TRTCPlatformViewFactory shareInstance] withId:@"flutter_trtc_plugin_view"];
    
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *args = call.arguments;
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS" stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    }else if ([@"sharedInstance" isEqualToString:call.method]) {
        //设置代理
        [self initTrtcManager];
    }else if ([@"destroySharedInstance" isEqualToString:call.method]) {
        //销毁
    }else if ([@"getUserSig" isEqualToString:call.method]) {
        //获取签名
        NSString *  userId =args[@"userId"];
        int sdkAppId = [self numberToIntValue:args[@"sdkAppId"]];
        NSString * secretKey =[NSString stringWithFormat:@"%@",args[@"secretKey"]];
        NSString * sign = [GenerateTestUserSig genTestUserSig:sdkAppId secretKey:secretKey userId:userId];
        result(sign);
    }else if ([@"enterRoom" isEqualToString:call.method]) {
        TRTCParams * params = [[TRTCParams alloc]init];
        params.roomId = [self numberToIntValue:args[@"roomId"]];
        params.sdkAppId = [self numberToIntValue:args[@"sdkAppId"]];
        params.userId = call.arguments[@"userId"];
        params.userSig = call.arguments[@"userSig"];
        int scene = [self numberToIntValue:args[@"scene"]];
        //进入房间
        [self.trtc enterRoom:params appScene:scene];
        result(@(YES));
    }else if ([@"exitRoom" isEqualToString:call.method]) {
        [self.trtc exitRoom];
        result(0);
    }else if ([@"setDefaultStreamRecvMode" isEqualToString:call.method]) {
        BOOL isReceivedAudio = [self numberToBoolValue:args[@"isReceivedAudio"]];
        BOOL isReceivedVideo = [self numberToBoolValue:args[@"isReceivedVideo"]];
        [self.trtc setDefaultStreamRecvMode:isReceivedAudio video:isReceivedVideo];
    }else if ([@"destroyPlatformView" isEqualToString:call.method]) {
        int viewID = [self numberToIntValue:args[@"viewId"]];
        BOOL success = [[TRTCPlatformViewFactory shareInstance] removeView:@(viewID)];
        result(@(success));
    }else if ([@"startLocalPreview" isEqualToString:call.method]) {
        BOOL frontCamera =[self numberToBoolValue:args[@"frontCamera"]];
        int viewID = [self numberToIntValue:args[@"viewId"]];
        TRTCVideoView * view = [[TRTCPlatformViewFactory shareInstance] getPlatformView:@(viewID)];
        if(view) {
            [self.trtc startLocalPreview:frontCamera view:[view getUIView]];
            result(@(YES));
            
        } else {
            result(@(NO));
        }
    }else if ([@"stopLocalPreview" isEqualToString:call.method]) {
        [self.trtc stopLocalPreview];
    }else if ([@"startRemoteView" isEqualToString:call.method]) {
        NSString * userId = args[@"userId"];
        int viewID = [self numberToIntValue:args[@"viewId"]];
        //        [self.trtc.startRemoteView(userId, viewID)];
        TRTCVideoView * view = [[TRTCPlatformViewFactory shareInstance] getPlatformView:@(viewID)];
        [self.trtc startRemoteView:userId view:[view getUIView]];
    }else if ([@"stopRemoteView" isEqualToString:call.method]) {
        NSString * userId = args[@"userId"];
        [self.trtc stopRemoteView:userId];
    }else if ([@"stopAllRemoteView" isEqualToString:call.method]) {
        [self.trtc stopAllRemoteView];
    }else if ([@"muteLocalVideo" isEqualToString:call.method]) {
        BOOL mote =[self numberToBoolValue:args[@"mote"]];
        [self.trtc muteLocalAudio:mote];
    }else if ([@"setLocalViewFillMode" isEqualToString:call.method]) {
        int mode = [self numberToIntValue:args[@"mode"]];
        [self.trtc setLocalViewFillMode:mode];
    }else if ([@"setRemoteViewFillMode" isEqualToString:call.method]) {
        NSString * userId = args[@"userId"];
        int mode = [self numberToIntValue:args[@"mode"]];
        [self.trtc setRemoteViewFillMode:userId mode:mode];
    }else if ([@"startLocalAudio" isEqualToString:call.method]) {
        [self.trtc startLocalAudio];
    }else if ([@"stopLocalAudio" isEqualToString:call.method]) {
        [self.trtc stopLocalAudio];
    }else if ([@"muteLocalAudio" isEqualToString:call.method]) {
        int mote = [self numberToIntValue:args[@"mote"]];
        [self.trtc muteLocalAudio:mote];
    }else if ([@"setAudioRoute" isEqualToString:call.method]) {
        int route = [self numberToIntValue:args[@"route"]];
        [self.trtc setAudioRoute:route];
        
    }else if ([@"muteRemoteAudio" isEqualToString:call.method]) {
        NSString * userId = args[@"userId"];
        BOOL mote = [self numberToBoolValue:args[@"mote"]];
        [self.trtc muteRemoteAudio:userId mute:mote];
    }else if ([@"muteAllRemoteAudio" isEqualToString:call.method]) {
        //    boolean mote3 = numberToBoolValue((Boolean) call.argument("mote"));
        //    mManager.muteAllRemoteAudio(mote3);
        BOOL mote = [self numberToBoolValue:args[@"mote"]];
        [self.trtc muteAllRemoteAudio:mote];
    }else if ([@"switchCamera" isEqualToString:call.method]) {
        [self.trtc switchCamera];
    }else {
        result(FlutterMethodNotImplemented);
    }
}

#pragma mark - flutter_trtc_plugin
#pragma mark--初始化API
-(void)initTrtcManager{
    self.trtc = [TRTCCloud sharedInstance];
    [self.trtc setDelegate:self];
    
}
#pragma mark - flutter_trtc_plugin_callback
#pragma mark--进房监听
- (void)onEnterRoom:(NSInteger)result {
    FlutterEventSink sink = _eventSink;
    if(sink) {
        sink(@{@"method": @{@"name": @"onEnterRoom",@"result": @(result),}});
    }
    
}
#pragma mark--退房监听
-(void)onExitRoom:(NSInteger)reason{
    FlutterEventSink sink = _eventSink;
    if(sink) {
        sink(@{@"method": @{@"name": @"onExitRoom",@"reason": @(reason),}});
    }
}
#pragma mark--远程进房监听
-(void)onRemoteUserEnterRoom:(NSString *)userId{
    FlutterEventSink sink = _eventSink;
    if(sink) {
        sink(@{@"method": @{@"name": @"onRemoteUserEnterRoom",@"userId": userId}});
    }
}
#pragma mark--远程退房监听
-(void)onRemoteUserLeaveRoom:(NSString *)userId reason:(NSInteger)reason{
    FlutterEventSink sink = _eventSink;
    if(sink) {
        sink(@{@"method": @{@"name": @"onRemoteUserEnterRoom",@"userId": userId,@"reason":@(reason)}});
    }
    
}
#pragma mark -- 视频监听
-(void)onUserVideoAvailable:(NSString *)userId available:(BOOL)available{
    FlutterEventSink sink = _eventSink;
    if(sink) {
        sink(@{@"method": @{@"name": @"onUserVideoAvailable",@"userId": userId,@"available":@(available)}});
    }
}
#pragma mark --音频监听
-(void)onUserAudioAvailable:(NSString *)userId available:(BOOL)available{
    FlutterEventSink sink = _eventSink;
    if(sink) {
        sink(@{@"method": @{@"name": @"onUserAudioAvailable",@"userId": userId,@"available":@(available)}});
    }
    
}
#pragma mark-- 失去连接监听
-(void)onConnectionLost{
    FlutterEventSink sink = _eventSink;
    if(sink) {
        sink(@{@"method": @{@"name": @"onConnectionLost"}});
    }
}
#pragma mark-- 尝试连接监听
-(void)onTryToReconnect{
    FlutterEventSink sink = _eventSink;
    if(sink) {
        sink(@{@"method": @{@"name": @"onTryToReconnect"}});
    }
}
#pragma mark-- 连接回复监听
-(void)onConnectionRecovery{
    FlutterEventSink sink = _eventSink;
    if(sink) {
        sink(@{@"method": @{@"name": @"onConnectionRecovery"}});
    }
}
#pragma mark-- 错误监听
-(void)onError:(TXLiteAVError)errCode errMsg:(NSString *)errMsg extInfo:(NSDictionary *)extInfo{
    FlutterEventSink sink = _eventSink;
    if(sink) {
        sink(@{@"method": @{@"name": @"onError",@"errCode":@(errCode),@"errMsg":errMsg}});
    }
}
#pragma mark -- 警告监听
-(void)onWarning:(TXLiteAVWarning)warningCode warningMsg:(NSString *)warningMsg extInfo:(NSDictionary *)extInfo{
    FlutterEventSink sink = _eventSink;
    if(sink) {
        sink(@{@"method": @{@"name": @"onWarning",@"warningCode":@(warningCode),@"warningMsg":warningMsg}});
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
    NSLog(@"%@", [NSString stringWithFormat:@"[Flutter-Native] onListen sink: %p, object: %@", _eventSink, arguments]);
    return nil;
}

@end
