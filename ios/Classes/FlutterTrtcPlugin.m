#import "FlutterTrtcPlugin.h"
#import "TRTCPlatformViewFactory.h"
@implementation FlutterTrtcPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_trtc_plugin"
            binaryMessenger:[registrar messenger]];
  FlutterTrtcPlugin* instance = [[FlutterTrtcPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
    // 添加注册我们创建的 view ，注意这里的 withId 需要和 flutter 侧的值相同
        [registrar registerViewFactory:[[TRTCPlatformViewFactory alloc] initWithMessenger:registrar.messenger] withId:@"platform_video_view"];
   
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
