//
//  CustomAlert.m
//  NetworkTest
//
//  Created by JUSFOUN on 2017/10/16.
//  Copyright © 2017年 JUSFOUN. All rights reserved.
//

#import "CustomAlert.h"



@interface CustomAlert ()<UITextFieldDelegate,UIGestureRecognizerDelegate>

@property (nonatomic ,strong) UIView *bgView;

@property (nonatomic ,strong) UIButton *cancelBtn;

@property (nonatomic ,strong) UIButton *assureBtn;

@property (nonatomic ,assign) AlertStyle style;

@property (nonatomic ,strong) UITextField *textfield;

@property (nonatomic ,copy) NSString *title;

@property (nonatomic ,copy) NSString *cancelTitle;

@property (nonatomic ,copy) NSString *otherTitle;

@property (nonatomic ,copy) NSString *placeholder;

@property (nonatomic ,copy) NSMutableAttributedString *attributedTitle;

@property(nonatomic,strong)UIButton *chooseBtn;

@end

@implementation CustomAlert


- (instancetype)initWithTitle:(NSString *)title style:(AlertStyle)style placeholder:(NSString *)placeholder callBack:(Callback)handler{

    self = [self initWithTitle:title style:style placeholder:placeholder cancelButtonTitle:@"取消" otherButtonTitle:@"确定" callBack:handler];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title style:(AlertStyle)style placeholder:(NSString *)placeholder cancelButtonTitle:(nullable NSString *)cancelTitle otherButtonTitle:(NSString *)otherTitle callBack:(Callback)handler{
    self = [self initWithFrame:self.frame];
    if (self) {
        
        _style = style;
        _title = title;
        _cancelTitle = cancelTitle;
        _otherTitle = otherTitle;
        _handler = handler;
        _placeholder = placeholder;
    }
    
    return self;
}


- (instancetype)initWithTitle:(NSMutableAttributedString*)title cancelButtonTitle:(nullable NSString *)cancelTitle otherButtonTitle:(NSString *)otherTitle callBack:(Callback)handler contentCallBack:(ContentCallback)handler2
{
    self = [self initWithFrame:self.frame];
    if (self) {
        
        _style = AlertStyleAgreement;
        
        _attributedTitle = title;
        _cancelTitle = cancelTitle;
        _otherTitle = otherTitle;
        _handler = handler;
        _contentCallback = handler2;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, KDeviceW, KDeviceH);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
        self.alpha = 0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBackGroundHide:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        
    }
    return self;
}

- (void)didMoveToSuperview{
    if (self.superview) {
        [self initViews];
        [self initContentView];
    }
}


#pragma mark - initView

- (void)initViews{
    [self initBgView];
    [self initLineView];
    [self initButtons];
}

- (void)initBgView{
    self.bgView = ({
        
        float hight = 190 ;
        if(_style == AlertStyleAgreement)
        {
            hight = 130;
        }
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 0, KDeviceW-15*2, hight)];
        [self addSubview:view];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 8.0*(KDeviceW/375);
        view.clipsToBounds = YES;
        view.layer.masksToBounds = YES;
        view.center = self.center;
        view;
    });
}

- (void)initContentView{

    if (_style == AlertStylePlain) {
    
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, CGRectGetWidth(_bgView .frame)-20*2, CGRectGetHeight(_bgView.frame)-51-30-10)];
        titleLab.font = [UIFont systemFontOfSize:15];
        titleLab.textColor = KHexRGB(0x666666);
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.numberOfLines = 3;
        titleLab.text = _title;
        [_bgView addSubview:titleLab];

    }else if(_style == AlertStyleTextField)
    {
    
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(17, 30, CGRectGetWidth(_bgView .frame)-17*2, 20)];
        titleLab.font = [UIFont systemFontOfSize:15];
        titleLab.textColor = KHexRGB(0x666666);
        titleLab.textAlignment = NSTextAlignmentLeft;
        titleLab.text = _title;
        [_bgView addSubview:titleLab];

        self.textfield = ({
            UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(17, 65, CGRectGetWidth(_bgView .frame)-17*2, 40)];
            textField.font = [UIFont systemFontOfSize:15];
            textField.placeholder = _placeholder;
            textField.borderStyle = UITextBorderStyleRoundedRect;
            textField.backgroundColor = KHexRGB(0xe7e4e5);
            textField.delegate = self;
            textField.layer.cornerRadius = 4.f;
            textField.layer.masksToBounds = YES;
            textField.layer.borderColor = [UIColor clearColor].CGColor;
            textField.layer.borderWidth = .5;
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
            textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            textField.keyboardType = UIKeyboardTypeEmailAddress;
            [_bgView addSubview:textField];
            textField;
        });
        
    }
    else
    {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = KFrame(15, 0 , 40, _bgView.height - 51);
        [button setImage:[Tools scaleImage:KImageName(@"notChoose") size:CGSizeMake(15, 15) ] forState:UIControlStateNormal];
        [button setImage:KImageName(@"agree") forState:UIControlStateSelected];
        [button addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:button];
        _chooseBtn = button;
        
        UILabel *label = [[UILabel alloc]initWithFrame:KFrame(button.maxX , 20, _bgView.width-button.maxX - 20, _bgView.height - 51-40)];
        label.attributedText = _attributedTitle;
        label.userInteractionEnabled = YES;
        label.numberOfLines = 0;
        [_bgView addSubview:label];
        
        UIButton *agereeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        agereeBtn.frame = KFrame(label.width - 120, 0 , 120, label.height);
        [agereeBtn addTarget:self action:@selector(agereeChoose) forControlEvents:UIControlEventTouchUpInside];
        [label addSubview:agereeBtn];
        
        self.assureBtn.enabled = NO;
    }
}

- (void)initLineView{

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_bgView.frame)-51, CGRectGetWidth(_bgView.frame), 1)];
    lineView.backgroundColor = [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f];
    [_bgView addSubview:lineView];
}

- (void)initButtons{

    self.cancelBtn = ({
        UIButton *view = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_bgView.frame)-50, (CGRectGetWidth(_bgView.frame)-1)/2, 50)];
        [_bgView addSubview:view];
        [view setTitle:@"取消" forState:UIControlStateNormal];
        [view setTitleColor:KHexRGB(0x666666) forState:UIControlStateNormal];
        [view addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        view.titleLabel.font = [UIFont systemFontOfSize:15];
        view;
    });
    
    
    self.assureBtn = ({
        UIButton *view = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_cancelBtn.frame)+1, CGRectGetHeight(_bgView.frame)-50, (CGRectGetWidth(_bgView.frame)-1)/2, 50)];
        [_bgView addSubview:view];
        [view setTitle:@"确定" forState:UIControlStateNormal];
        [view setTitleColor:KHexRGB(0xff6400) forState:UIControlStateNormal];
        [view setTitleColor:KHexRGB(0x666666) forState:UIControlStateDisabled];
        view.titleLabel.font = [UIFont systemFontOfSize:15];
        [view addTarget:self action:@selector(assureAction) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_cancelBtn.frame), CGRectGetHeight(_bgView.frame)-50, 1, 50)];
    lineView.backgroundColor = [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f];
    [_bgView addSubview:lineView];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.layer.borderColor=[[UIColor cyanColor] CGColor];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    textField.layer.borderColor=[[UIColor clearColor] CGColor];
}

#pragma mark - button action
- (void)cancelAction{
    [self hide];
}

- (void)assureAction{
    [self hide];
    if (_handler) {
        _handler(_textfield.text);
    }
}

- (void)clickBackGroundHide:(UITapGestureRecognizer *)tap{
    [self hide];
}

-(void)choose:(UIButton*)button
{
    button.selected = !button.selected;
    
    if(button.selected)
    {
        self.assureBtn.enabled = YES;
    }
    else
    {
        self.assureBtn.enabled = NO;
    }
    
}

-(void)agereeChoose
{
    if (_contentCallback) {
        _contentCallback();
    }
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint point = [touch locationInView:self];
    if (CGRectContainsPoint(_bgView.frame, point)) {
        return NO;
    }
    return YES;
}


#pragma mark - 键盘显示隐藏
-(void)keyboardWillShow:(NSNotification *)ntf {
    NSDictionary * userInfo = [ntf userInfo];
    CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGRect kbRect = [userInfo[@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    CGFloat kb_minY = KDeviceH - CGRectGetHeight(kbRect);
    
    CGRect beginUserInfo = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey]   CGRectValue];
    if (beginUserInfo.size.height <=0) {//!!搜狗输入法弹出时会发出三次UIKeyboardWillShowNotification的通知,和官方输入法相比,有效的一次为UIKeyboardFrameBeginUserInfoKey.size.height都大于零时.
        return;
    }
    
    CGFloat contentView_maxY = CGRectGetMaxY(_bgView.frame)+(5); //+5让输入框再高于键盘5的高度
    CGFloat offset = contentView_maxY - kb_minY;
    if (offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            CGRect rect = _bgView.frame;
            rect.origin.y -= offset;
            _bgView.frame = rect;
        }];
    }
}

-(void)keyboardWillHide:(NSNotification *)ntf {
    NSDictionary * userInfo = [ntf userInfo];
    CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    [UIView animateWithDuration:duration animations:^{
        _bgView.center = self.center;
    }];
}

#pragma mark - 显示隐藏
- (void)showInView:(UIView *)view{
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
    }];
    [self showAlertAnimation];
}

- (void)hide{

    [self dismissAlertAnimation];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    }];
    [UIView animateWithDuration:0.2 animations:^{
        _bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

}

- (void)showAlertAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)]];
    animation.keyTimes = @[ @0, @0.5, @1 ];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = .3;
    
    [_bgView.layer addAnimation:animation forKey:@"showAlert"];
}

- (void)dismissAlertAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1)]];
    animation.keyTimes = @[ @0, @0.5, @1 ];
    animation.fillMode = kCAFillModeRemoved;
    animation.duration = .2;
    
    [_bgView.layer addAnimation:animation forKey:@"dismissAlert"];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
