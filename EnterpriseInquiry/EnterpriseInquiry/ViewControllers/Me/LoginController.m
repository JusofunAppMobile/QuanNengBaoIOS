//
//  LoginController.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 2018/1/4.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import "LoginController.h"

@interface LoginController ()
{
    UIScrollView *backScrollView;
   // UIImageView *loginImageView;
    UITextField *nameTextFld;
    UITextField *passwordTextFld;
    
    UIButton *forgetBtn;
    UIButton *registBtn;
    UIButton *loginBtn;
    UIButton *wechatBtn;
    UIButton *weiboBtn;
    
    UIButton *secureBtn;
}
@property (nonatomic ,strong) AnimateLine *phoneLine;
@property (nonatomic ,strong) AnimateLine *codeLine;
@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setView];
    
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 120;
    
    
}


#define mark - 登录请求
- (void)loginWithDictionary:(NSDictionary*)parameter
{
    KWeakSelf;
    [MBProgressHUD showMessag:@"" toView:self.view];
    [RequestManager postWithURLString:LOGIN_POST parameters:parameter success:^(id responseObject) {
        NSLog(@"登录信息 === %@",responseObject);
        [MBProgressHUD hideHudToView:self.view animated:NO];
        if ([responseObject[@"result"] integerValue] == 0) {
            
            [User clearTable];
            User *model = [User mj_objectWithKeyValues:[responseObject objectForKey:@"userinfo"]];
            [model save];
            [MBProgressHUD showSuccess:@"登录成功" toView:nil];
            //登录成功 发送一下登录成功的通知
            
            if(weakSelf.loginSuccessBlock)
            {
               [weakSelf.navigationController popViewControllerAnimated:YES];
                weakSelf.loginSuccessBlock();
            }
            else
            {
               // [weakSelf beginAnimationWithIsUp:YES];
                
                [KNotificationCenter postNotificationName:LOGIN_SUCCESS_NOTIFICATION object:nil];
            }
            
            
        }else{
            [MBProgressHUD showHint:responseObject[@"msg"] toView:self.view];
            
            
        }
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD showHint:@"登录失败" toView:self.view];
    }];
    
}

#pragma mark - 登录
-(void)loginBtnClick:(UIButton*)button
{

    [self.view endEditing:YES];
    if( button == wechatBtn) {
        
        [self otherLogin:WeChatLogin PlatformType:SSDKPlatformTypeWechat];
    }
    else if( button == weiboBtn)
    {
        [self otherLogin:WeiboLogin PlatformType:SSDKPlatformTypeSinaWeibo];
    }
    else
    {
        if(nameTextFld.text.length == 0)
        {
            [MBProgressHUD showError:@"请填入用户名" toView:self.view];
            return;
        }
        if(passwordTextFld.text.length == 0)
        {
            [MBProgressHUD showError:@"请填入密码" toView:self.view];
            return;
        }
        
        NSDictionary *dict = @{
                               @"phonenumber":nameTextFld.text,
                               @"password":[Tools md5:passwordTextFld.text],
                               @"logintype":@"0",
                               
                               };
        [self loginWithDictionary:dict];
    }
    
}
#pragma mark - 第三方获取信息
-(void)otherLogin:(OtherLoginType)type
     PlatformType:(SSDKPlatformType)PlatformType
{
    
    [ShareSDK getUserInfo:PlatformType onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        
        if (state == SSDKResponseStateSuccess)
        {
            
            NSLog(@"uid=%@",user.uid);
            NSLog(@"%@",user.credential);
            NSLog(@"token=%@",user.credential.token);
            NSLog(@"nickname=%@",user.nickname);
            
            if (type == WeChatLogin) {
                
                NSDictionary *dic = user.rawData;
    
                NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
                NSString *push_id = [KUserDefaults objectForKey:KPushID];
                [parameter setObject:@"" forKey:@"phonenumber"];
                [parameter setObject:@"" forKey:@"password"];
                [parameter setObject:user.uid forKey:@"thirdtoken"];
                [parameter setObject:@"1" forKey:@"logintype"];
                [parameter setObject:push_id?push_id:@"" forKey:@"pushid"];
                [parameter setObject:user.nickname forKey:@"nickname"];
                [parameter setObject:user.icon forKey:@"photo"];
                [parameter setObject:dic[@"unionid"] forKey:@"unionid"];
                [self loginWithDictionary:parameter];
            }
            
            if (type == WeiboLogin){
                
                NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
                NSString *push_id = [KUserDefaults objectForKey:KPushID];
                [parameter setObject:@"" forKey:@"phonenumber"];
                [parameter setObject:@"" forKey:@"password"];
                [parameter setObject:user.uid forKey:@"thirdtoken"];
                [parameter setObject:@"1" forKey:@"logintype"];
                [parameter setObject:push_id?push_id:@"" forKey:@"pushid"];
                [parameter setObject:user.nickname forKey:@"nickname"];
                [parameter setObject:user.icon forKey:@"photo"];
                [parameter setObject:@"" forKey:@"unionid"];
                
                [self loginWithDictionary:parameter];
            }
            
        }
        else
        {
            NSLog(@"%@",error);
        }
        
    }];
}



#pragma mark - 注册
-(void)registe
{
    RegisteredViewController *registVC = [[RegisteredViewController alloc]init];
    [registVC bindingPhoneNumber:NO];
    [self.navigationController pushViewController:registVC animated:YES];
}

#pragma mark - 忘记密码
-(void)forgetPassClick
{
    ForgetPasswordViewController *forgetVC = [[ForgetPasswordViewController alloc]init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}

-(void)setLoginSuccessBlock:(LoginSuccessBlock)loginSuccessBlock
{
    _loginSuccessBlock = loginSuccessBlock;
    [self setBackBtn:@"whiteBack"];
}
#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if ([textField isEqual:nameTextFld]) {
        [_phoneLine show:YES];
    }else{
        [_codeLine show:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if ([textField isEqual:nameTextFld]) {
        [_phoneLine hide:YES];
    }else{
        [_codeLine hide:YES];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if(textField == passwordTextFld && textField.text.length >0)
    {
        [self loginBtnClick:loginBtn];
    }
    
    return YES;
}

-(void)secure:(UIButton*)button
{
    button.selected = !button.selected;
    passwordTextFld.secureTextEntry = !button.selected;
}

#pragma mark - 绘制页面
-(void)setView
{
    
    CGFloat scrolly = - KNavigationBarHeight;

    if(@available(iOS 11.0, *))
    {
        scrolly = 0;
    }
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:KFrame(0, scrolly, KDeviceW, KDeviceH - scrolly)];
    backImageView.image = KImageName(@"登录页");
    backImageView.userInteractionEnabled = YES;
    [self.view addSubview:backImageView];
    
    backScrollView = [[UIScrollView alloc]initWithFrame:KFrame(0, scrolly, KDeviceW, KDeviceH)];
    backScrollView.backgroundColor = [UIColor clearColor];
    backScrollView.scrollEnabled = NO;
    [self.view addSubview:backScrollView];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 57.5, 57.5)];
    logoImageView.image = [UIImage imageNamed:@"helpLogo"];
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    logoImageView.center = CGPointMake( KDeviceW/2,(KNavigationBarHeight +50) );
    [backScrollView addSubview:logoImageView];
   
    
    UIView *backView = [[UIView alloc]initWithFrame:KFrame(15, logoImageView.maxY +40, KDeviceW - 30, 200)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 5;
    backView.clipsToBounds = YES;
    [backScrollView addSubview:backView];
    
    
    UIImageView *nameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 40, 23, 23)];
    nameImageView.image = [UIImage imageNamed:@"账户icon"];
    nameImageView.contentMode = UIViewContentModeScaleAspectFit;
    [backView addSubview:nameImageView];

    UIView *shuView = [[UIView alloc]initWithFrame:KFrame(nameImageView.maxX +10, nameImageView.y +2,1, nameImageView.height - 4)];
    shuView.backgroundColor = KRGB(137, 184, 252);
    [backView addSubview:shuView];

    nameTextFld = [[UITextField alloc]initWithFrame:KFrame(shuView.maxX +15, nameImageView.y, backView.width - shuView.maxX-30, nameImageView.height)];
    nameTextFld.placeholder = @"请输入您的帐号";
    nameTextFld.delegate = self;
    [backView addSubview:nameTextFld];


    UIView *hengView = [[UIView alloc]initWithFrame:KFrame(nameImageView.x, nameImageView.maxY +5,backView.width - 2*nameImageView.x, 1)];
    hengView.backgroundColor = KHexRGB(0xf2f2f2);
    [backView addSubview:hengView];
    
    _phoneLine = [[AnimateLine alloc]initWithFrame:KFrame(nameImageView.x, nameImageView.maxY +5,backView.width - 2*nameImageView.x, 2)];
    _phoneLine.image = KImageName(@"渐变线条");
    [backView addSubview:_phoneLine];
    [_phoneLine hide:NO];//隐藏
    

    UIImageView *passImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, nameImageView.maxY + 40, 23, 23)];
    passImageView.image = [UIImage imageNamed:@"密码"];
    passImageView.contentMode = UIViewContentModeScaleAspectFit;
    [backView addSubview:passImageView];
    
    UIView *shuView2 = [[UIView alloc]initWithFrame:KFrame(passImageView.maxX +10, passImageView.y +2,1, passImageView.height - 4)];
    shuView2.backgroundColor = KRGB(137, 184, 252);
    [backView addSubview:shuView2];
    
    
   
    UIView *hengView2 = [[UIView alloc]initWithFrame:KFrame(passImageView.x, passImageView.maxY +5,backView.width - 2*passImageView.x, 1)];
    hengView2.backgroundColor = KHexRGB(0xf2f2f2);
    [backView addSubview:hengView2];
    
    secureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    secureBtn.frame = CGRectMake(hengView2.maxX -25,hengView2.y - 30, 20, 20);
    [secureBtn setImage:KImageName(@"隐藏")  forState:UIControlStateNormal];
    [secureBtn setImage:KImageName(@"Eyeicon") forState:UIControlStateSelected];
    [secureBtn addTarget:self action:@selector(secure:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:secureBtn];
    
    passwordTextFld = [[UITextField alloc]initWithFrame:KFrame(nameTextFld.x, passImageView.y, nameTextFld.width -2  - secureBtn.width - 20, nameTextFld.height)];
    passwordTextFld.secureTextEntry = YES;
    passwordTextFld.delegate = self;
    passwordTextFld.placeholder = @"请输入您的密码";
    //passwordTextFld.backgroundColor = KRGBA(200, 100, 100, 0.5);;
    [backView addSubview:passwordTextFld];
    
    
    _codeLine = [[AnimateLine alloc]initWithFrame:KFrame(passImageView.x, passImageView.maxY +5,backView.width - 2*passImageView.x, 2)];
    _codeLine.image = KImageName(@"渐变线条");
    [backView addSubview:_codeLine];
    [_codeLine hide:NO];
    
    //忘记密码按钮
    forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.frame = CGRectMake(nameImageView.x  ,passwordTextFld.maxY + 15, 60, 22);;
    [forgetBtn setTitle:@"忘记密码" forState: UIControlStateNormal];
    forgetBtn.titleLabel.font = KFont(12);
    [forgetBtn setTitleColor:KRGB(127, 127, 127) forState: UIControlStateNormal];
    //forgetBtn.backgroundColor = [UIColor redColor];
    [forgetBtn addTarget:self action:@selector(forgetPassClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:forgetBtn];
    
    
    
    //注册按钮
    registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registBtn.frame = CGRectMake(KDeviceW - 40 - forgetBtn.width,forgetBtn.y, forgetBtn.width, forgetBtn.height);
    [registBtn setTitle:@"注册" forState: UIControlStateNormal];
    registBtn.titleLabel.font = KFont(12);
    [registBtn setTitleColor:KRGB(127, 127, 127) forState: UIControlStateNormal];
    //registBtn.backgroundColor = [UIColor blueColor];
    //registBtn.backgroundColor = [UIColor clearColor];
    [registBtn addTarget:self action:@selector(registe) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:registBtn];
    
    

    //登录按钮
    loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(45,backView.maxY - 22, KDeviceW - 90, 44);
    [loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.backgroundColor = KRGB(65, 211, 250);
    loginBtn.layer.cornerRadius = 44/2;
    [loginBtn.layer setMasksToBounds:YES];
    [backScrollView addSubview:loginBtn];
    
    
    wechatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    wechatBtn.frame = CGRectMake(KDeviceW/4 - 44/2,KDeviceH - 50 -44 , 44, 44);
    [wechatBtn setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
    [wechatBtn setImage:[UIImage imageNamed:@"微信点击"] forState:UIControlStateHighlighted];
    [wechatBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //[backScrollView addSubview:wechatBtn];
    
    weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weiboBtn.frame = CGRectMake(KDeviceW/2 + KDeviceW/4 - 44/2,wechatBtn.y, 44, 44);
    [weiboBtn setImage:[UIImage imageNamed:@"微博"] forState:UIControlStateNormal];
    [weiboBtn setImage:[UIImage imageNamed:@"微博点击"] forState:UIControlStateHighlighted];
    [weiboBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
   // [backScrollView addSubview:weiboBtn];
    
    UIView *midleLabel = [[UIView alloc]init];
    midleLabel.backgroundColor = KRGB(39, 223, 253);
    midleLabel.frame = CGRectMake(KDeviceW/2 , weiboBtn.y + 10 , 1, 25);
   // [backScrollView addSubview:midleLabel];
    
    backScrollView.contentSize = CGSizeMake(0, weiboBtn.maxY + 50);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
