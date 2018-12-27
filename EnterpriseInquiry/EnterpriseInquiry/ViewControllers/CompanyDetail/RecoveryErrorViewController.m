//
//  RecoveryErrorViewController.m
//  EnterpriseInquiry
//
//  Created by clj on 15/11/13.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import "RecoveryErrorViewController.h"
#import "ItemView.h"
#import "MyTextView.h"
#import "MyTextField.h"
#import "ErrorModel.h"
#import "QuestionItem.h"
#import "AnswerModel.h"

#define PADDING 15.f

@interface RecoveryErrorViewController ()<ItemViewDelegate,UITextFieldDelegate,UITextViewDelegate,QuestionDelegate>
{
    NSMutableArray *_selectArray;
    UIScrollView *_scrollerView;
    UITextView *_adviceTextView;
    MyTextField *_contactTextField;
    UILabel *_placeHolderLab;
    UIView *adviceView;//建议的框
    UIView *mengBanView;//弹出键盘时，添加的蒙版
}

@property (nonatomic ,strong) NSMutableArray *questionList;

@property (nonatomic ,strong) UIView *questionView;

//

@property (nonatomic ,strong) UIView *lineView;

@property (nonatomic ,strong) UILabel  *titleLab;

@property (nonatomic ,strong) ItemView *itemView;

@property (nonatomic ,strong) UIView *contactView;

@property (nonatomic ,strong) UIImageView *phoneImgV;

@property (nonatomic ,strong) UIButton *submitButton;

@property (nonatomic ,strong) NSMutableArray *questionViews;

@end

@implementation RecoveryErrorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    [MobClick event:@"Detail76"];//企业详情页－纠错点击数
    [[BaiduMobStat defaultStat] logEvent:@"Detail76" eventLabel:@"企业详情页－纠错点击数"];

    
    [self setNavigationBarTitle:@"纠错"];
    [self setBackBtn:@"back"];
    
    self.view.backgroundColor = KHexRGB(0xf2f3f5);
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, KNavigationBarHeight, self.view.frame.size.width, 0.5);
    lineView.backgroundColor = KHexRGB(0xd9d9d9);
    [self.view addSubview:lineView];
    
    _scrollerView = [[UIScrollView alloc] init];
    _scrollerView.backgroundColor = KHexRGB(0xf2f3f5);
    _scrollerView.frame = CGRectMake(0, KNavigationBarHeight+1, KDeviceW, KDeviceH - KNavigationBarHeight-1);
    [self.view addSubview:_scrollerView];
    
    _selectArray = [[NSMutableArray alloc] init];
    UILabel *titlelabel = [[UILabel alloc] init];
    titlelabel.frame = CGRectMake(16, 18, self.view.frame.size.width - 32, 20);
    titlelabel.text = @"选择信息有误的部分";
    titlelabel.textColor = KRGB(153, 153, 153);
    titlelabel.font = KFont(14);
    [_scrollerView addSubview:titlelabel];
    
    ItemView *itemView = [[ItemView alloc] initWithframe:CGRectMake(0, CGRectGetMaxY(titlelabel.frame) + 10, self.view.frame.size.width, (self.squearList.count%4== 0?self.squearList.count/4:self.squearList.count/4+1 ) * (24 + 10) + 10) andArray:self.squearList andIsNeedImageView:YES andCurrentModel:self.currentSquareModel ];
    itemView.delegate = self;
    [_scrollerView addSubview:itemView];
    
    
    if (self.currentSquareModel != nil) {
        NSDictionary *dic = @{@"id":[NSString stringWithFormat:@"%@",self.currentSquareModel.menuid]};
        [_selectArray addObject:dic];
        
    }
    
    
    
    adviceView = [[UIView alloc] init];
    adviceView.frame =CGRectMake(PADDING, CGRectGetMaxY(itemView.frame) + 10, self.view.frame.size.width-PADDING*2 , 70);
    adviceView.backgroundColor = [UIColor whiteColor];
    adviceView.layer.cornerRadius = 4;
    [_scrollerView addSubview:adviceView];
    
    
    //建议框
    _adviceTextView = [self makeTextViewWithFrame:CGRectMake(5, 0,  self.view.frame.size.width - 37, 70) placeHolder:@"我们会收集您提交的请求，并在3~5个工作日回复"];
    _adviceTextView.tintColor  = KRGB(156, 156, 156);// [Utility hexStringToColor:@"#f2f3f5"];
    _adviceTextView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    [adviceView addSubview:_adviceTextView];
    _adviceTextView.font = KFont(12);

    //问题视图
    _questionView = [[UIView alloc]init];
    _questionView.frame = CGRectMake(0, adviceView.maxY, KDeviceW, 0);
    [_scrollerView addSubview:_questionView];
    

    //--------联系方式
    _contactView = [[UIView alloc]init];
    _contactView.backgroundColor = [UIColor whiteColor];
    _contactView.frame = CGRectMake(PADDING, _questionView.maxY+ 10, KDeviceW-PADDING*2, 40);
    _contactView.layer.cornerRadius = 4;
    _contactView.layer.borderWidth = .5;
    _contactView.layer.borderColor = KHexRGB(0xcccccc).CGColor;
    [_scrollerView addSubview:_contactView];
    
    UIImageView *phoneImgV = [[UIImageView alloc] initWithFrame:KFrame(0, 0, 11, 17)];
    phoneImgV.image = [UIImage imageNamed:@"手机icon"];
    
    //联系人输入框
    _contactTextField= [[MyTextField alloc] init];
    _contactTextField.delegate = self;
    _contactTextField.frame = CGRectMake(10,0, _contactView.width-20, 40);
    _contactTextField.backgroundColor = [UIColor whiteColor];
    _contactTextField.autocorrectionType=UITextAutocorrectionTypeNo;
    _contactTextField.font = KFont(12);
    _contactTextField.leftView = phoneImgV;
    _contactTextField.leftViewMode = UITextFieldViewModeAlways;
    _contactTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"您的联系电话" attributes:@{NSForegroundColorAttributeName:KHexRGB(0xcccccc)}];
    [_contactTextField setValue:KHexRGB(0xcccccc) forKeyPath:@"_placeholderLabel.textColor"];
    [_contactView addSubview:_contactTextField];
    
    //提交按钮
    _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitButton.frame = CGRectMake(PADDING, CGRectGetMaxY(_contactView.frame)+20, KDeviceW-PADDING*2,40);
    [_submitButton setTitle:@"确认" forState:UIControlStateNormal];
    //_submitButton.backgroundColor = KHexRGB(0x26c180);
    [_submitButton setBackgroundImage:KImageName(@"nearBar") forState:UIControlStateNormal];
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = 4;
    _submitButton.titleLabel.font = KFont(16);
    [_submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_scrollerView addSubview:_submitButton];
    
    _scrollerView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(_submitButton.frame)+20);
    
    //点击scrollerView任意出收起键盘
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrolllTap)];
    [_scrollerView addGestureRecognizer:tapGest];
    
    _lineView = lineView;
    _titleLab = titlelabel;
    _itemView = itemView;
    _phoneImgV = phoneImgV;
    
    
    [self loadData];
}



-(MyTextView *)makeTextViewWithFrame:(CGRect)frame placeHolder:(NSString*)title
{
    MyTextView* textView = [[MyTextView alloc]initWithFrame:frame];
    textView.placeholder = @"";
    textView.font = KFont(12);
    textView.backgroundColor = [UIColor whiteColor];
    textView.delegate = self;
    
    _placeHolderLab = [[UILabel alloc]init];
    _placeHolderLab.numberOfLines = 0;
    _placeHolderLab.backgroundColor = [UIColor clearColor];
    _placeHolderLab.font = textView.font;
    _placeHolderLab.textColor = KHexRGB(0xcccccc);//[UIColor grayColor];
    _placeHolderLab.textAlignment = NSTextAlignmentLeft;
    _placeHolderLab.text = title;
    CGFloat sizeHight = [Tools getHeightWithString:_placeHolderLab.text fontSize:12 maxWidth:KDeviceW - 20];
    
    _placeHolderLab.frame = CGRectMake(0, 0, KDeviceW - 30, sizeHight);
    [textView addSubview:_placeHolderLab];
    
    return textView;
}

//添加questionView
- (void)setQuestionItems{
    
    for (UIView *view in _questionView.subviews) {//清空_questionView子视图，重新添加
        [view removeFromSuperview];
    }
    UIView *lastView;
    for (int i = 0; i<_questionList.count; i++) {
        
        CGFloat y = lastView?lastView.maxY:0;
        QuestionItem *questionItem = [[QuestionItem alloc]initWithOriginY:y model:_questionList[i]];
        questionItem.delegate = self;
        [_questionView addSubview:questionItem];
        lastView = questionItem;
    }
    _questionView.frame = CGRectMake(0, adviceView.maxY+10, KDeviceW, lastView.maxY);
    _contactView.frame = CGRectMake(PADDING, _questionView.maxY+ 10, KDeviceW-PADDING*2, 40);
    _submitButton.frame = CGRectMake(PADDING, CGRectGetMaxY(_contactView.frame)+20, KDeviceW-PADDING*2,  42);
    _scrollerView.contentSize = CGSizeMake(KDeviceW, CGRectGetMaxY(_submitButton.frame)+20);
}

//移除提交的问题
- (void)removeQuestionItem:(ErrorModel *)errorModel{

    [_questionList enumerateObjectsUsingBlock:^(ErrorModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"______%@___%@",model.questionid,errorModel.questionid)
        if ([model.questionid isEqualToString:errorModel.questionid]) {
            
            [_questionList removeObject:model];
            *stop = YES;
        }
    }];
    
    NSLog(@"List_____%@",_questionList);
    [self setQuestionItems];//根据_questionList重设questionView
}

#pragma mark - load data请求问题列表
- (void)loadData{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *useid = USER.userID?USER.userID:@"";
    NSString *str = [NSString stringWithFormat:@"%@?userId=%@",KGetQuestionList,useid];
    KWeakSelf
    [MBProgressHUD showMessag:@"" toView:self.view];
    [RequestManager getWithURLString:str parameters:params success:^(id responseObject) {
        
        [MBProgressHUD hideHudToView:weakSelf.view animated:YES];
        if ([responseObject[@"result"] intValue] == 0) {
            [weakSelf.questionList addObjectsFromArray:[ErrorModel mj_objectArrayWithKeyValuesArray:responseObject[@"questionlist"]]];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"] toView:weakSelf.view];
        }
        [weakSelf setQuestionItems];
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHudToView:weakSelf.view animated:YES];
    }];

}

- (void)submitQuestion:(ErrorModel *)model answerModel:(AnswerModel *)answerModel{
    NSString *useid = USER.userID?USER.userID:@"";
    NSString *str = [NSString stringWithFormat:@"%@?questionid=%@&answerid=%@&userId=%@",KCommitQuestion,model.questionid,answerModel.answerid,useid];
    KWeakSelf
    [MBProgressHUD showMessag:@"" toView:self.view];
    [RequestManager postWithURLString:str parameters:nil success:^(id responseObject) {

        [MBProgressHUD hideHudToView:weakSelf.view animated:YES];
        if ([responseObject[@"result"] intValue] == 0) {
            [weakSelf removeQuestionItem:model];
            [MBProgressHUD showSuccess:@"已提交" toView:weakSelf.view];
        }else{
            [MBProgressHUD showError:responseObject[@"msg"] toView:weakSelf.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHudToView:weakSelf.view animated:YES];
    }];
}

#pragma mark - 提交按钮点击事件
-(void)submitClick
{
    [self closeBoard];
    if (_adviceTextView.text.length == 0 && _contactTextField.text.length == 0 && _selectArray.count == 0) {
        //[self showHUDErrorWithStatus:@"请输入您的纠错内容或意见"];
        [MBProgressHUD showError:@"请输入您的纠错内容或意见" toView:self.view];
        return;
    }
    

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_selectArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *contras = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.companyId forKey:@"companyid"];
    [paraDic setObject:self.companyName forKey:@"companyname"];
    [paraDic setObject:contras forKey:@"ids"];
    
    if (_adviceTextView.text) {
        [paraDic setObject:_adviceTextView.text forKey:@"suggest"];//建议
    }
    if (_contactTextField.text) {
        [paraDic setObject:_contactTextField.text forKey:@"contactinformation"];//联系方式
    }
    if (USER.userID) {
        [paraDic setObject:USER.userID forKey:@"userid"];
    }
    [paraDic setObject:self.companyName forKey:@"entname"];
    
    
    [MBProgressHUD showMessag:@"" toView:self.view];
    [RequestManager postWithURLString:KErrorCorrection parameters:paraDic success:^(id responseObject) {
        //NSLog(@"%@",responseObject);

        [MBProgressHUD hideHudToView:self.view animated:YES];
        
        if([[responseObject objectForKey:@"result"] intValue] == 0)
        {
            NSLog(@"纠错成功");
            
            [MBProgressHUD showSuccess:@"提交成功" toView:self.view];
            [self closeBoard];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self back];
            });
        }
        else
        {
            [MBProgressHUD showError:[responseObject objectForKey:@"msg"] toView:self.view];
            NSLog(@"纠错失败");
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
        //[MBProgressHUD showMessag:@"" toView:self.view];
        [MBProgressHUD showError:error.description toView:self.view];
    }];
    
}


#pragma mark - 九宫格的点击事件
-(void)ItemButtonClick:(ItemButton *)itemButton
{
    
    NSDictionary *dic = @{@"id":[NSString stringWithFormat:@"%@",itemButton.squareModel.menuid]};
    if ([_selectArray containsObject:dic]) {
        [_selectArray removeObject:dic];
        itemButton.backgroundColor = [UIColor whiteColor];
        itemButton.selected = NO;
//        itemButton.layer.borderColor = KNormalTextColor.CGColor;
        
    }else
    {
        [_selectArray addObject:dic];
        itemButton.backgroundColor = KRGB(73, 144, 245);
        itemButton.selected = YES;
//        itemButton.layer.borderColor = KHexRGB(0xf6996e).CGColor;
    }
}



#pragma mark - textViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
    [_placeHolderLab removeFromSuperview];
    CGPoint frame = [textView convertPoint:textView.frame.origin toView:self.view];
    [self upBoardWithAnimalWithFrame:frame];
    
    [self addMengBan];
}


-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        [textView addSubview:_placeHolderLab];
    }
    [self closeBoard];
}



#pragma mark - textFieldDelegatw
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //获取输入框在屏幕中的坐标点
    CGPoint frame = [textField convertPoint:textField.frame.origin toView:self.view];
    [self upBoardWithAnimalWithFrame:frame];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self closeBoard];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
  
    
    if ([string isEqualToString:@""])
    {
        return YES;
    }else  if (toBeString.length > 20)
    {
        return NO;
    }
    
    return YES;
}



- (void)textFieldDidChange:(UITextField *)textField

{
    
    if (textField.text.length > 20) {
        
        textField.text = [textField.text substringToIndex:20];
        
    }
    
}




-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self closeBoard];
    return YES;
}

-(void)scrolllTap
{
    [self closeBoard];
}


//关闭键盘
-(void)closeBoard
{
    [mengBanView removeFromSuperview];
    [_adviceTextView resignFirstResponder];
    [_contactTextField resignFirstResponder];

    [UIView animateWithDuration:0.5 animations:^{
        _scrollerView.contentOffset = CGPointMake(0, 0);
    } completion:^(BOOL finished) {
        
    }];
}


//展开键盘的动画
-(void)upBoardWithAnimalWithFrame:(CGPoint)frame
{
    CGFloat h = (self.view.frame.size.height-320 - frame.y - 186 * KScaleHight)/2;
    if (h < 0) {
        //输入框被键盘遮挡住
        [UIView animateWithDuration:0.5 animations:^{
            _scrollerView.contentOffset = CGPointMake(0, -h);
            
        } completion:^(BOOL finished) {
            
        }];
    }
}



-(void)addMengBan
{
    if (mengBanView == nil) {
        mengBanView = [[UIView alloc] init];
    }
    
    mengBanView.frame = CGRectMake(0, 0, KDeviceW, adviceView.frame.origin.y - 2);
    UIColor *color = [UIColor blackColor];
    mengBanView.backgroundColor = [color colorWithAlphaComponent:0.3];
    [_scrollerView addSubview:mengBanView];
    UITapGestureRecognizer *tapGetsr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mengBanTap)];
    [mengBanView addGestureRecognizer:tapGetsr];
    
}




-(void)mengBanTap
{
    [self closeBoard];
}

#pragma mark - 回答问题
- (void)didSelectQuestionItem:(QuestionItem *)item answerModel:(AnswerModel *)model{

    [self submitQuestion:item.model answerModel:model];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    //    [super viewWillAppear:animated];
    [self.navigationController.navigationBar fs_setBackgroundColor:KHomeNavigationBarBackGroundColor];
    
}

- (NSMutableArray *)questionViews{
    if (!_questionViews) {
        _questionViews = [NSMutableArray array];
    }
    return _questionViews;
}

- (NSMutableArray *)questionList{
    if (!_questionList) {
        _questionList = [NSMutableArray array];
    }
    return _questionList;
}


-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
