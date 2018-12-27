//
//  MyAlertView.m
//  EnterpriseInquiry
//
//  Created by clj on 16/8/18.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "MyAlertView.h"
#define TITLE_FONT_SIZE 17
#define MESSAGE_FONT_SIZE 14
#define BUTTON_FONT_SIZE 16
#define MARGIN_TOP 20
#define MARGIN_LEFT_LARGE 30
#define MARGIN_LEFT_SMALL 15
#define MARGIN_RIGHT_LARGE 30
#define MARGIN_RIGHT_SMALL 15
#define SPACE_LARGE 20
#define SPACE_SMALL 5
#define MESSAGE_LINE_SPACE 5
#define TITLE_SPACE 15

CGFloat contentViewWidth;
CGFloat contentViewHeight;
@implementation MyAlertView
{
    CGFloat sinWidth;
    CGFloat sinHeigh;
    UIButton *closeBtn;
}

- (void)setContentView:(UIImageView *)contentView {
    _contentView = contentView;
    _contentView.center = self.center;
    [self addSubview:_contentView];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self initContentalert:NO];
}

- (void)setIcon:(UIImage *)icon {
    _icon = icon;
    [self initContentalert:NO];
}

- (void)setMessage:(NSString *)message {
    _message = message;
    [self initContentalert:NO];
}
- (instancetype)init {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.backgroundColor = [UIColor blackColor];
        
        _backgroundView = [[UIView alloc] initWithFrame:self.frame];
        _backgroundView.backgroundColor = [UIColor blackColor];
        [self addSubview:_backgroundView];
    }
    return self;
}


-(instancetype)initWithTitle:(NSString *)title delegate:(id<MyAlertViewDelegate>)delegate buttonTitles:(NSString *)buttonTitles,...{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds])
    {
        _title = title;
        _delegate = delegate;
        _buttonArray = [NSMutableArray array];
        _buttonTitleArray = [NSMutableArray array];
        
        va_list args;
        va_start(args, buttonTitles);
        if (buttonTitles)
        {
            [_buttonTitleArray addObject:buttonTitles];
            while (1)
            {
                NSString *  otherButtonTitle = va_arg(args, NSString *);
                if(otherButtonTitle == nil) {
                    break;
                } else {
                    [_buttonTitleArray addObject:otherButtonTitle];
                }
            }
        }
        va_end(args);
        
        self.backgroundColor = [UIColor clearColor];
        _backgroundView = [[UIView alloc] initWithFrame:self.frame];
        _backgroundView.backgroundColor = [UIColor blackColor];
        [self addSubview:_backgroundView];
        [self initContentalert:YES];
    }
    return self;
}


- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon message:(NSString *)message delegate:(id<MyAlertViewDelegate>)delegate buttonTitles:(NSString *)buttonTitles, ... {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds])
    {
        _icon = icon;
        _title = title;
        _message = message;
        _delegate = delegate;
        _buttonArray = [NSMutableArray array];
        _buttonTitleArray = [NSMutableArray array];
        
        va_list args;
        va_start(args, buttonTitles);
        if (buttonTitles)
        {
            [_buttonTitleArray addObject:buttonTitles];
            while (1)
            {
                NSString *  otherButtonTitle = va_arg(args, NSString *);
                if(otherButtonTitle == nil) {
                    break;
                } else {
                    [_buttonTitleArray addObject:otherButtonTitle];
                }
            }
        }
        va_end(args);
        
        self.backgroundColor = [UIColor clearColor];
        
        _backgroundView = [[UIView alloc] initWithFrame:self.frame];
        _backgroundView.backgroundColor = [UIColor blackColor];

        [self addSubview:_backgroundView];
        [self initContentalert:NO];
    }
    return self;
}






// 总视图
- (void)initContentalert:(BOOL)hasTextView{
    contentViewWidth = 280 * self.frame.size.width / 320;
    contentViewHeight = 100;
    
    _contentView = [[UIImageView alloc] init];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.userInteractionEnabled = YES;
    
    
    _contentView.layer.cornerRadius = 5.0;
    _contentView.layer.masksToBounds = YES;
    
    if (hasTextView)
    {
        _contentView.image = [UIImage imageNamed:@"alertBg"];
        [self initTextView];
    }
    else
    {
//        _contentView.image = [UIImage imageNamed:@"telBg"];
        [self initTitleAndIcon];
        [self initMessage];
    }
    
    [self initAllButtons];
    
    _contentView.frame = CGRectMake(0, 0, contentViewWidth, contentViewHeight);
    _contentView.center = self.center;
    [self addSubview:_contentView];
}


//布局UItextView
-(void)initTextView
{
    _alertView = [[UIView alloc] init];
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = _title;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont boldSystemFontOfSize:TITLE_FONT_SIZE];
    _titleLabel.frame = CGRectMake(10, 20, self.frame.size.width -20, 25);
    _titleLabel.textColor  = [UIColor whiteColor];
    [_alertView addSubview:_titleLabel];
    
    _alertTf = [[UITextField alloc] init];
    _alertTf.frame = CGRectMake(40, _titleLabel.frame.origin.y + _titleLabel.frame.size.height  + 18, self.frame.size.width - 80, 31);
    _alertTf.borderStyle = UITextBorderStyleRoundedRect;
    _alertTf.placeholder = @"请输入内容";
    _alertTf.backgroundColor = [UIColor whiteColor];
    [_alertView addSubview:_alertTf];
    
    _alertView.frame = CGRectMake(0, 0, self.frame.size.width,_alertTf.frame.origin.y + _alertTf.frame.size.height );
    _alertView.center = CGPointMake(contentViewWidth / 2,_alertView.frame.size.height / 2);
    [_contentView addSubview:_alertView];
    contentViewHeight += _alertView.frame.size.height -20;
}


// 布局图标和标题
- (void)initTitleAndIcon {
    _titleView = [[UIView alloc] init];
    if (_icon != nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = _icon;
        _iconImageView.frame = CGRectMake(0, 0, 75,75);
        _iconImageView.center = CGPointMake(self.frame.size.width/2, 85);
        [_titleView addSubview:_iconImageView];
    }
    
    CGSize titleSize = [self getTitleSize];
    if (_title != nil && ![_title isEqualToString:@""]) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = _title;
        _titleLabel.font = [UIFont boldSystemFontOfSize:TITLE_FONT_SIZE];
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.frame = CGRectMake(0, _iconImageView.frame.size.height + _iconImageView.frame.origin.y + TITLE_SPACE, self.frame.size.width, titleSize.height);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor  = [UIColor whiteColor];
        [_titleView addSubview:_titleLabel];
    }
    
    _titleView.frame = CGRectMake(0, 0, self.frame.size.width,56);//_iconImageView.frame.size.height + _iconImageView.frame.origin.y +titleSize.height +TITLE_SPACE +
    _titleLabel.center = CGPointMake(self.frame.size.width/2, _titleView.frame.size.height/2);
    _titleView.backgroundColor = KHexRGB(0x2ECC8B);
    _titleView.center = CGPointMake(contentViewWidth / 2,_titleView.frame.size.height / 2);
    [_contentView addSubview:_titleView];
    contentViewHeight += _titleView.frame.size.height;
}


// 布局信息
- (void)initMessage {
    if (_message != nil) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.text = _message;
        _messageLabel.textColor = KHexRGB(0x333333);
        _messageLabel.numberOfLines = 0;
        _messageLabel.font = [UIFont boldSystemFontOfSize:MESSAGE_FONT_SIZE];
//        _messageLabel.font = [UIFont fontWithName:@"Helvetica" size:MESSAGE_FONT_SIZE];
        
        //设置行间距
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineSpacing = MESSAGE_LINE_SPACE;
        NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle};
        _messageLabel.attributedText = [[NSAttributedString alloc]initWithString:_message attributes:attributes];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        
        CGSize messageSize = [self getMessageSize];
        CGFloat messafeLabelOy;
        if (_icon == nil)
        {
            messafeLabelOy= _titleView.frame.origin.y + _titleView.frame.size.height  +30;
        }else
        {
            messafeLabelOy = _titleView.frame.origin.y + _titleView.frame.size.height  +10;
        }
        _messageLabel.frame = CGRectMake(MARGIN_LEFT_LARGE,messafeLabelOy, MAX(contentViewWidth - MARGIN_LEFT_LARGE - MARGIN_RIGHT_LARGE, messageSize.width), messageSize.height);
        [_contentView addSubview:_messageLabel];
        contentViewHeight +=  _messageLabel.frame.size.height;
    }
}

//  创建button按钮
-(UIButton *)createButtonWithFrame:(CGRect)frame andTitleString:(NSString *)buttonTitle
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:BUTTON_FONT_SIZE];
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor: KHexRGB(0xffb2b2) forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonWithPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}


// 获取名字所用的大小
- (CGSize)getTitleSize {
    UIFont *font = [UIFont systemFontOfSize:TITLE_FONT_SIZE];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size = [_title boundingRectWithSize:CGSizeMake(contentViewWidth - (MARGIN_LEFT_SMALL + MARGIN_RIGHT_SMALL + _iconImageView.frame.size.width + SPACE_SMALL), 2000)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attributes context:nil].size;
    
    size.width = ceil(size.width);
    size.height = ceil(size.height);
    
    return size;
}


///获取信息的尺寸
- (CGSize)getMessageSize {
    UIFont *font = [UIFont systemFontOfSize:MESSAGE_FONT_SIZE];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = MESSAGE_LINE_SPACE;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size = [_message boundingRectWithSize:CGSizeMake(contentViewWidth - (MARGIN_LEFT_LARGE + MARGIN_RIGHT_LARGE), 2000)
                                         options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attributes context:nil].size;
    
    size.width = ceil(size.width);
    size.height = ceil(size.height);
    
    return size;
}


-(void)shareWithPressed:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(shareButtonClickWithType:)]) {
        NSInteger index = button.tag - 100;
        [_delegate shareButtonClickWithType:index];
    }
    [self hide];
}



- (void)buttonWithPressed:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        NSInteger index = [_buttonTitleArray indexOfObject:button.titleLabel.text];
        [_delegate alertView:self clickedButtonAtIndex:index];
    }
    [self hide];
}

- (void)show {
   // UIWindow *window = KEY_WINDOW;
    
    
    [KeyWindow addSubview:self];
    [self showBackground];
    [self showAlertAnimation];
//    NSArray *windowViews = [window subviews];
//    if(windowViews && [windowViews count] > 0){
//        UIView *subView = [windowViews objectAtIndex:[windowViews count]-1];
//        for(UIView *aSubView in subView.subviews)
//        {
//            [aSubView.layer removeAllAnimations];
//        }
//       
//    }
}

- (void)hide {
    // _contentView.hidden = YES;
    [self hideAlertAnimation];
}

- (void)setTitleColor:(UIColor *)color fontSize:(CGFloat)size {
    if (color != nil) {
        _titleLabel.textColor = color;
    }
    
    if (size > 0) {
        // _titleLabel.font = [UIFont systemFontOfSize:size];
        _titleLabel.font =[UIFont fontWithName:@"Helvetica" size:size];
    }
}

- (void)setMessageColor:(UIColor *)color fontSize:(CGFloat)size {
    if (color != nil) {
        _messageLabel.textColor = color;
    }
    
    if (size > 0) {
        //_messageLabel.font = [UIFont systemFontOfSize:size];
        _messageLabel.font =[UIFont fontWithName:@"Helvetica" size:size];
    }
}

- (void)setButtonTitleColor:(UIColor *)color fontSize:(CGFloat)size atIndex:(NSInteger)index {
    UIButton *button = _buttonArray[index];
    if (color != nil) {
        [button setTitleColor:color forState:UIControlStateNormal];
    }
    if (size > 0) {
        button.titleLabel.font = [UIFont systemFontOfSize:size];
    }
}

- (void)showBackground
{
    _backgroundView.alpha = 0;
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.35];
    _backgroundView.alpha = 0.6;
    [UIView commitAnimations];
}


-(void)showAlertAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(0.01), @(1.2), @(0.9), @(1)];
    animation.keyTimes = @[@(0), @(0.4), @(0.6), @(1)];
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    animation.duration = 0.5;
    [self.contentView.layer addAnimation:animation forKey:@"bouce"];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self removeFromSuperview];
}
// 关闭视图动画
- (void)hideAlertAnimation
{
    _backgroundView.alpha = 0;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(1), @(1.2), @(0.01)];
    animation.keyTimes = @[@(0), @(0.4), @(1)];
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    animation.duration = 0.35;
    animation.delegate = self;
    // [animation setValue:completion forKey:@"handler"];
    [self.contentView.layer addAnimation:animation forKey:@"bounce"];
    self.contentView.transform = CGAffineTransformMakeScale(0.001, 0.001);
}

///布局button
- (void)initAllButtons {
    
    CGFloat buttonHeight = 40;
    contentViewHeight += buttonHeight;
    UIView *horizonSperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, contentViewHeight -65, contentViewWidth, 1)];
    horizonSperatorView.backgroundColor = KHexRGB(0x930000);
    //    [_contentView addSubview:horizonSperatorView];
    
    if (_buttonTitleArray.count > 1) {
        CGFloat buttonWidth = (contentViewWidth -40) / _buttonTitleArray.count;
        for (NSString *buttonTitle in _buttonTitleArray) {
            NSInteger index = [_buttonTitleArray indexOfObject:buttonTitle];
            UIButton *button = [self createButtonWithFrame:CGRectMake(15 + index * (buttonWidth+10), CGRectGetMaxY(horizonSperatorView.frame), buttonWidth,buttonHeight) andTitleString: buttonTitle];
            if (index == 0) {
                button.backgroundColor = KHexRGB(0x2ECC8B);
                
            }else
            {
                button.backgroundColor = KHexRGB(0xD0D0D0);
            }
            button.layer.cornerRadius = 20;
            button.clipsToBounds = YES;
            
            [_buttonArray addObject:button];
            [_contentView addSubview:button];
        }
    }else if(_buttonTitleArray.count == 1){
        
        NSString *titleString = [_buttonTitleArray objectAtIndex:0];
        UIButton *button = [self createButtonWithFrame:CGRectMake(25, CGRectGetMaxY(horizonSperatorView.frame),self.frame.size.width - 90, 40) andTitleString:titleString];
        button.backgroundColor = KHexRGB(0x2d5be3);
        button.layer.cornerRadius = 14;
        button.clipsToBounds = YES;
        [_buttonArray addObject:button];
        [_contentView addSubview:button];
    }
    
    
}



-(instancetype)initShareViewWithTitle:(NSString *)title icon:(UIImage *)icon andMeaasge:(NSString *)message deklegate:(id<MyAlertViewDelegate>) delegate buttonTitles:(NSString *)buttonTitles,...NS_REQUIRES_NIL_TERMINATION
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds])
    {
        _icon = icon;
        _title = title;
        _message = message;
        _delegate = delegate;
        _buttonArray = [NSMutableArray array];
        _buttonTitleArray = [NSMutableArray array];
        
        va_list args;
        va_start(args, buttonTitles);
        if (buttonTitles)
        {
            [_buttonTitleArray addObject:buttonTitles];
            while (1)
            {
                NSString *  otherButtonTitle = va_arg(args, NSString *);
                if(otherButtonTitle == nil) {
                    break;
                } else {
                    [_buttonTitleArray addObject:otherButtonTitle];
                }
            }
        }
        va_end(args);
        
        self.backgroundColor = [UIColor clearColor];
        
        _backgroundView = [[UIView alloc] initWithFrame:self.frame];
        _backgroundView.backgroundColor = [UIColor blackColor];
        [self addSubview:_backgroundView];
        [self initShareContent];
    }
    return self;
}


-(void)initShareContent
{
    contentViewWidth = 280 * self.frame.size.width / 320;
    contentViewHeight = 100;
    
    _contentView = [[UIImageView alloc] init];
    _contentView.userInteractionEnabled = YES;
    
    _contentView.layer.cornerRadius = 5.0;
    _contentView.layer.masksToBounds = YES;
    
    _contentView.backgroundColor = [UIColor whiteColor];
    [self initShareTitleAndIcon];
    [self initMessage];
    [self initAllButtons];
    
    _contentView.frame = CGRectMake(0, 30, contentViewWidth, contentViewHeight);
    _contentView.center = self.center;
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];
    
    closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_contentView.frame) - 30, _contentView.frame.origin.y - 30, 30, 30)];
    [closeBtn setImage:[UIImage imageNamed:@"弹窗-X"] forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
}
// 布局图标和标题
- (void)initShareTitleAndIcon {
    _titleView = [[UIView alloc] init];
    if (_icon != nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = _icon;
        _iconImageView.frame = CGRectMake(0,MARGIN_LEFT_LARGE + SPACE_SMALL, 27,27);
        [_titleView addSubview:_iconImageView];
    }
    
    CGSize titleSize = [self getTitleSize];
    if (_title != nil && ![_title isEqualToString:@""]) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = _title;
        _titleLabel.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:17];
        _titleLabel.numberOfLines = 1;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame) +SPACE_SMALL , MARGIN_LEFT_LARGE + SPACE_SMALL, titleSize.width, titleSize.height);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor  = KHexRGB(0x333333);
        [_titleView addSubview:_titleLabel];
    }
    
    _titleView.frame = CGRectMake(0, 0, CGRectGetMaxX(_titleLabel.frame) + SPACE_SMALL,CGRectGetMaxY(_titleLabel.frame)+ SPACE_SMALL);
    _titleView.center = CGPointMake(contentViewWidth / 2,_titleView.frame.size.height / 2);
    [_contentView addSubview:_titleView];
    contentViewHeight += _titleView.frame.size.height;
}

-(void)close
{
    [self hide];
    
    if (_delegate && [_delegate respondsToSelector:@selector(hideWithOtherWork)]) {
        [_delegate hideWithOtherWork];
    }
    
}





@end
