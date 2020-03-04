//
//  TRTCVideoView.m
//  flutter_trtc_plugin
//
//  Created by gejianmin on 2020/3/3.
//

#import "TRTCVideoView.h"
#import "GenerateTestUserSig.h"
@interface TRTCVideoView()
@property (nonatomic, strong) UIView *uiView;
@property (nonatomic, assign) int64_t viewId;
@end

@implementation TRTCVideoView

- (instancetype)initWithRect:(CGRect)rect viewID:(int64_t) viewId {
    self = [super init];
    if(self) {
        _uiView = [[UIView alloc] initWithFrame:rect];
        _uiView.backgroundColor = [UIColor blackColor];
        _viewId = viewId;
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

@end
