//
//  TRTCCloudManager.h
//  flutter_trtc_plugin
//
//  Created by gejianmin on 2020/3/4.
//

#import <Foundation/Foundation.h>
#import "TRTCCloud.h"
NS_ASSUME_NONNULL_BEGIN
@class TRTCCloudManager;

@protocol TRTCCloudManagerDelegate <NSObject>

@optional
- (void)roomSettingsManager:(TRTCCloudManager *)manager didSetVolumeEvaluation:(BOOL)isEnabled;

@end
@interface TRTCCloudManager : NSObject
@property (weak, nonatomic) id<TRTCCloudManagerDelegate> delegate;
@property (strong, nonatomic, nullable) UIImageView *videoView;
#pragma mark - Room

/// 加入房间
- (void)enterRoom:(TRTCParams *)params appScene:(TRTCAppScene)appScene;
///渲染视频
-(void)startLocalPreview:(BOOL)frontCamera viewID:(int64_t)viewID;

@end

NS_ASSUME_NONNULL_END
