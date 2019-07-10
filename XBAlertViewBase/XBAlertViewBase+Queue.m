//
//  XBAlertViewBase+Queue.m
//  XBAlertView
//
//  Created by xxb on 2017/8/22.
//  Copyright © 2017年 xxb. All rights reserved.
//

#import "XBAlertViewBase+Queue.h"
#import <objc/message.h>
#import "XBAlertViewManager.h"

@implementation XBAlertViewBase (Queue)

+ (void)load
{
    Method show = class_getInstanceMethod(self, @selector(show));
    Method logShow = class_getInstanceMethod(self, @selector(logShow));
    method_exchangeImplementations(show, logShow);
    
    Method hidden = class_getInstanceMethod(self, @selector(hidden));
    Method logHidden = class_getInstanceMethod(self, @selector(logHidden));
    method_exchangeImplementations(hidden, logHidden);
}

- (void)logShow
{
    if ([self isKindOfClass:NSClassFromString(@"XBAlertView")] == false)
    {
        [self logShow];
        return;
    }
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    if (keyWindow != [XBAlertViewManager shared].window)
    {
        keyWindow.userInteractionEnabled = NO;
        [XBAlertViewManager shared].oldKeyWindow = keyWindow;
        [[XBAlertViewManager shared].window makeKeyWindow];
    }
    
    [XBAlertViewManager shared].window.alpha = 1;
    
    XBAlertViewBase *alertView = [XBAlertViewManager shared].arrM_alertViews.lastObject;
    
    [[XBAlertViewManager shared].arrM_alertViews addObject:self];
    [self logShow];
    
    [alertView logHidden];
}
- (void)logHidden
{
    if ([self isKindOfClass:NSClassFromString(@"XBAlertView")] == false)
    {
        [self logHidden];
        return;
    }
    [self logHidden];
    
    NSMutableArray *arrM_alertViews = [XBAlertViewManager shared].arrM_alertViews;
    if (self == arrM_alertViews.lastObject)
    {
        [arrM_alertViews removeObject:self];
    }
    
    if (arrM_alertViews.count > 0)
    {
        [[arrM_alertViews lastObject] logShow];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            [XBAlertViewManager shared].window.alpha = 0;
        }];
        [[XBAlertViewManager shared].oldKeyWindow makeKeyWindow];
        [XBAlertViewManager shared].oldKeyWindow.userInteractionEnabled = YES;
        [XBAlertViewManager shared].oldKeyWindow = nil;
    }
}
@end
