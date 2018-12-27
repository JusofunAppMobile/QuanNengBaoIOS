//
//  ForgetPasswordViewController.m
//  EnterpriseInquiry
//
//  Created by Ching on 15/11/19.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "AnimateLine.h"

#define Back_COLOR [UIColor colorWithRed:235.0/255.0 green:236/255.0 blue:238/255.0 alpha:1.0];

#define SIZE_SCALE  ([UIScreen mainScreen].bounds.size.width / 320.0)

@interface ForgetPasswordViewController ()<UITextFieldDelegate>
{
    UITextField    *_phoneNumberTF;
    UITextField    *_PasswordTF;
    UITextField    *_VerifCodeTF;
    NSInteger      _timeCount;
    NSTimer        *_timer;
    UIButton       *sureButton;
}

@property (nonatomic ,strong) AnimateLine *phoneLine;
@property (nonatomic ,strong) AnimateLine *codeLine;
@property (nonatomic ,strong) AnimateLine *pwdLine;
@end

@implementation ForgetPasswordViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"找回密码" ];
    [self setBackBtn:@"back"];
    
    self.view.backgroundColor = Back_COLOR;
    
    _timeCount = 60;
  
    [self layout];
}

- (void)sureBtnClick:(UIButton*)btn{
    
    [self.view endEditing:YES];
    int random = arc4random_uniform(8999)+1000;
    NSString *randomNumber = [NSString stringWithFormat:@"%d",random];
    NSString *encryption = [NSString stringWithFormat:@"%@%@%@",_phoneNumberTF.text,randomNumber,@"jiucifang"];
    
    [MBProgressHUD showMessag:@"" toView:self.view];
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:_phoneNumberTF.text forKey:@"phonenumber"];
    [paraDic setObject:randomNumber forKey:@"ran"];
    [paraDic setObject:[Tools md5:encryption] forKey:@"encryption"];
    [RequestManager getWithURLString:ForgetPWDGetCode parameters:paraDic success:^(id responseObject) {
        
        if ([responseObject[@"result"] integerValue] == 0) {
            
            [MBProgressHUD showHint:@"验证码已发送" toView:self.view];
            btn.userInteractionEnabled = NO;
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerInterval) userInfo:nil repeats:NO];
        }else{
            
            [MBProgressHUD showHint:responseObject[@"msg"] toView:self.view];
            btn.userInteractionEnabled = YES;
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showHint:@"网络错误，请稍后重试！" toView:self.view];
    }];
}
- (void)CompleteRegistrationClick
{
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:_phoneNumberTF.text forKey:@"phonenumber"];
    [paraDic setObject:_VerifCodeTF.text forKey:@"verifcode"];
    [paraDic setObject:[Tools md5:_PasswordTF.text] forKey:@"password"];
    [MBProgressHUD showMessag:@"" toView:self.view];
    [RequestManager postWithURLString:ForgetPWDAndUpdate parameters:paraDic success:^(id responseObject) {
        
        if ([responseObject[@"result"] integerValue]== 0) {
            [MBProgressHUD showHint:@"密码找回成功" toView:self.view];
            [self performSelector:@selector(back) withObject:nil afterDelay:1];
        }else{
            [MBProgressHUD showHint:responseObject[@"msg"] toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showHint:@"网络错误，请稍后重试！" toView:self.view];
    }];
}

-(void)back{
    
    if(_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 获取验证码
//倒计时
-(void)timerInterval {
    if (_timeCount == 0) {
        [self initializeTimer];
    } else {
        
        [sureButton setTitle:[NSString stringWithFormat:@"%ld秒",(long)_timeCount] forState:UIControlStateNormal];
        _timeCount--;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerInterval) userInfo:nil repeats:NO];
    }
}

//初始化计时相关
-(void)initializeTimer {
    [_timer invalidate];
    _timer = nil;
    sureButton.userInteractionEnabled = YES;
    [sureButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    _timeCount = 60;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if ([textField isEqual:_phoneNumberTF]) {
        [_phoneLine show:YES];
    }else if ([textField isEqual:_VerifCodeTF]){
        [_codeLine show:YES];
    }else{
        [_pwdLine show:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField isEqual:_phoneNumberTF]) {
        [_phoneLine hide:YES];
    }else if ([textField isEqual:_VerifCodeTF]){
        [_codeLine hide:YES];
    }else{
        [_pwdLine hide:YES];
    }
}

-(void)layout
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,KNavigationBarHeight,KDeviceW,KDeviceH-KNavigationBarHeight)];
    scrollView.contentSize  = CGSizeMake(KDeviceW, KDeviceH-KNavigationBarHeight+1);
    scrollView.backgroundColor  = [UIColor whiteColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    UIImageView *phoneImgV = [[UIImageView alloc] initWithFrame:KFrame(30, 45, 22/2, 34/2)];
    phoneImgV.image = [UIImage imageNamed:@"注册手机icon"];
    [scrollView addSubview:phoneImgV];
    
    _phoneNumberTF = [[UITextField alloc]init];
    _phoneNumberTF.placeholder = @"请输入手机号";
    _phoneNumberTF.font=[UIFont systemFontOfSize:16];
    _phoneNumberTF.delegate = self;
    _phoneNumberTF.textColor = KHexRGB(0x333333);
    _phoneNumberTF.backgroundColor = [UIColor clearColor];
    _phoneNumberTF.frame = CGRectMake(phoneImgV.maxX+10,phoneImgV.y - 15, KDeviceW-phoneImgV.maxX*2 - 20, 50);
    [scrollView addSubview:_phoneNumberTF];
    
    
    
    UIView *grayLine1 = [[UIView alloc]initWithFrame:CGRectMake(phoneImgV.x, _phoneNumberTF.maxY, KDeviceW-phoneImgV.x*2, 1)];
    grayLine1.backgroundColor = KHexRGB(0xf2f2f2);
    [scrollView addSubview:grayLine1];
    
    _phoneLine = [[AnimateLine alloc]initWithFrame:CGRectMake(phoneImgV.x, _phoneNumberTF.maxY, KDeviceW-phoneImgV.x*2, 2)];
    _phoneLine.image = KImageName(@"渐变线条");
    [scrollView addSubview:_phoneLine];
    [_phoneLine hide:NO];
    
    
    UIImageView *VercodeImgV = [[UIImageView alloc] initWithFrame:KFrame(phoneImgV.x, _phoneLine.maxY + 35, 28/2, 32/2)];
    VercodeImgV.image = [UIImage imageNamed:@"验证码icon"];
    [scrollView addSubview:VercodeImgV];
    
    _VerifCodeTF = [[UITextField alloc]init];
    _VerifCodeTF.font=[UIFont systemFontOfSize:16];
    _VerifCodeTF.placeholder = @"请输入验证码";
    _VerifCodeTF.delegate = self;
    _VerifCodeTF.backgroundColor = [UIColor clearColor];
    _VerifCodeTF.textColor = KHexRGB(0x333333);
    _VerifCodeTF.frame = CGRectMake(VercodeImgV.maxX +10,VercodeImgV.y-15, KDeviceW-VercodeImgV.maxX *2 -10 - 100, 50);
    [scrollView addSubview:_VerifCodeTF];
    
    
    
    sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(KDeviceW -92.5-30, _VerifCodeTF.y + 10, 92.5,  30);
    sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [sureButton setTitleColor:KHexRGB(0xffffff) forState:UIControlStateNormal];
    [sureButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    sureButton.layer.masksToBounds = YES;
    sureButton.layer.cornerRadius = 15;

    sureButton.backgroundColor = KHexRGB(0x458EF8);

    [sureButton addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:sureButton];
    
    
    UIImageView *grayLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(phoneImgV.x, _VerifCodeTF.maxY, KDeviceW-phoneImgV.x*2, 1)];
    grayLine2.backgroundColor = KHexRGB(0xf2f2f2);
    [scrollView addSubview:grayLine2];
    
    _codeLine = [[AnimateLine alloc]initWithFrame:CGRectMake(phoneImgV.x, _VerifCodeTF.maxY, KDeviceW-phoneImgV.x*2, 2)];
    _codeLine.image = KImageName(@"渐变线条");
    [scrollView addSubview:_codeLine];
    [_codeLine hide:NO];
    
    
    UIImageView *passImageView =[[UIImageView alloc]initWithFrame:KFrame(phoneImgV.x, grayLine2.maxY + 35, 22/2, 34/2)];
    passImageView.image = [UIImage imageNamed:@"密码"];
    [scrollView addSubview:passImageView];

    _PasswordTF = [[UITextField alloc]init];
    _PasswordTF.placeholder = @"请输入新的密码";
    _PasswordTF.font=[UIFont systemFontOfSize:16];
    _PasswordTF.delegate = self;
    _PasswordTF.textColor = KHexRGB(0x333333);
    _PasswordTF.backgroundColor = [UIColor clearColor];
    _PasswordTF.frame = CGRectMake(phoneImgV.maxX+10,passImageView.y - 15, KDeviceW-phoneImgV.maxX*2 - 20, 50);
    [scrollView addSubview:_PasswordTF];



    UIView *grayLine3 = [[UIView alloc]initWithFrame:CGRectMake(phoneImgV.x, _PasswordTF.maxY, KDeviceW-phoneImgV.x*2, 1)];
    grayLine3.backgroundColor = KHexRGB(0xf2f2f2);
    [scrollView addSubview:grayLine3];

    _pwdLine = [[AnimateLine alloc]initWithFrame:CGRectMake(phoneImgV.x, _PasswordTF.maxY, KDeviceW-phoneImgV.x*2, 2)];
    _pwdLine.image = KImageName(@"渐变线条");
    [scrollView addSubview:_pwdLine];
    [_pwdLine hide:NO];



    UIButton*submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(phoneImgV.x, CGRectGetMaxY(grayLine3.frame)+50, KDeviceW-phoneImgV.x*2,  40);
    [submitButton setTitle:@"确认" forState:UIControlStateNormal];
    [submitButton setBackgroundImage:KImageName(@"圆角渐变") forState: UIControlStateNormal];
    submitButton.layer.masksToBounds = YES;
    submitButton.layer.cornerRadius = 40/2;
    submitButton.titleLabel.font = KFont(18);
    [submitButton addTarget:self action:@selector(CompleteRegistrationClick) forControlEvents:UIControlEventTouchUpInside];
    [submitButton setTitleColor:KHexRGB(0xffffff) forState:UIControlStateNormal];
    [scrollView addSubview:submitButton];


    scrollView.contentSize = CGSizeMake(0, submitButton.maxY + 100);

}



-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar fs_setBackgroundColor:KHomeNavigationBarBackGroundColor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
