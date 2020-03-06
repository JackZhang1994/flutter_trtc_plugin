//
//  TRTCPlatformViewFactory.h
//  flutter_trtc_plugin
//
//  Created by gejianmin on 2020/3/3.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "TRTCVideoView.h"
#import <Flutter/FlutterPlatformViews.h>
NS_ASSUME_NONNULL_BEGIN

@interface TRTCPlatformViewFactory : NSObject<FlutterPlatformViewFactory>

+ (instancetype) shareInstance;
+ (void) release;

//- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messager;
//
//-(NSObject<FlutterMessageCodec> *)createArgsCodec;

//-(NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args;
- (BOOL)addView:(TRTCVideoView *)view viewID:(NSNumber *)viewId;
- (BOOL)removeView:(NSNumber *)viewId;
- (TRTCVideoView *)getPlatformView:(NSNumber *) viewId;
@end

NS_ASSUME_NONNULL_END
