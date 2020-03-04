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

//- (void)setLocalView:(UIView*)localView remoteViewDic:(NSMutableDictionary*)remoteViewDic;
@end

@implementation TRTCVideoView{
    int64_t _viewId;
    FlutterMethodChannel* _channel;
    UILabel * _uiLabel;
    UIView * _videoView;
     TRTCCloud *trtcCloud;
}


- (instancetype)initWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger{
    _remoteViewDic = [[NSMutableDictionary alloc] init];
    trtcCloud = [TRTCCloud sharedInstance];
    [trtcCloud setDelegate:self];
    [self enterRoom];
    
    NSString *text = @"iOS端UILabel";

    if ([args isKindOfClass:[NSDictionary class]]) {
        NSDictionary *params = (NSDictionary *)args;
        if([[params allKeys] containsObject:@"text"]){
            if ([[params valueForKey:@"text"] isKindOfClass:[NSString class]]) {
                text= [params valueForKey:@"text"];
            }
        }
    }
    _uiLabel = [[UILabel alloc] init];
    _uiLabel.backgroundColor =[UIColor grayColor];
    _uiLabel.textColor =[UIColor redColor];
    _uiLabel.textAlignment = NSTextAlignmentCenter;
    _uiLabel.text = text;
    _uiLabel.font = [UIFont systemFontOfSize:30];
    
    _videoView = [[UIView alloc] init];
    _videoView.backgroundColor =[UIColor grayColor];
    
    return self;
}
-(UIView *)view{
    return _videoView;
    
}
// 错误通知是要监听的，错误通知意味着 SDK 不能继续运行了
- (void)onError:(int)errCode errMsg:(NSString *)errMsg extInfo:(nullable NSDictionary *)extInfo {
    if (errCode == ERR_ROOM_ENTER_FAIL) {
//        [self toastTip:[NSString stringWithFormat:@"进房失败[%@]", errMsg]];
//        [self exitRoom];
        NSLog(@"进入房间失败==%@",errMsg);
        return;
    }
}
- (void)enterRoom {
{
    //TRTCParams 定义参考头文件TRTCCloudDef.h
    TRTCParams *params = [[TRTCParams alloc] init];
    params.sdkAppId    = 1400324442;
    params.userId      = @"123";
    params.userSig     =[GenerateTestUserSig genTestUserSig:@"123"];
    params.roomId      = 908; //输入您想进入的房间
    [trtcCloud enterRoom:params appScene:TRTCAppSceneVideoCall];
}
}
- (void)onEnterRoom:(NSInteger)elapsed {
//    NSString *msg = [NSString stringWithFormat:@"[%@]进房成功[%u]: elapsed[%d]", '_userID', '_roomID', elapsed];
    NSLog(@"进入房间成功%ld",(long)elapsed);
    [trtcCloud startLocalPreview:NO
    view:_videoView];
    
}
- (void)onUserVideoAvailable:(NSString *)userId available:(BOOL)available {
//    if (userId != nil) {
//        TRTCVideoView* remoteView = [_remoteViewDic objectForKey:userId];
//        if (available) {
//            // 启动远程画面的解码和显示逻辑，FillMode 可以设置是否显示黑边
//            [trtcCloud startRemoteView:userId view:remoteView];
//            [trtcCloud setRemoteViewFillMode:userId mode:TRTCVideoFillMode_Fit];
//        }
//        else {
//            [trtcCloud stopRemoteView:userId];
//        }
//   }
}
@end
