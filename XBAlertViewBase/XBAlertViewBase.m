
#import "XBAlertViewBase.h"
#import "UIView+AdaptKeyboard.h"

#define XBWeakSelf __weak __typeof(&*self)xbWeakSelf = self;
#define KDisplayViewDidableTime (0.5)

@interface XBAlertViewBase ()

@end

@implementation XBAlertViewBase

+(XBAlertViewBase *)alertMenuWithDisplayView:(id)displayView
{
    XBAlertViewBase *alertMenu=[[XBAlertViewBase alloc] initWithDisplayView:displayView];
    return alertMenu;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor=[UIColor whiteColor];
        self.hidden=YES;
        self.animating=YES;
        self.duration=0.3;
        self.hideWhileTouchOtherArea=YES;
        self.backgroundViewFadeInFadeOut=YES;
    }
    return self;
}

-(id)initWithDisplayView:(id)displayView
{
    if (self=[self init])
    {
        self.displayView=displayView;
    }
    return self;
}

-(void)dealloc
{
    if (self.needAdaptKeyboard)
    {
        [self removeNotice];
    }
    NSLog(@"XBAlertViewBase释放了");
}

-(void)setNeedAdaptKeyboard:(BOOL)needAdaptKeyboard
{
    if (needAdaptKeyboard == _needAdaptKeyboard)
    {
        return;
    }
    _needAdaptKeyboard=needAdaptKeyboard;
    
    if (needAdaptKeyboard)
    {
        [self addNotice];
    }
    else
    {
        [self removeNotice];
    }
}

-(void)addNotice
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)removeNotice
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark - 键盘相关
-(void)keyboardWillShow:(NSNotification *)noti
{
    if (self.isShowState == NO)
    {
        return;
    }
    
    if (self.isShowKeyboard)
    {
        return;
    }
    _isShowKeyboard=YES;
    [self xb_adaptKeyBoardForShowWithDisplayView:self.displayView notification:noti];
}
-(void)keyboardWillHide:(NSNotification *)noti
{
    if (self.isShowState == NO)
    {
        return;
    }
    _isShowKeyboard=NO;
    [self xb_adaptKeyBoardForHideWithDisplayView:self.displayView];
}

-(void)setDisplayView:(id)displayView
{
    _displayView=displayView;
    
    _isShowState=NO;
    self.backgroundView=[[UIView alloc] initWithFrame:CGRectMake(-2500, -2500, 10000, 10000)];
    [displayView addSubview:self.backgroundView];
    [displayView addSubview:self];
    self.backgroundView.backgroundColor=self.backgroundViewColor?self.backgroundViewColor:[[UIColor blackColor] colorWithAlphaComponent:0.8];
    self.backgroundView.hidden=YES;
    [self.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBackgroundView:)]];
}


-(void)clickBackgroundView:(UITapGestureRecognizer *)tap
{
    [self endEditing:YES];
    if (self.touchBlock)
    {
        XBWeakSelf
        self.touchBlock(xbWeakSelf);
    }
    
    if (self.hideWhileTouchOtherArea) {
        [self hidden];
    }
}


-(void)setBackgroundViewColor:(UIColor *)backgroundViewColor
{
    _backgroundViewColor=backgroundViewColor;
    self.backgroundView.backgroundColor=backgroundViewColor;
}

- (void)actionBeforeShow
{
    
}

- (void)controlDisplayViewUserInteractionEnabled
{
    self.displayView.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(KDisplayViewDidableTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.displayView.userInteractionEnabled = YES;
    });
}

-(void)show
{
    if (_isShowState == NO)
    {
        NSLog(@"AlertViewBase_show");
        [self controlDisplayViewUserInteractionEnabled];
        [self fixSuperView];
        [self actionBeforeShow];
        [self setInitLayout];
        
        self.backgroundView.hidden=NO;
        self.hidden=NO;
        
        if (self.animating)
        {
            [UIView animateWithDuration:self.duration animations:^{
                [self sameDemoOfShow];
            }];
        }
        else
        {
            [self sameDemoOfShow];
        }
        _isShowState=YES;
    }
}
-(void)sameDemoOfShow
{
    //设置淡入淡出效果
    if (self.isFadeInFadeOut==YES)
    {
        self.alpha=1;
    }
    
    //黑色半透明背景淡入淡出效果
    if (self.isBackgroundViewFadeInFadeOut==YES)
    {
        self.backgroundView.alpha=1;
    }
    
    if (self.showLayoutBlock)
    {
        XBWeakSelf
        self.showLayoutBlock(xbWeakSelf);
    }
    else if ([self.layoutDelegate respondsToSelector:@selector(alertViewBaseSetConstraintOrFrameForShow:)])
    {
        //代理设置约束或者frame
        [self.layoutDelegate alertViewBaseSetConstraintOrFrameForShow:self];
    }
    else
    {
        self.frame=self.showFrame;
    }
    [self.superview layoutIfNeeded];
}

- (void)fixSuperView
{
    if (self.superview == nil)
    {
        [self.displayView addSubview:self.backgroundView];
        [self.displayView addSubview:self];
    }
}

-(void)hidden
{
    if (_isShowState)
    {
        NSLog(@"AlertViewBase_hidden");
        [self fixSuperView];
        [self controlDisplayViewUserInteractionEnabled];
        if(self.animating)
        {
            [UIView animateWithDuration:self.duration animations:^{
                [self setInitLayout];
            } completion:^(BOOL finished) {
                [self sameDemoOfHidden];
            }];
        }
        else
        {
            [self sameDemoOfHidden];
        }
        _isShowState=NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(KDisplayViewDidableTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
            [self.backgroundView removeFromSuperview];
        });
    }
}
//设置初始位置(隐藏时的位置)
-(void)setInitLayout
{
    //设置淡入淡出效果
    if (self.isFadeInFadeOut==YES)
    {
        self.alpha=0;
    }
    //黑色半透明背景淡入淡出效果
    if (self.isBackgroundViewFadeInFadeOut==YES)
    {
        self.backgroundView.alpha=0;
    }
    
    if (self.hiddenLayoutBlock)
    {
        XBWeakSelf
        self.hiddenLayoutBlock(xbWeakSelf);
    }
    else if ([self.layoutDelegate respondsToSelector:@selector(alertViewBaseSetConstraintOrFrameForHidden:)])
    {
        //代理设置约束或者frame
        [self.layoutDelegate alertViewBaseSetConstraintOrFrameForHidden:self];
    }
    else
    {
        self.frame=self.hiddenFrame;
    }
    [self.superview layoutIfNeeded];
    
}
-(void)sameDemoOfHidden
{
    self.hidden=YES;
    self.backgroundView.hidden=YES;
}
-(void)hiddenAfterSecond:(CGFloat)second
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hidden];
    });
}


+(void)showFor:(id)obj keyPath:(NSString *)keyPath;
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        XBAlertViewBase *alertView=[obj valueForKey:keyPath];
        [alertView show];
    });
}

+(void)showFor:(id)obj keyPath:(NSString *)keyPath afterSecond:(CGFloat)second
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        XBAlertViewBase *alertView=[obj valueForKey:keyPath];
        [alertView show];
    });
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
    if (self.touchBlock)
    {
        XBWeakSelf
        self.touchBlock(xbWeakSelf);
    }
}
@end
