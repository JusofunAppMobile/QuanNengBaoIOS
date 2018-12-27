//
//  AdviceViewController.m
//  EnterpriseInquiry
//
//  Created by clj on 16/8/12.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "AdviceViewController.h"
#import "PlacherTextView.h"
#import "IQKeyboardManager.h"

@implementation AdviceViewController
{
    PlacherTextView *_adviceTextView;
    UIScrollView *_mainScrollView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar fs_setBackgroundColor:KHomeNavigationBarBackGroundColor];
}



-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationBarTitle:@"意见反馈" ];
    [self setBackBtn:@"back"];
    //self.automaticallyAdjustsScrollViewInsets = NO;
//    [self setNavigationBarTitle:@"意见反馈"];
    [self makeNavigationbarButton];//绘制导航栏按钮

    [IQKeyboardManager sharedManager].enable = YES;
    //绘制页面
    [self layoutAdviceViews];
}

#pragma mark - 提交意见
-(void)sendAdvice
{
    [self.view endEditing:YES];
    NSLog(@"提交意见");
    if (_adviceTextView.text.length == 0) {
        [MBProgressHUD showError:@"请输入您的建议" toView:self.view];
        return;
    }
    
    [MBProgressHUD showMessag:@"" toView:self.view];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:USER.userID forKey:@"userid"];
    [parameter setObject:_adviceTextView.text forKey:@"content"];
    [parameter setObject:USER.mobile forKey:@"phone"];
    [parameter setObject:@"1" forKey:@"Type"];//1.意见反馈  2.人工协助查询

    [RequestManager postWithURLString:InSuggestion parameters:parameter success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        // 请求成功
        if ([responseObject[@"result"] integerValue] == 0) {
            [MBProgressHUD showSuccess:@"反馈成功" toView:self.view];
           // [self.navigationController popViewControllerAnimated:YES];
            [self performSelector:@selector(back) withObject:nil afterDelay:2];
        }else
        {
//            [MBProgressHUD showSuccess:responseObject[@"msg"] toView:self.view];
            [MBProgressHUD showError:responseObject[@"msg"] toView:self.view];
        }
    } failure:^(NSError *error) {
//        [MBProgressHUD showSuccess:@"反馈失败" toView:self.view];
        [MBProgressHUD showError:@"反馈失败" toView:self.view];
    }];
    
}
//返回
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark- 绘制导航栏按钮
-(void)makeNavigationbarButton
{

    
    UIButton *buttonRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonRight setTitle:@"提交" forState:UIControlStateNormal];
    buttonRight.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    buttonRight.titleLabel.textAlignment = NSTextAlignmentRight;
    buttonRight.frame = CGRectMake(0, 0, 50, 22);
    [buttonRight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    buttonRight.titleLabel.font = KNormalFont;
    [buttonRight addTarget:self action:@selector(sendAdvice) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    self.navigationItem.rightBarButtonItem = rightItem;
}


//绘制页面
-(void)layoutAdviceViews
{
    
    _mainScrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0,0, KDeviceW, KDeviceH - KNavigationBarHeight)];
    _mainScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_mainScrollView];
    
    UIView *narNearLineView = [self createLineViewWithFrame:CGRectMake(0, KNavigationBarHeight, KDeviceW, 1)];
    [_mainScrollView addSubview:narNearLineView];
    
    
    UIView *adViewTopLineView = [self createLineViewWithFrame:CGRectMake(0, KNavigationBarHeight + 10, KDeviceW, 1)];
    [_mainScrollView addSubview:adViewTopLineView];
    
    UIView *adviceView = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(adViewTopLineView.frame), KDeviceW,  240)];
    adviceView.backgroundColor = [UIColor whiteColor];
    
    
    _adviceTextView = [[PlacherTextView alloc] initWithFrame:CGRectMake(10,8, KDeviceW-20 , 230) withIsCustomPlaceFrame:YES andPlaceFrame:CGRectMake(0,5,  KDeviceW - 20,0)];
    _adviceTextView.placeholder = @"请输入你的建议";
    _adviceTextView.placeholderColor = KHexRGB(0x999999);
    _adviceTextView.placeHolderLabel.font = [UIFont fontWithName:FontName size:16];
    _adviceTextView.font = [UIFont fontWithName:FontName size:16];
    _adviceTextView.placeHolderLabel.frame = CGRectMake(0, 0, _adviceTextView.bounds.size.width, _adviceTextView.frame.size.height);
    [adviceView addSubview:_adviceTextView];
    [_mainScrollView addSubview:adviceView];
    
    UIView *bottomLineView = [self createLineViewWithFrame:CGRectMake(0, CGRectGetMaxY(adviceView.frame), KDeviceW, 1)];
    [_mainScrollView addSubview:bottomLineView];
}


-(UIView *)createLineViewWithFrame:(CGRect)frame
{
    UIView *lineView = [[UIView alloc] initWithFrame:frame];
    lineView.backgroundColor = KHexRGB(0xDADADA);
    return lineView;
}



@end
