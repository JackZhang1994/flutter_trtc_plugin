//
//  TRTCVideoView.h
//  flutter_trtc_plugin
//
//  Created by gejianmin on 2020/3/3.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "TRTCCloud.h"
#import "TRTCCloudDelegate.h"
#import <Flutter/FlutterPlatformViews.h>
NS_ASSUME_NONNULL_BEGIN

@interface TRTCVideoView : NSObject<FlutterPlatformView,TRTCCloudDelegate>

- (instancetype)initWithRect:(CGRect)rect viewID:(int64_t) viewId sink:(FlutterEventSink)sink;
- (UIView *)getUIView;
@end

NS_ASSUME_NONNULL_END
