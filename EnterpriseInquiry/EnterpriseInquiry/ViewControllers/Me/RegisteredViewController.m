
//
//  RegisteredViewController.m
//  EnterpriseInquiry
//
//  Created by Ching on 15/11/18.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import "RegisteredViewController.h"
//#import "EnterpriseInquiry-Swift.h"
//#import "DetailedInformationViewController.h"
#import "Verification.h"
#import "DetailInformationVC.h"
#import "AnimateLine.h"

#define Back_COLOR [UIColor colorWithRed:235.0/255.0 green:236/255.0 blue:238/255.0 alpha:1.0];

#define SIZE_SCALE  ([UIScreen mainScreen].bounds.size.width / 320.0)

@interface RegisteredViewController ()<UITextFieldDelegate>

@property (nonatomic ,strong) AnimateLine *phoneLine;
@property (nonatomic ,strong) AnimateLine *codeLine;

@end

@implementation RegisteredViewController
{
    UITextField    *_phoneNumberTF;
    UITextField    *_VerificationCodeTF;
    UILabel        *_PromptLable;
    NSInteger      _timeCount;
    NSTimer        *_timer;
    UIButton       *_sureButton;
    UIButton       *CompleteRegistrationButton;
    UILabel        *juxinLable;
    UIButton       *backLoginBtn;
    BOOL           _isBeding;
}
-(instancetype)init{
    
    self = [super init];
    if (self) {
//        [self setBackBtn:@"back"];
        self.view.backgroundColor = [UIColor whiteColor];
        UIView *phoneBackView = [[UIView alloc]init];
        phoneBackView.backgroundColor = [UIColor whiteColor];
        phoneBackView.frame = CGRectMake(15, 50+KNavigationBarHeight, KDeviceW-30, 50);
        [self.view addSubview:phoneBackView];
        
//        UIImageView *phoneImgV = [[UIImageView alloc] initWithFrame:KFrame(15, 13, 43/2, 48/2)];
        UIImageView *phoneImgV = [[UIImageView alloc] initWithFrame:KFrame(15, 15, 22/2, 34/2)];
        phoneImgV.image = [UIImage imageNamed:@"注册手机icon"];
        [phoneBackView addSubview:phoneImgV];
        
        _phoneNumberTF = [[UITextField alloc]init];
        _phoneNumberTF.placeholder = @"输入手机号";
        _phoneNumberTF.font=[UIFont systemFontOfSize:16];
        _phoneNumberTF.delegate = self;
        _phoneNumberTF.textColor = KHexRGB(0x333333);
        _phoneNumberTF.backgroundColor = [UIColor clearColor];
//        _phoneNumberTF.textColor = KHexRGB(0xcccccc);
        _phoneNumberTF.frame = CGRectMake(30+22/2,0, KDeviceW-30-30-22/2, 50);
        [phoneBackView addSubview:_phoneNumberTF];
        
        _timeCount = 60;
        
        UIView *phoneGrayLine = [[UIView alloc]initWithFrame:CGRectMake(30, phoneBackView.maxY, KDeviceW-30*2, 1)];
        phoneGrayLine.backgroundColor = KHexRGB(0xf2f2f2);
        [self.view addSubview:phoneGrayLine];
        
        _phoneLine = [[AnimateLine alloc]initWithFrame:CGRectMake(30, phoneBackView.maxY, KDeviceW-30*2, 2)];
        _phoneLine.image = KImageName(@"渐变线条");
        [self.view addSubview:_phoneLine];
        [_phoneLine hide:NO];//隐藏
        
        UIView *VerificationBackView = [[UIView alloc]init];
        VerificationBackView.frame = CGRectMake(15,CGRectGetMaxY(_phoneLine.frame)+20, KDeviceW-30, 50);
        [self.view addSubview:VerificationBackView];
        
        UIImageView *VercodeImgV = [[UIImageView alloc] initWithFrame:KFrame(15, 15, 28/2, 32/2)];
        VercodeImgV.image = [UIImage imageNamed:@"验证码icon"];
        [VerificationBackView addSubview:VercodeImgV];
        
        _VerificationCodeTF = [[UITextField alloc]init];
        _VerificationCodeTF.font=[UIFont systemFontOfSize:16];
        _VerificationCodeTF.placeholder = @"请输入验证码";
        _VerificationCodeTF.delegate = self;
        _VerificationCodeTF.backgroundColor = [UIColor clearColor];
        _VerificationCodeTF.textColor = KHexRGB(0x333333);
        _VerificationCodeTF.frame = CGRectMake(30+22/2,0, KDeviceW-30-30-22/2-92.5-15, 50);
        [VerificationBackView addSubview:_VerificationCodeTF];
        
        
        
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.frame = CGRectMake(KDeviceW - 30-92.5-15, 10, 92.5,  30);
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_sureButton setTitleColor:KHexRGB(0xffffff) forState:UIControlStateNormal];
        [_sureButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        _sureButton.layer.masksToBounds = YES;
        _sureButton.layer.cornerRadius = 15;
        _sureButton.backgroundColor = KRGB(73, 145, 245);
        [_sureButton addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [VerificationBackView addSubview:_sureButton];
        
        
        UIView *codeGrayLine = [[UIView alloc]initWithFrame:CGRectMake(30, VerificationBackView.maxY, KDeviceW-30*2, 1)];
        codeGrayLine.backgroundColor = KHexRGB(0xf2f2f2);
        [self.view addSubview:codeGrayLine];
        
        _codeLine = [[AnimateLine alloc]initWithFrame:CGRectMake(30, VerificationBackView.maxY, KDeviceW-30*2, 2)];
        _codeLine.image = KImageName(@"渐变线条");
        [self.view addSubview:_codeLine];
        [_codeLine hide:NO];
        
        
        CompleteRegistrationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CompleteRegistrationButton.frame = CGRectMake(15, CGRectGetMaxY(_codeLine.frame)+50, KDeviceW-15*2,  40);
        [CompleteRegistrationButton setTitle:@"补充信息 完成注册" forState:UIControlStateNormal];
        [CompleteRegistrationButton setBackgroundImage:KImageName(@"圆角渐变") forState: UIControlStateNormal];
        CompleteRegistrationButton.layer.masksToBounds = YES;
        CompleteRegistrationButton.layer.cornerRadius = 40/2;
        CompleteRegistrationButton.titleLabel.font = KFont(18);
        [CompleteRegistrationButton addTarget:self action:@selector(CompleteRegistrationClick:) forControlEvents:UIControlEventTouchUpInside];
        [CompleteRegistrationButton setTitleColor:KHexRGB(0xffffff) forState:UIControlStateNormal];
        [self.view addSubview:CompleteRegistrationButton];
        
        _PromptLable = [[UILabel alloc]init];
        _PromptLable.textColor = [UIColor redColor];
        _PromptLable.frame = CGRectMake(15, CGRectGetMaxY(VerificationBackView.frame) + 10, KDeviceW - 20, 14);
        _PromptLable.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:_PromptLable];
        
        juxinLable = [UILabel new];
        juxinLable.textAlignment = NSTextAlignmentCenter;
//        juxinLable.text = @"如果您已有聚信账户，可用聚信账户直接";
        juxinLable.textColor = KHexRGB(0x999999);
        juxinLable.font = KFont(12);
        [self.view addSubview:juxinLable];
        [juxinLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view).offset(-12*2);
            make.top.mas_equalTo(CompleteRegistrationButton.mas_bottom).offset(40);
        }];
        
        backLoginBtn = [UIButton new];
        [backLoginBtn setTitle:@"登录" forState: UIControlStateNormal];
        backLoginBtn.titleLabel.font = KFont(12);
        [backLoginBtn setTitleColor:KHexRGB(0x48abfc) forState:UIControlStateNormal];
        [backLoginBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backLoginBtn];
        [backLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(juxinLable.mas_right);
            make.top.height.mas_equalTo(juxinLable);
        }];
        
      
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"注册" ];
    [self setBackBtn:@"back"];

}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
   
    if ([textField isEqual:_phoneNumberTF]) {
        [_phoneLine show:YES];
    }else{
        [_codeLine show:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if ([textField isEqual:_phoneNumberTF]) {
        [_phoneLine hide:YES];
    }else{
        [_codeLine hide:YES];
    }
}

- (void)bindingPhoneNumber:(BOOL)isBeding{
    
    _isBeding = isBeding;
    juxinLable.hidden = isBeding;
    backLoginBtn.hidden = isBeding;
    if (isBeding) {
        [CompleteRegistrationButton setTitle:@"确认绑定" forState:UIControlStateNormal];
    }else{
        [CompleteRegistrationButton setTitle:@"补充信息 完成注册" forState:UIControlStateNormal];
    }
}
- (void)giveDelegate:(id<RegisteredViewControllerDelegate>)delegate{
    
    self.delegate = delegate;
}
- (void)backClick{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - 获取验证码
//倒计时
-(void)timerInterval {
    if (_timeCount == 0) {
        [self initializeTimer];
    } else {
        
        [_sureButton setTitle:[NSString stringWithFormat:@"%ld秒",(long)_timeCount] forState:UIControlStateNormal];
        _sureButton.frame = CGRectMake(KDeviceW - 30-71-15, 10, 71,  30);
        _timeCount--;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerInterval) userInfo:nil repeats:NO];
    }
}

//初始化计时相关
-(void)initializeTimer {
    [_timer invalidate];
    _timer = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
    _sureButton.userInteractionEnabled = YES;
    [_sureButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    _sureButton.frame = CGRectMake(KDeviceW - 30-92.5-15, 10, 92.5,  30);
    _timeCount = 60;
}

-(void)sureBtnClick:(UIButton*)btn{
    
    
    if ([_phoneNumberTF.text isEqualToString:@""]) {
        [MBProgressHUD showHint:@"请输入手机号" toView:self.view];
        _PromptLable.text = @"请输入手机号";
        return;
    }
    if (![Verification validatePhoneNumber:_phoneNumberTF.text]) {
        [MBProgressHUD showHint:@"请输入有效的手机号码" toView:self.view];
        _PromptLable.text = @"请输入有效的手机号码";
        return;
    }
    
    int random = arc4random_uniform(8999)+1000;
    NSString *randomNumber = [NSString stringWithFormat:@"%d",random];
    NSString *encryption = [NSString stringWithFormat:@"%@%@%@",_phoneNumberTF.text,randomNumber,@"jiucifang"];
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:_phoneNumberTF.text forKey:@"phonenumber"];
    [paraDic setObject:randomNumber forKey:@"ran"];
    [paraDic setObject:[Tools md5:encryption] forKey:@"encryption"];
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    [RequestManager getWithURLString:GetVerifyCode parameters:paraDic success:^(id responseObject) {
        
        _PromptLable.text = responseObject[@"msg"];
        btn.userInteractionEnabled = YES;
        if ([responseObject[@"result"] integerValue] == 0) {
            btn.userInteractionEnabled = NO;
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerInterval) userInfo:nil repeats:NO];
        }else{
            btn.userInteractionEnabled = YES;
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showHint:@"网络错误，请稍后重试！" toView:self.view];
//        [MBProgressHUD hideHudToView:self.view animated:NO];
        btn.userInteractionEnabled = YES;
    }];
    
}
#pragma mark - 校验验证码
-(void)CompleteRegistrationClick:(UIButton*)btn{
    
    if ([_phoneNumberTF.text isEqualToString:@""]) {
        [MBProgressHUD showHint:@"请输入手机号" toView:self.view];
        _PromptLable.text = @"请输入手机号";
        return;
    }
    if (![Verification validatePhoneNumber:_phoneNumberTF.text]) {
        [MBProgressHUD showHint:@"请输入有效的手机号码" toView:self.view];
        _PromptLable.text = @"请输入有效的手机号码";
        return;
    }
    if ([_VerificationCodeTF.text isEqualToString:@""]) {
        [MBProgressHUD showHint:@"请输入验证码" toView:self.view];
        _PromptLable.text = @"请输入验证码";
        return;
    }
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:_phoneNumberTF.text forKey:@"phonenumber"];
    [paraDic setObject:_VerificationCodeTF.text forKey:@"Verifcode"];
    
    [RequestManager getWithURLString:GetCheckVerifyCode parameters:paraDic success:^(id responseObject) {
        
        if (_isBeding)
        {
            if ([responseObject[@"result"] integerValue] == 6)
            {
                [MBProgressHUD showHint:@"手机号已存在" toView:self.view];
                _PromptLable.text = @"手机号已存在";
                return ;
            }
            [MBProgressHUD showHint:responseObject[@"msg"] toView:self.view];
            _PromptLable.text = responseObject[@"msg"];
            if ([responseObject[@"result"] integerValue] == 0)
            {
                if (self.delegate && [self.delegate respondsToSelector:@selector(ValidationSuccess:)])
                {
                    [self.delegate ValidationSuccess:_phoneNumberTF.text];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }
        else
        {
            if ([responseObject[@"result"] integerValue] == 6)
            {
                [MBProgressHUD showHint:@"账号已注册！" toView:self.view];
                return ;
            }
            [MBProgressHUD showHint:responseObject[@"msg"] toView:self.view];
            
            if ([responseObject[@"result"] integerValue] == 0)
            {
                
                DetailInformationVC *detaiVC = [[DetailInformationVC alloc]init];
                detaiVC.phoneNum = _phoneNumberTF.text;
                [self.navigationController pushViewController:detaiVC animated:YES];
            }
            _PromptLable.text = responseObject[@"msg"];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showHint:@"网络错误，请稍后重试！" toView:self.view];
    }];
    
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar fs_setBackgroundColor:KHomeNavigationBarBackGroundColor];
//    [self.navigationController.navigationBar fs_setBackgroundColor:KNavigationBarBackGroundColor];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [self initializeTimer];
}

@end
