//
//  TRTCPlatformViewFactory.m
//  flutter_trtc_plugin
//
//  Created by gejianmin on 2020/3/3.
//

#import "TRTCPlatformViewFactory.h"
#import "TRTCVideoView.h"
@implementation TRTCPlatformViewFactory{
    NSObject<FlutterBinaryMessenger> * _messenger;
}
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messager{
    self = [super init];
    if (self) {
        _messenger = messager;
    }
    return self;
}

-(NSObject<FlutterMessageCodec> *)createArgsCodec{
    return [FlutterStandardMessageCodec sharedInstance];
}

-(NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args{
    TRTCVideoView *tRTCVideoView = [[TRTCVideoView alloc] initWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger];
    return tRTCVideoView;
}


@end
