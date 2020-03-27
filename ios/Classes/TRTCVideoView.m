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
@property(nonatomic,strong) FlutterEventSink sink;
@end

@implementation TRTCVideoView

- (instancetype)initWithRect:(CGRect)rect viewID:(int64_t) viewId sink:(nonnull FlutterEventSink)sink{
    self = [super init];
    if(self) {
        _uiView = [[UIView alloc] initWithFrame:rect];
        _uiView.backgroundColor = [UIColor blackColor];
        _viewId = viewId;
        _sink = sink;
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event:)];
        [_uiView addGestureRecognizer:tapGesture];
        
    }
    
    return self;
}
- (int)numberToIntValue:(NSNumber *)number {
    
    return [number isKindOfClass:[NSNull class]] ? 0 : [number intValue];
}
-(void)event:(UITapGestureRecognizer *)gesture{
    if(_sink){
        _sink(@{@"method": @{@"name": @"onTrtcViewClick",@"viewId":@(_viewId),}});
    }
}
- (UIView *)getUIView {
    return self.uiView;
}
# pragma mark - Flutter Platform View Delegate

- (UIView *)view {
    return self.uiView;
}

@end
