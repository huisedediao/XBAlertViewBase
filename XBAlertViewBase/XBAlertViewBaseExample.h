-(XBAlertViewBase *)alertView
{
    if (_alertView==nil)
    {
        _alertView=[[XBAlertViewBase alloc] initWithDisplayView:[[UIApplication sharedApplication].delegate window]];
        _alertView.backgroundViewColor=[UIColor clearColor];
        
        [_alertView setShowLayoutBlock:^(XBAlertViewBase *alertView) {
            //            [alertView mas_remakeConstraints:^(MASConstraintMaker *make) {
            //                make.top.equalTo(alertView.superview).offset(20);
            //                make.leading.equalTo(alertView.superview);
            //                make.trailing.equalTo(alertView.superview);
            //                make.height.equalTo(@200);
            //            }];
            alertView.frame=CGRectMake(0, 20, 375, 200);
            alertView.alpha=1;
        }];
        
        [_alertView setHiddenLayoutBlock:^(XBAlertViewBase *alertView) {
            //            [alertView mas_remakeConstraints:^(MASConstraintMaker *make) {
            //                make.top.equalTo(alertView.superview).offset(0);
            //                make.leading.equalTo(alertView.superview).offset(20);
            //                make.trailing.equalTo(alertView.superview).offset(20);
            //                make.height.equalTo(@150);
            //            }];
            alertView.frame=CGRectMake(20, 20, 300, 150);
            alertView.alpha=0;
        }];
        
        //        UILabel *label1=[UILabel new];
        //        [_alertView addSubview:label1];
        //        label1.text=@"取消";
        //        label1.backgroundColor=[UIColor redColor];
        //        label1.textAlignment=NSTextAlignmentCenter;
        
        //        UIView *label1=[UIView new];
        XBButton *label1=[XBButton new];
        label1.textNormal=STR(@"取消");
        [_alertView addSubview:label1];
        label1.backgroundColor=[UIColor redColor];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_alertView);
            make.leading.equalTo(_alertView);
            make.trailing.equalTo(_alertView);
            make.bottom.equalTo(_alertView.mas_centerY).multipliedBy(0.5);
        }];
        
        
        
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_alertView addSubview:btn];
        btn.backgroundColor=[UIColor greenColor];
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label1.mas_bottom);
            make.leading.equalTo(_alertView);
            make.trailing.equalTo(_alertView);
            make.bottom.equalTo(_alertView);
        }];
    }
    return _alertView;
}

- (IBAction)show:(id)sender {
    [self.bottomMenu show];
}
