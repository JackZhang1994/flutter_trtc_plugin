//
//  TRTCCloudManager.m
//  flutter_trtc_plugin
//
//  Created by gejianmin on 2020/3/4.
//

#import "TRTCCloudManager.h"
#import "TRTCVideoView.h"
#import "TRTCCloud.h"
#import "TRTCPlatformViewFactory.h"
static TRTCCloudManager * _manager = nil;
static TRTCCloud * _trtc = nil;
@interface TRTCCloudManager()<TRTCCloudDelegate>
@property (strong, nonatomic) TRTCCloud *trtc;

@end
@implementation TRTCCloudManager
- (instancetype)init{
    self = [super init];
    if (self) {
//        _trtc = [TRTCCloud sharedInstance];
//        [_trtc setDelegate:self];
    }
    return self;
}
+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[TRTCCloudManager alloc]init];
    });
    return _manager;
}
+(void)release{
    if(_manager){
        _manager = nil;
    }
    if(_trtc){
        _trtc = nil;
    }
}

-(void)initTrtcCloud{
    _trtc = [TRTCCloud sharedInstance];
    [_trtc setDelegate:self];
}
- (void)enterRoom:(TRTCParams *)params appScene:(TRTCAppScene)scene{
    [self.trtc enterRoom:params appScene:scene];
}

-(void)startLocalPreview:(BOOL)frontCamera viewID:(NSNumber *)viewID callBackBlock:(nonnull CallBackBlock)callBack{
    self.callBack = callBack;
    TRTCVideoView * view = [[TRTCPlatformViewFactory shareInstance] getPlatformView:viewID];
    if(view) {
        [self.trtc startLocalPreview:frontCamera view:[view getUIView]];
        self.callBack(1);
    
    } else {
        self.callBack(0);
    }
}

-(void)exitRoom{
    [self.trtc exitRoom];
}
-(void)onExitRoom:(NSInteger)reason{
    
}

@end
