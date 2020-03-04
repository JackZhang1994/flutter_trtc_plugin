#import "FlutterTrtcPlugin.h"
#import "TRTCPlatformViewFactory.h"
#import "TRTCCloud.h"
#import "TRTCCloudDelegate.h"
@interface FlutterTrtcPlugin()<TRTCCloudDelegate,FlutterStreamHandler>
@property(nonatomic,strong) TRTCCloud *trtc;
@property(nonatomic,strong) FlutterMethodChannel* channel;
@property (nonatomic, strong) NSObject<FlutterPluginRegistrar> *registrar;
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
    [registrar registerViewFactory:[TRTCPlatformViewFactory shareInstance] withId:@"platform_video_view"];
    
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    }else if ([@"sharedInstance" isEqualToString:call.method]) {
        self.trtc = [TRTCCloud sharedInstance];
        [self.trtc setDelegate:self];
    } else {
        result(FlutterMethodNotImplemented);
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
