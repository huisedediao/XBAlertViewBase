//
//  XBAlertViewManager.m
//  d11
//
//  Created by xxb on 2017/8/17.
//  Copyright © 2017年 DreamCatcher. All rights reserved.
//

#import "XBAlertViewManager.h"
#import "UIView+Animation.h"

//屏幕宽高
#define kScreenWidth        [UIScreen mainScreen].bounds.size.width
#define kScreenHeight       [UIScreen mainScreen].bounds.size.height

#define kAnimationTime (0.3)

@interface XBAlertViewManager ()
{
    CGFloat lastAngle;
    NSLock *_lock;
}
@end

@implementation XBAlertViewManager

+ (instancetype)shared
{
    return [self new];
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static XBAlertViewManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone];
    });
    return manager;
}
- (instancetype)init
{
    if (self = [super init])
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self addNoticeAtInit_base];
            _arrM_alertViews = [NSMutableArray new];
            _lock = [NSLock new];
        });
    }
    return self;
}


-(void)addNoticeAtInit_base
{
    //添加通知获取设备发生旋转时的相关信息
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChange:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}

- (void)removeNotification_base
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)dealloc
{
    [self removeNotification_base];
}


- (void)deviceOrientationDidChange:(NSNotification *)notification
{
    UIInterfaceOrientation stateNoworientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat angle = 0;
        if (stateNoworientation == UIInterfaceOrientationPortrait)
        {
            angle = 0;
        }
        else if (stateNoworientation ==  UIDeviceOrientationPortraitUpsideDown)
        {
            angle = 180;
        }
        else if (stateNoworientation == UIInterfaceOrientationLandscapeRight)
        {
            angle = 90;
        }
        else
        {
            angle = 270;
        }
        
        CGFloat angleTemp = angle - lastAngle;
        
        
        
        [_window xb_makeRotationWithAngle:angleTemp duration:notification ? ((angleTemp == 180 || angleTemp == -180)? kAnimationTime * 2 : kAnimationTime) : 0];
        
        lastAngle = angle;
    });
}

- (UIWindow *)window
{
    [_lock lock];
    if (_window == nil)
    {
        UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, MIN(kScreenWidth, kScreenHeight), MAX(kScreenWidth, kScreenHeight))];
        window.windowLevel = 2000;
        window.hidden = NO;
        window.backgroundColor = [UIColor clearColor];
        
        _window = window;
        
        [self deviceOrientationDidChange:nil];
    }
    [_lock unlock];
    return _window;
}


@end
