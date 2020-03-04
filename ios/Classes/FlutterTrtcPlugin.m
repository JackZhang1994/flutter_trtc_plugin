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
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    }else if ([@"sharedInstance" isEqualToString:call.method]) {
        self.trtc = [TRTCCloud sharedInstance];
        [self.trtc setDelegate:self];
    }else if ([@"enterRoom" isEqualToString:call.method]) {
        TRTCParams * params = [[TRTCParams alloc]init];
//        params.roomId = (UInt32)call.arguments[@"roomId"];
//        params.sdkAppId = (UInt32)call.arguments[@"sdkAppId"];
//        params.userId = call.arguments[@"userId"];
//        params.userSig = call.arguments[@"userSig"];
////        int scene = (int)call.arguments[@"scene"];
            params.sdkAppId    = 1400324442;
            params.userId      = @"123";
            params.userSig     =[GenerateTestUserSig genTestUserSig:@"123"];
            params.roomId      = 908; //输入您想进入的房间
        [self.trtc enterRoom:params appScene:TRTCAppSceneVideoCall];
        
    }else if ([@"startLocalPreview" isEqualToString:call.method]) {
        NSDictionary *args = call.arguments;
        BOOL frontCamera =[self numberToBoolValue:args[@"frontCamera"]];
         int viewID = [self numberToIntValue:args[@"viewId"]];
        TRTCVideoView * view = [[TRTCVideoView alloc]initWithRect:CGRectZero viewID:viewID];
//        TRTCVideoView * view = [[TRTCPlatformViewFactory shareInstance] getPlatformView:@(viewID)];
        [view startView];
//               if(view) {
//                   [self.trtc startLocalPreview:frontCamera view:[view getUIView]];
//                   result(@(YES));
//               } else {
//                   result(@(NO));
//               }
    
    } else {
        result(FlutterMethodNotImplemented);
    }
}
- (void)onEnterRoom:(NSInteger)elapsed {
    NSLog(@"进入房间成功========%ld",(long)elapsed);
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
