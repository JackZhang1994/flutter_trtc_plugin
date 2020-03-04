//
//  TRTCCloudManager.m
//  flutter_trtc_plugin
//
//  Created by gejianmin on 2020/3/4.
//

#import "TRTCCloudManager.h"
#import "TRTCVideoView.h"
#import "TRTCCloud.h"
@interface TRTCCloudManager()<TRTCCloudDelegate>
@property (strong, nonatomic) TRTCCloud *trtc;

@end
@implementation TRTCCloudManager



- (void)enterRoom:(TRTCParams *)params appScene:(TRTCAppScene)scene{
    [self.trtc enterRoom:params appScene:scene];
}

-(void)startLocalPreview:(BOOL)frontCamera viewID:(int64_t)viewID{
    TXView *view = (TXView *)[[TRTCVideoView alloc] initWithRect:CGRectZero viewID:viewID];
    [self.trtc startLocalPreview:frontCamera view:view];
}
@end
