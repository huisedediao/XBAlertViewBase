//
//  UIView+Animation.m
//  XBAnimation
//
//  Created by xxb on 2016/1/23.
//  Copyright © 2016年 xxb. All rights reserved.
//

#import "UIView+Animation.h"
#import <Messages/Messages.h>

//角度转成弧度
#define Angle2Radian(angle) ((angle) / 180.0 * M_PI)
//由弧度转换角度
#define Radian2Angle(radian) (radian * 180.0) / (M_PI)


@implementation UIView (Animation)


/**
 转场动画
 参数1：代理，动画执行完毕后会调用delegate的animationDidStop:finished:
 参数2：动画类型
 参数3：动画方向
 参数4：动画时间
 */
-(void)xb_makeTransitionAnimationWithDelegate:(id <CAAnimationDelegate>)delegate k_transitionType:(NSString *)k_transitionType kCATransitionFrom:(NSString *)kCATransitionFrom duration:(NSTimeInterval)duration;
{
    CATransition *anim = [CATransition animation];
    
    anim.type = k_transitionType; // 动画过渡类型
    
    if (kCATransitionFrom != nil)
    {
        anim.subtype = kCATransitionFrom; // 动画过渡方向
    }
    anim.duration = duration; // 动画持续1s
    // 代理，动画执行完毕后会调用delegate的animationDidStop:finished:
    anim.delegate = delegate;
    
    [self.layer addAnimation:anim forKey:nil];
}

/**
 旋转（顺时针）
 参数1：开始角度，直接传数字
 参数2：结束角度，直接传数字
 参数3：绕哪个轴旋转（默认为平面旋转）
 参数4：动画时间
 参数5：重复次数
 */
-(void)xb_makeRotationFromAngle:(CGFloat)fromAngle toAngle:(CGFloat)toAngle k_keyPath_rotation:(NSString *)k_keyPath_rotation duration:(NSTimeInterval)duration repeatCount:(float)repeatCount
{
    CABasicAnimation *transformAnima = [CABasicAnimation animationWithKeyPath:k_keyPath_rotation];
    transformAnima.fromValue = @(Angle2Radian(fromAngle));
    transformAnima.toValue = @(Angle2Radian(toAngle));
//    transformAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //    transformAnima.autoreverses = YES;
    transformAnima.duration = duration;
    transformAnima.repeatCount = repeatCount;
//    transformAnima.beginTime = CACurrentMediaTime() + 2;
    
    transformAnima.removedOnCompletion = NO;
    transformAnima.fillMode = kCAFillModeForwards;
    
    [self.layer addAnimation:transformAnima forKey:@"A"];
}

/**
 旋转
 参数1：直接传数字，45度就传45
 参数2：动画时间
 */
-(void)xb_makeRotationWithAngle:(CGFloat)angle duration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        self.transform = CGAffineTransformRotate(self.transform, Angle2Radian(angle));
    }];
}

/**
 缩放
 参数1：x方向缩放倍数
 参数2：y方向缩放倍数
 参数3：动画时间
 */
-(void)xb_makeScaleWithX:(CGFloat)x y:(CGFloat)y duration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        self.transform = CGAffineTransformScale(self.transform, x, y);
    }];
}

/**
 平移
 参数1：x方向移动的量
 参数2：y方向移动的量
 参数3：动画时间
 */
-(void)xb_makeTranslationWithX:(CGFloat)x y:(CGFloat)y duration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        self.transform = CGAffineTransformTranslate(self.transform, x, y);
    }];
}



@end
