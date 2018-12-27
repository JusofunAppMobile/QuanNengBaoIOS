//
//  ModifyCompanyViewController.m
//  EnterpriseInquiry
//
//  Created by Ching on 15/11/18.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import "ModifyCompanyViewController.h"
//#import "EnterpriseInquiry-Swift.h"
#import "BaseCell.h"

#import "CompnayTableViewController.h"

#define Back_COLOR [UIColor colorWithRed:235.0/255.0 green:236/255.0 blue:238/255.0 alpha:1.0];

#define SIZE_SCALE  ([UIScreen mainScreen].bounds.size.width / 320.0)
@interface ModifyCompanyViewController ()<UITextFieldDelegate,CompnayTableViewControllerDelegate>

@end

@implementation ModifyCompanyViewController
{
    NSString *_nameComPany;
    NSString *_searchText;
    UITextField *_textField;
    UITableView *_tableView;
    NSMutableArray *_companyModelArr;
    CompnayTableViewController *_compTable;
    
}

//-(void)changPosition:(Position_Message *)postModel{
//    
//}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setBackBtn:@""];
    [self textField];
    [self initWithTableView];
    _companyModelArr = [[NSMutableArray alloc]init];
    self.view.backgroundColor = Back_COLOR;
    [self setNavigationBarTitle:@"" ];
    [self setBackBtn:@"back"];
    [self setRightBarButton];
    // Do any additional setup after loading the view.
}
-(void)setRightBarButton{
    
    UIView *rightBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    UIButton *errorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    errorButton.frame = CGRectMake(0, 10, 50, 20);
    [errorButton setTitle:@"确定" forState:UIControlStateNormal];
    errorButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [errorButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [errorButton addTarget:self action:@selector(changeComPany) forControlEvents:UIControlEventTouchUpInside];
    [rightBarView addSubview:errorButton];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:rightBarView];
    self.navigationItem.rightBarButtonItem = rightBtn;
}
-(void)initWithTableView{
    
    _compTable = [[CompnayTableViewController alloc]init];
    _compTable.tableView.delegate = _compTable;
    _compTable.tableView.dataSource = _compTable;
    _compTable.view.frame = CGRectMake(0, 64 + 36 + 25*SIZE_SCALE, KDeviceW, self.view.frame.size.height - 64 - 36 - 25*SIZE_SCALE);
    _compTable.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _compTable.view.backgroundColor = [UIColor clearColor];
    [_compTable giveDelegate:self];
    [self.view addSubview:_compTable.view];
    
}
- (void)giveDelegate:(id<ModifyCompanyViewControllerDelegate>)delegate{
    self.delegate = delegate;
}
- (NSString *)getSelectCompanyName{
    
    return _nameComPany;
}
#pragma mark - CompnayDelegate

-(void)TextFieldresignFirstResponder{
    [_textField resignFirstResponder];
}
-(void)changeComPany{
    if (![_textField.text isEqual: @""] || _textField.text) {
        
        if (_textField.text.length <=2) {
//            [self showHUDErrorWithStatus:@"请输入不少于两个字的公司名"];
            [MBProgressHUD showHint:@"请输入不少于两个字的公司名" toView:self.view];
            return;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(ChoiceCompanyName:JobId:)]) {
            [self.delegate ChoiceCompanyName:_textField.text JobId:@""];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
//选择公司名
-(void)changComSelect:(NSDictionary *)compModel andCompanyName:(NSString *)companyName{
    
    NSString *string = compModel[@"companyname"];
    NSMutableAttributedString *str = [Tools titleNameWithTitle:string otherColor:[UIColor blackColor]];
    _nameComPany = [str string];
    if (self.delegate && [self.delegate respondsToSelector:@selector(ChoiceCompanyName:JobId:)]) {
        [self.delegate ChoiceCompanyName:_nameComPany JobId:compModel[@"companyid"]];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(UITextField *)textField
{
    if (!_textField) {
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 20*SIZE_SCALE + 64, self.view.frame.size.width - 20, 36)];
        
        if ( ![self.modifyName isEqualToString:@""] && ![self.modifyName isEqualToString:@"请输入公司名"]) {
            _textField.text = self.modifyName;
        }else{
            _textField.placeholder = @"请输入公司名";
        }
        
        
        _textField.textColor = [UIColor blackColor];
        _textField.font = [UIFont systemFontOfSize:15.f];
        _textField.delegate = self;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.backgroundColor = [UIColor whiteColor];
        UIView *backView = [[UIView alloc]init];
        backView.backgroundColor = [UIColor whiteColor];
        backView.frame = CGRectMake(0, _textField.frame.origin.y - 4, self.view.frame.size.width, 44);
        [self.view addSubview:backView];
        [self.view addSubview:_textField];
    }
    return _textField;
}
- (void)getModifyMessage{
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:_textField.text forKey:@"searchkey"];
    [RequestManager getWithURLString:GetSearchlightcompany parameters:paraDic success:^(id responseObject) {
        
        [_compTable.modelArr removeAllObjects];
        [_compTable.modelArr addObjectsFromArray:responseObject[@"companylist"]];
        [_compTable.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
//    NetWorkManager *networkManager=[NetWorkManager sharedInstance];
//    networkManager.ObjectClassInArray=@{@"companylist":[CompanyModel_companylistResultModel class]};
//    [networkManager getWithUrl:[Constant_Url entall_searchlightcompany] parameters:paraDic resultModelType:CompanyModel.class isEncryption:false success:^( id _Nonnull model) {
//        CompanyModel * bmodel= (CompanyModel *)model;
//        NSLog(@"%@",((CompanyModel_companylistResultModel *)bmodel.companylist.firstObject).companyname);
//        [_compTable.modelArr removeAllObjects];
//        [_compTable.modelArr addObjectsFromArray:bmodel.companylist];
//        [_compTable.tableView reloadData];
//    } failure:^(NSError * error) {
//        
//    }];
}
#pragma mark - uitextFieldDelegate

- (void)textViewDidChange:(UITextView *)textView{
    //第一次进入 赋值搜索
    if ([_searchText isEqualToString:textView.text]) {
        
        return;
    }else{
        [NSObject cancelPreviousPerformRequestsWithTarget:self];//可以成功取消全部。
        _searchText = textView.text;
        [self performSelector:@selector(getModifyMessage) withObject:nil afterDelay:2.0];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    [NSObject cancelPreviousPerformRequestsWithTarget:self];//可以成功取消全部。
    _searchText = textField.text;
    [self performSelector:@selector(getModifyMessage) withObject:nil afterDelay:2.0];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [_textField resignFirstResponder];
    
    return YES;
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
