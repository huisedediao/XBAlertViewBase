# XBAlertViewBase
弹出框基类，帮助你快速集成自定义弹出菜单<br/><br/>

### 使用方法：<br/>
继承XBAlertViewBase，重写init方法或者actionBeforeShow方法即可<br/><br/>
### 参考例子：<br/>
- 底部弹出菜单：[XBActionSheet](https://github.com/huisedediao/XBActionSheet) <br/>
- 提示框：[XBAlertView](https://github.com/huisedediao/XBAlertView) <br/>
<br/><br/>

## 基本使用：<br/>
1.initWithDisplayView: 方法，设置展示在哪个view上<br/>
2.在showLayoutBlock和hiddenLayoutBlock中设置展示和隐藏时的位置<br/>
3.调用show或者hidden方法进行展示或者隐藏<br/><br/><br/>
### 效果图：<br/><br/>
![image](https://github.com/huisedediao/XBAlertViewBase/raw/master/show.png)
<br/><br/><br/><br/>
### 示例代码:
<pre>
#import "ViewController.h"
#import "XBAlertViewBase.h"
#import "Masonry.h"

@interface ViewController ()
{
    XBAlertViewBase *xbBaseV;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAK_SELF
    
    xbBaseV=[[XBAlertViewBase alloc] initWithDisplayView:self.view];
    //淡入淡出效果
    xbBaseV.fadeInFadeOut=YES;
    
    //显示布局block，在里面设置frame或者约束
    xbBaseV.showLayoutBlock=^(XBAlertViewBase *alertView){
        //可以添加约束，也可以设置frame
//        alertView.frame=CGRectMake(250, 60, ScreenWidth-250-10, 100);
        
        //为了减少依赖，XBAlertViewBase并没有包含masonry，这里用remake，重做约束
        [alertView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view).mas_offset(60);
            make.leading.equalTo(weakSelf.view).mas_offset(250);
            make.trailing.equalTo(weakSelf.view).mas_offset(-10);
            make.height.mas_equalTo(100);
        }];
    };
    
    //隐藏时的布局的block，在里面设置frame或者约束
    xbBaseV.hiddenLayoutBlock=^(XBAlertViewBase *alertView){
        //可以添加约束，也可以设置frame
//        alertView.frame=CGRectMake(250, 60, 0, 0);
        [alertView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view).mas_offset(60);
            make.leading.equalTo(weakSelf.view).mas_offset(250);
            make.trailing.equalTo(weakSelf.view).mas_offset(-50);
            make.height.mas_equalTo(10);
        }];
    };
}

- (IBAction)showBtnClick:(id)sender {
    [xbBaseV show];
}

@end

</pre>