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
@property (nonatomic,weak) id<TRTCCloudManagerDelegate> delegate;
typedef void(^CallBackBlock)(int result);
@property (nonatomic, copy)CallBackBlock callBack;
+ (instancetype) shareInstance;
#pragma mark - Room
///初始化SDK
-(void)initTrtcCloud;
/// 加入房间
- (void)enterRoom:(TRTCParams *)params appScene:(TRTCAppScene)appScene;
///渲染视频
-(void)startLocalPreview:(BOOL)frontCamera viewID:(NSNumber *)viewID callBackBlock:(CallBackBlock )callBack;
///退房
-(void)exitRoom;
@end

NS_ASSUME_NONNULL_END
