//
//  VIPPrivilegeController.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/10/13.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "VIPPrivilegeController.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "CustomAlert.h"


@interface VIPPrivilegeController ()<UIWebViewDelegate>

@property (nonatomic ,strong) NSDictionary *payInfo;
@end

@implementation VIPPrivilegeController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setNavigationBarTitle:@"会员中心" ];
    [self setBackBtn:@"whiteBack"];
    
    //self.automaticallyAdjustsScrollViewInsets = NO;

    [self setWebView];
    [self loadURL];
    [self listenPayBackNoti];
}

- (void)loadURL{
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/Html/memberCenter.html?version=%@&apptype=1&userId=%@",HOSTURL,version,USER.userID]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)setWebView{
    
    CGFloat scrolly = 0;
    if(@available(iOS 11.0, *))
    {
        scrolly = -KNavigationBarHeight;
    }
    
    self.webView.frame = KFrame(0, scrolly, KDeviceW, KDeviceH - scrolly);;
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    
    NSString *urlStr = [request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"urlstr____%@",urlStr);
    if ([urlStr containsString:@"usercenter://upgradeVip"]) {
        [self showAgree];
        return NO;
    }
    if ([urlStr containsString:@"usercenter://renewVip"]) {
        
        [self showAlert];
        return NO;
    }
    
    return YES;
}

- (void)showAlert{
    KWeakSelf
    CustomAlert *alert = [[CustomAlert alloc]initWithTitle:@"您已是VIP包年用户，是否续费？" style:AlertStylePlain placeholder:nil cancelButtonTitle:@"取消" otherButtonTitle:@"确定" callBack:^(NSString *text) {
        [weakSelf showAgree];
    }];
    [alert showInView:self.view];
}


-(void)showAgree
{
    KBolckSelf;
    NSString *str = @"我已阅读知晓并同意《用户协议》";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
    
    [attrStr addAttribute:NSFontAttributeName value:KFont(16) range:NSMakeRange(0, str.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.41 green:0.41 blue:0.41 alpha:1.00] range:NSMakeRange(0, str.length - 6)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:KHexRGB(0xff6400) range:NSMakeRange(str.length - 6, 6)];
    CustomAlert *alert = [[CustomAlert alloc]initWithTitle:attrStr cancelButtonTitle:@"取消" otherButtonTitle:@"去申请" callBack:^(NSString *text) {
        [blockSelf upgradeVip];
        
    } contentCallBack:^{
        NSLog(@"点击");
        CommonWebViewController *commomwevView = [[CommonWebViewController alloc] init];
        commomwevView.titleStr = @"用户协议";
        commomwevView.urlStr = [NSString stringWithFormat:@"%@/Html/agreement.html",HOSTURL];
        [self.navigationController pushViewController:commomwevView animated:YES];
        
    }];
    [alert showInView:self.view];
}


#pragma mark - 微信支付
//升级vip
- (void)upgradeVip{
    NSString *str = [NSString stringWithFormat:@"%@?userId=%@",KGetAlipayOrder,USER.userID];
    KWeakSelf
    [RequestManager getHttpResponseWithURLString:str parameters:nil success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSData class]]) {
            NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            if (str) {
                [weakSelf alipay:str];
            }else{
                [MBProgressHUD showError:responseObject[@"msg"] toView:nil];
            }
        }
    } failure:^(NSError *error) {
    }];
}

//支付宝支付
- (void)alipay:(NSString *)orderStr{
    [[AlipaySDK defaultService] payOrder:orderStr fromScheme:@"com.jinshangmei.qxqnb" callback:^(NSDictionary *resultDic) {
    }];//wap支付回调
}

//- (void)wechatPay{
//    PayReq* req = [[PayReq alloc] init];
//    req.partnerId =payInfo[@"partnerId"];
//    req.prepayId = payInfo[@"prepayId"];
//    req.package = @"Sign=WXPay";
//    req.nonceStr = payInfo[@"nonceStr"];
//    req.timeStamp = [payInfo[@"timeStamp"] intValue];
//    req.sign = payInfo[@"sign"];
//    [WXApi sendReq:req];
//
//}

#pragma mark - 微信支付通知
//从后台切换进入app
- (void)listenAppState{
    [KNotificationCenter addObserver:self selector:@selector(checkPayResult) name:UIApplicationWillEnterForegroundNotification object:nil];
}
//支付完成
- (void)listenPayBackNoti{
    [KNotificationCenter addObserver:self selector:@selector(payDoneAction:) name:PAY_DONE_NOTI object:nil];
}
//不做检查，直接刷新h5
- (void)checkPayResult{
    [self.webView reload];
}

- (void)payDoneAction:(NSNotification *)noti{
    NSDictionary *dic = noti.userInfo;
    if ([dic[@"result"] intValue]) {
        [MBProgressHUD showSuccess:@"支付成功" toView:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [MBProgressHUD showError:@"支付失败" toView:nil];
    }
}
#pragma mark - 去除html转义符
- (NSString *)transHTMLToString:(NSString *)html{
     NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    return attrStr.string;
}

#pragma mark - life cycle
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[self.navigationController.navigationBar fs_setBackgroundColor:KHomeNavigationBarBackGroundColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar fs_setBackgroundColor:[UIColor clearColor]];

}


- (void)dealloc{
    [KNotificationCenter removeObserver:self];
}

@end
