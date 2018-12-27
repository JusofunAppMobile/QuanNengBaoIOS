//
//  UpdatePhoneNumberVC.m
//  EnterpriseInquiry
//
//  Created by LEZ on 16/8/10.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "UpdatePhoneNumberVC.h"
#import "Verification.h"
#import "AnimateLine.h"
@interface UpdatePhoneNumberVC ()<UITextFieldDelegate>
{
    
    UIScrollView            *_scrollView;
    
    UITextField             *_phoneField;
    UITextField             *_codeField;
    
    UIButton                *_getCodeButton;
    UIButton                *_submitButton;
    
}

@property (nonatomic ,strong) AnimateLine *phoneLine;
@property (nonatomic ,strong) AnimateLine *codeLine;
@end

@implementation UpdatePhoneNumberVC



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarTitle:@"修改手机号" ];
    [self setBackBtn:@"back"];
   
    //self.automaticallyAdjustsScrollViewInsets = NO;
    [self layout];
}


-(void)updateAction
{
    [self.view endEditing:YES];
    if ([_phoneField.text isEqualToString:@""]) {
        [MBProgressHUD showHint:@"请输入手机号" toView:self.view];
        return;
    }
    if ([_codeField.text isEqualToString:@""]) {
        [MBProgressHUD showHint:@"请输入验证码" toView:self.view];
        return;
    }
    if (![Verification validatePhoneNumber:_phoneField.text]) {
        [MBProgressHUD showHint:@"请输入有效的手机号码" toView:self.view];
        return;
    }
    NSDictionary *dict = @{
                           @"userid":USER.userID,
                           @"newphone":_phoneField.text,
                           @"code":_codeField.text
                           };
    [RequestManager postWithURLString:UpdateUserPhone parameters:dict success:^(id responseObject) {
        
        if ([responseObject[@"result"] integerValue] == 0) {
            [MBProgressHUD showHint:@"修改成功" toView:self.view];
            USER.mobile = _phoneField.text;
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showHint:responseObject[@"msg"] toView:self.view];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showHint:@"网络错误，请稍后重试！" toView:self.view];
    }];
    
}


-(void)requestCode
{
    [MBProgressHUD showMessag:@"" toView:self.view];
    if ([_phoneField.text isEqualToString:@""]) {
        [MBProgressHUD showHint:@"请输入手机号" toView:self.view];
        return;
    }
    if (![Verification validatePhoneNumber:_phoneField.text]) {
        [MBProgressHUD showHint:@"请输入有效的手机号码" toView:self.view];
        return;
    }
    int random = arc4random_uniform(8999)+1000;
    NSString *randomNumber = [NSString stringWithFormat:@"%d",random];
    NSString *encryption = [NSString stringWithFormat:@"%@%@%@",_phoneField.text,randomNumber,@"jiucifang"];
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:_phoneField.text forKey:@"phonenumber"];
    [paraDic setObject:randomNumber forKey:@"ran"];
    [paraDic setObject:[Tools md5:encryption] forKey:@"encryption"];
//    NSDictionary *dict = @{@"phonenumber":_phoneField.text};
    [RequestManager getWithURLString:GetVerifyCode parameters:paraDic success:^(id responseObject) {
        [MBProgressHUD hideHudToView:self.view animated:YES];
        if ([responseObject[@"result"] integerValue] == 0) {
            
            [self startTimer];
            [MBProgressHUD showHint:@"验证码发送成功" toView:self.view];
            
        }else{
            [MBProgressHUD showHint:responseObject[@"msg"] toView:self.view];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showHint:@"网络错误，请稍后重试！" toView:self.view];
    }];
    
    
}


-(void)startTimer{

    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_getCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
                _getCodeButton.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [_getCodeButton  setTitle:[NSString stringWithFormat:@"%@秒",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                _getCodeButton .userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar fs_setBackgroundColor:KHomeNavigationBarBackGroundColor];
    
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if ([textField isEqual:_phoneField]) {
        [_phoneLine show:YES];
    }else{
        [_codeLine show:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if ([textField isEqual:_phoneField]) {
        [_phoneLine hide:YES];
    }else{
        [_codeLine hide:YES];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
   
    if(textField == _codeField && textField.text.length >0)
    {
        [self updateAction];
    }
    
    return YES;
}

-(void)layout
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,KNavigationBarHeight,KDeviceW,KDeviceH-KNavigationBarHeight)];
    _scrollView.contentSize  = CGSizeMake(KDeviceW, KDeviceH-KNavigationBarHeight+1);
    _scrollView.backgroundColor  = [UIColor whiteColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    [self createMainUI];
}

-(void)createMainUI
{
    
    UIImageView *phoneImgV = [[UIImageView alloc] initWithFrame:KFrame(30, 45, 22/2, 34/2)];
    phoneImgV.image = [UIImage imageNamed:@"注册手机icon"];
    [_scrollView addSubview:phoneImgV];
    
    _phoneField = [[UITextField alloc]init];
    _phoneField.placeholder = @"请输入新的手机号";
    _phoneField.font=[UIFont systemFontOfSize:16];
    _phoneField.delegate = self;
    _phoneField.textColor = KHexRGB(0x333333);
    _phoneField.backgroundColor = [UIColor clearColor];
    _phoneField.frame = CGRectMake(phoneImgV.maxX+10,phoneImgV.y - 15, KDeviceW-phoneImgV.maxX*2 - 20, 50);
    [_scrollView addSubview:_phoneField];
    
    
    
    UIView *grayLine = [[UIView alloc]initWithFrame:CGRectMake(phoneImgV.x, _phoneField.maxY, KDeviceW-phoneImgV.x*2, 1)];
    grayLine.backgroundColor = KHexRGB(0xf2f2f2);
    [_scrollView addSubview:grayLine];
    
    _phoneLine = [[AnimateLine alloc]initWithFrame:CGRectMake(phoneImgV.x, _phoneField.maxY, KDeviceW-phoneImgV.x*2, 2)];
    _phoneLine.image = KImageName(@"渐变线条");
    [_scrollView addSubview:_phoneLine];
    [_phoneLine hide:NO];//隐藏

    UIImageView *VercodeImgV = [[UIImageView alloc] initWithFrame:KFrame(phoneImgV.x, _phoneLine.maxY + 35, 28/2, 32/2)];
    VercodeImgV.image = [UIImage imageNamed:@"验证码icon"];
    [_scrollView addSubview:VercodeImgV];
    
    _codeField = [[UITextField alloc]init];
    _codeField.font=[UIFont systemFontOfSize:16];
    _codeField.placeholder = @"请输入验证码";
    _codeField.delegate = self;
    _codeField.backgroundColor = [UIColor clearColor];
    _codeField.textColor = KHexRGB(0x333333);
    _codeField.frame = CGRectMake(VercodeImgV.maxX +10,VercodeImgV.y-15, KDeviceW-VercodeImgV.maxX *2 -10 - 100, 50);
    [_scrollView addSubview:_codeField];
    
    
    
    _getCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _getCodeButton.frame = CGRectMake(KDeviceW - 30-92.5, _codeField.y + 10, 92.5,  30);
    _getCodeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_getCodeButton setTitleColor:KHexRGB(0xffffff) forState:UIControlStateNormal];
    [_getCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    _getCodeButton.layer.masksToBounds = YES;
    _getCodeButton.layer.cornerRadius = 15;
    _getCodeButton.backgroundColor = KRGB(73, 145, 245);
    
    [_getCodeButton addTarget:self action:@selector(requestCode) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_getCodeButton];
    
    
    UIView *grayLine2 = [[UIView alloc]initWithFrame:CGRectMake(phoneImgV.x, _codeField.maxY, KDeviceW-phoneImgV.x*2, 1)];
    grayLine2.backgroundColor = KHexRGB(0xf2f2f2);
    [_scrollView addSubview:grayLine2];
    
    _codeLine = [[AnimateLine alloc]initWithFrame:CGRectMake(phoneImgV.x, _codeField.maxY, KDeviceW-phoneImgV.x*2, 2)];
    _codeLine.image = KImageName(@"渐变线条");
    [_scrollView addSubview:_codeLine];
    [_codeLine hide:NO];
    
    
    _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitButton.frame = CGRectMake(phoneImgV.x, CGRectGetMaxY(_codeLine.frame)+50, KDeviceW-phoneImgV.x*2,  40);
    [_submitButton setTitle:@"确认修改" forState:UIControlStateNormal];
    [_submitButton setBackgroundImage:KImageName(@"圆角渐变") forState: UIControlStateNormal];
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = 40/2;
    _submitButton.titleLabel.font = KFont(18);
    [_submitButton addTarget:self action:@selector(updateAction) forControlEvents:UIControlEventTouchUpInside];
    [_submitButton setTitleColor:KHexRGB(0xffffff) forState:UIControlStateNormal];
    [_scrollView addSubview:_submitButton];
    
    _scrollView.contentSize = CGSizeMake(0, _submitButton.maxY + 100);
    
}


@end
