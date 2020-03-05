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
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    }else if ([@"sharedInstance" isEqualToString:call.method]) {
        [[TRTCCloudManager shareInstance] initTrtcCloud];
    }else if ([@"enterRoom" isEqualToString:call.method]) {
        TRTCParams * params = [[TRTCParams alloc]init];
        params.roomId = [self numberToIntValue:args[@"roomId"]];
        params.sdkAppId = [self numberToIntValue:args[@"sdkAppId"]];
        params.userId = call.arguments[@"userId"];
        params.userSig = call.arguments[@"userSig"];
        int scene = [self numberToIntValue:args[@"scene"]];
        //进入房间
        [[TRTCCloudManager shareInstance] enterRoom:params appScene:scene];
    }else if ([@"startLocalPreview" isEqualToString:call.method]) {
        BOOL frontCamera =[self numberToBoolValue:args[@"frontCamera"]];
        int viewID = [self numberToIntValue:args[@"viewId"]];
        //本地视频渲染
        [[TRTCCloudManager shareInstance] startLocalPreview:frontCamera viewID:@(viewID) callBackBlock:^(BOOL success) {
            if(success){
                result(@(YES));
            }else{
               result(@(NO));
            }
        }];
    }else if ([@"exitRoom" isEqualToString:call.method]) {
        [[TRTCCloudManager shareInstance] exitRoom];
        result(0);
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
