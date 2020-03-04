//
//  TRTCVideoView.m
//  flutter_trtc_plugin
//
//  Created by gejianmin on 2020/3/3.
//

#import "TRTCVideoView.h"
#import "GenerateTestUserSig.h"
@interface TRTCVideoView()
@property(nonatomic,strong) NSMutableDictionary* remoteViewDic;//一个或者多个远程画面的view
@property (nonatomic, strong) UIView *uiView;
@property (nonatomic, assign) int64_t viewId;
@end

@implementation TRTCVideoView{
    FlutterMethodChannel* _channel;
     TRTCCloud *trtcCloud;
}

- (instancetype)initWithRect:(CGRect)rect viewID:(int64_t) viewId {
    self = [super init];
    if(self) {
        _uiView = [[UIView alloc] initWithFrame:rect];
        _uiView.backgroundColor = [UIColor blackColor];
        _viewId = viewId;
        _remoteViewDic = [[NSMutableDictionary alloc] init];
        trtcCloud = [TRTCCloud sharedInstance];
        [trtcCloud setDelegate:self];
//        [self enterRoom];
    }
    
    return self;
}
- (UIView *)getUIView {
    return self.uiView;
}
# pragma mark - Flutter Platform View Delegate

- (UIView *)view {
    return self.uiView;
}

// 错误通知是要监听的，错误通知意味着 SDK 不能继续运行了
//- (void)onError:(int)errCode errMsg:(NSString *)errMsg extInfo:(nullable NSDictionary *)extInfo {
//    if (errCode == ERR_ROOM_ENTER_FAIL) {
////        [self toastTip:[NSString stringWithFormat:@"进房失败[%@]", errMsg]];
////        [self exitRoom];
//        NSLog(@"进入房间失败==%@",errMsg);
//        return;
//    }
//}
//- (void)enterRoom {
//
//    //TRTCParams 定义参考头文件TRTCCloudDef.h
//    TRTCParams *params = [[TRTCParams alloc] init];
//    params.sdkAppId    = 1400324442;
//    params.userId      = @"123";
//    params.userSig     =[GenerateTestUserSig genTestUserSig:@"123"];
//    params.roomId      = 908; //输入您想进入的房间
//    [trtcCloud enterRoom:params appScene:TRTCAppSceneVideoCall];
//}
//}
//- (void)onEnterRoom:(NSInteger)elapsed {
////    NSString *msg = [NSString stringWithFormat:@"[%@]进房成功[%u]: elapsed[%d]", '_userID', '_roomID', elapsed];
//    NSLog(@"进入房间成功%ld",(long)elapsed);
//    [trtcCloud startLocalPreview:NO
//    view:_uiView];
//
//}
//- (void)onUserVideoAvailable:(NSString *)userId available:(BOOL)available {
//
//}
-(void)startView{
    [trtcCloud startLocalPreview:YES view:_uiView];
}
@end
