//
//  UIView+Animation.h
//  XBAnimation
//
//  Created by xxb on 2016/1/23.
//  Copyright © 2016年 xxb. All rights reserved.
//

#import <UIKit/UIKit.h>



#define k_keyPath_rotation_default @"transform.rotation" //默认，平面旋转
#define k_keyPath_rotation_aroundY @"transform.rotation.y" //沿着y轴旋转
#define k_keyPath_rotation_aroundX @"transform.rotation.x" //沿着x轴旋转



#define k_transitionType_fade                   @"fade"                     //交叉淡化过渡(不支持过渡方向)
#define k_transitionType_push                   @"push"                     //新视图把旧视图推出去
#define k_transitionType_moveIn                 @"moveIn"                   //新视图移到旧视图上面
#define k_transitionType_reveal                 @"reveal"                   //将旧视图移开,显示下面的新视图
#define k_transitionType_cube                   @"cube"                     //立方体翻滚效果
#define k_transitionType_oglFlip                @"oglFlip"                  //上下左右翻转效果
#define k_transitionType_suckEffect             @"suckEffect"               //收缩效果，如一块布被抽走(不支持过渡方向)
#define k_transitionType_rippleEffect           @"rippleEffect"             //滴水效果(不支持过渡方向)
#define k_transitionType_pageCurl               @"pageCurl"                 //向上翻页效果
#define k_transitionType_pageUnCurl             @"pageUnCurl"               //向下翻页效果
#define k_transitionType_cameraIrisHollowOpen   @"cameraIrisHollowOpen"     //相机镜头打开效果(不支持过渡方向)
#define k_transitionType_cameraIrisHollowClose   @"cameraIrisHollowClose"     //相机镜头打开效果(不支持过渡方向)

/* 
 过渡方向
 kCATransitionFromRight
 kCATransitionFromLeft
 kCATransitionFromBottom
 kCATransitionFromTop
 */

@interface UIView (Animation)


/**
 转场动画
 参数1：代理，动画执行完毕后会调用delegate的animationDidStop:finished:
 参数2：动画类型
 参数3：动画方向
 参数4：动画时间
 */
-(void)xb_makeTransitionAnimationWithDelegate:(id <CAAnimationDelegate>)delegate k_transitionType:(NSString *)k_transitionType kCATransitionFrom:(NSString *)kCATransitionFrom duration:(NSTimeInterval)duration;

/**
 旋转（顺时针）
 参数1：开始角度，直接传数字
 参数2：结束角度，直接传数字
 参数3：绕哪个轴旋转（默认为平面旋转）
 参数4：动画时间
 参数5：重复次数
 */
-(void)xb_makeRotationFromAngle:(CGFloat)fromAngle toAngle:(CGFloat)toAngle k_keyPath_rotation:(NSString *)k_keyPath_rotation duration:(NSTimeInterval)duration repeatCount:(float)repeatCount;


/**
 旋转
 参数1：直接传数字，45度就传45（最大180）
 参数2：动画时间
 */
-(void)xb_makeRotationWithAngle:(CGFloat)angle duration:(NSTimeInterval)duration;

/**
 缩放
 参数1：x方向缩放倍数
 参数2：y方向缩放倍数
 参数3：动画时间
 */
-(void)xb_makeScaleWithX:(CGFloat)x y:(CGFloat)y duration:(NSTimeInterval)duration;

/**
 平移
 参数1：x方向移动的量
 参数2：y方向移动的量
 参数3：动画时间
 */
-(void)xb_makeTranslationWithX:(CGFloat)x y:(CGFloat)y duration:(NSTimeInterval)duration;
@end
