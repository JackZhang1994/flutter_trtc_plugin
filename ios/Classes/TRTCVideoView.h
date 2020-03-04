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

NS_ASSUME_NONNULL_BEGIN

@interface TRTCVideoView : NSObject<FlutterPlatformView,TRTCCloudDelegate>

- (instancetype)initWithFrame:(CGRect)frame
                   viewIdentifier:(int64_t)viewId
                        arguments:(id _Nullable)args
                  binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

@end

NS_ASSUME_NONNULL_END
