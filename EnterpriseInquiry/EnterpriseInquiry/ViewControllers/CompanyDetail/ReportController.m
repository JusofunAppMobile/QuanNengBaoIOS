//
//  ReportController.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 2017/10/17.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "ReportController.h"

@interface ReportController ()

@end

@implementation ReportController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"企业报告" ];
    [self setBackBtn:@"back"];
    [self setNavigationbarButton];
    
    [self listenPayNoti];//监听支付状态
    
    [self setWebView];
    [self loadURL];
    
}
#pragma mark- 下载
-(void)dowm
{
    if([self.vipType intValue] == 1)
    {
        KBolckSelf;
        CustomAlert *alert = [[CustomAlert alloc]initWithTitle:@"发送至" style:1 placeholder:@"请输入报告接收邮箱" cancelButtonTitle:@"取消" otherButtonTitle:@"发送" callBack:^(NSString *text) {
            NSLog(@"%@",text);
            [blockSelf downReport:text];
        }];
        [alert showInView:self.view];
    }
    else
    {
        VIPPrivilegeController *vc = [[VIPPrivilegeController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


-(void)downReport:(NSString *)email
{
    if ([Tools isEmailAddress:email])
    {
        [MBProgressHUD showMessag:@"" toView:self.view];
        NSString *str = [NSString stringWithFormat:@"%@?entId=%@&userId=%@&entName=%@&email=%@",KSendReport,self.companyId,USER.userID,self.companyName,email];
        
        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [RequestManager postWithURLString:str parameters:nil success:^(id responseObject) {
            [MBProgressHUD hideHudToView:self.view animated:YES];
            if([[responseObject objectForKey:@"result"]intValue] == 0)
            {
                [MBProgressHUD showSuccess:@"发送成功" toView:self.view];
            }
            else
            {
                [MBProgressHUD showError:[responseObject objectForKey:@"msg"] toView:self.view];
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"请求失败" toView:self.view];
        }];    }
    else{
        [MBProgressHUD showError:@"请输入正确的邮箱" toView:self.view];
    }
}



- (void)loadURL{
    NSURL *url = [NSURL URLWithString:[self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)setWebView{
    self.webView.frame = KFrame(0, KNavigationBarHeight, KDeviceW, KDeviceH-KNavigationBarHeight);
}

#pragma mark- 绘制导航栏按钮
-(void)setNavigationbarButton
{
    UIButton *buttonRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonRight setTitle:@"下载" forState:UIControlStateNormal];
    buttonRight.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    buttonRight.titleLabel.textAlignment = NSTextAlignmentRight;
    buttonRight.frame = CGRectMake(0, 0, 50, 22);
    [buttonRight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    buttonRight.titleLabel.font = KNormalFont;
    [buttonRight addTarget:self action:@selector(dowm) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - 支付成功回调
- (void)listenPayNoti{//添加通知
    [KNotificationCenter addObserver:self selector:@selector(payDoneAction:) name:PAY_DONE_NOTI object:nil];
}

- (void)payDoneAction:(NSNotification *)noti{
    NSDictionary *dic = noti.userInfo;
    if ([dic[@"result"] intValue]) {//支付成功刷新个人信息
        [self reloadUserInfo];
    }
}

- (void)reloadUserInfo{
   // [USER gotUserinfo];
    
    [KNotificationCenter postNotificationName:KReloadUserInfo object:nil];
}

#pragma mark - lift cycle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar fs_setBackgroundColor:KHomeNavigationBarBackGroundColor];
}

- (void)dealloc{
    [KNotificationCenter removeObserver:self];
}



@end
