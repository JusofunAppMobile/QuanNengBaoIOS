//
//  ChangeIndustryOrAreaController.m
//  JuXin
//
//  Created by huang on 15/4/13.
//  Copyright (c) 2015年 huang. All rights reserved.
//

#import "ChangeIndustryOrAreaController.h"
#import "BaseCell.h"

@interface ChangeIndustryOrAreaController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *_requestURL;
    NSMutableArray *_saveDic;
    NSString *_provincename;
}
@property (nonatomic, assign) QueryType queryType;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSString *parentID;
@property (nonatomic, strong) NSDictionary *lastIndustry;
@property (nonatomic, assign,getter=isTopLevel) BOOL topLevel;
@property (nonatomic, assign) BOOL isJob;

@end

@implementation ChangeIndustryOrAreaController

#pragma mark - init
-(ChangeIndustryOrAreaController *)initWithQueryType:(QueryType)type {
    self = [super init];
    if (self) {
        self.queryType = type;
    }
    return self;
}

-(ChangeIndustryOrAreaController *)initWithQueryType:(QueryType)type andIsChangeJob:(BOOL)isJob{
    self = [super init];
    if (self) {
        self.queryType = type;
        self.isJob = isJob;
    }
    return self;
}

#pragma mark - setter
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:KFrame(0, KNavigationBarHeight, KDeviceW,KDeviceH-KNavigationBarHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}

-(void)loadData {
//    [self showHUD];
    __weak ChangeIndustryOrAreaController *weakSelf = self;
    NSDictionary *dict = @{@"parentid":self.parentID,
                           @"type":[NSString stringWithFormat:@"%ld",(long)self.queryType]};
    [RequestManager getWithURLString:GetPositionInfo parameters:dict success:^(id responseObject) {
        
        if ([responseObject[@"result"] integerValue] == 0) {
            
            [weakSelf.dataSource removeAllObjects];
//            NSArray *arrry = responseObject[@"datalist"];
//            _dataSource = [IndustryAndArea mj_objectArrayWithKeyValuesArray:arrry];
            [weakSelf.dataSource addObjectsFromArray:responseObject[@"datalist"][0][@"rlist"]];
            if (_isJob) {
                
            }else
            {
                if (!weakSelf.isTopLevel) {
                    //如果不是第一级行业列表前面添加一个不限选项
                    [weakSelf.dataSource insertObject:weakSelf.lastIndustry atIndex:0];
                }
                
            }
            //请求成功刷UI
            [weakSelf.tableView reloadData];
        }else{
            
            [MBProgressHUD showHint:responseObject[@"msg"] toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showHint:@"加载失败，请稍后重试" toView:self.view];
    }];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar fs_setBackgroundColor:KHomeNavigationBarBackGroundColor];
    //[_nav setupTitle:_queryType == QueryTypeIndustry?@"我的行业":@"城市"];
    if (_queryType == QueryTypeJob) {
//        [self setupTitle:@"选择职位"];
        self.title = @"选择职位";
        
    }else
    {
        self.title=_queryType == QueryTypeIndustry?@"我的行业":@"城市";
    }
    
    [self setNavigationBarTitle:@"选择职位" ];
//     [self.navigationController.navigationBar fs_setBackgroundColor:KNavigationBarBackGroundColor];

}

-(void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setBackBtn:@"back"];
    
    [self setBackBtn:@"back"];
   
    //self.automaticallyAdjustsScrollViewInsets = NO;
    self.dataSource = [NSMutableArray array];
    self.parentID = @"0";
    _saveDic = [[NSMutableArray alloc] init];
    self.topLevel = YES;
    [self loadData];
    [self.view addSubview:self.tableView];
}

#pragma mark - tableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[BaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    IndustryAndArea *model = _dataSource[indexPath.row];
    NSDictionary *dict = _dataSource[indexPath.row];
    if ([dict[@"haschild"] integerValue] == 1) {
        cell.ArrowImageView.hidden = NO;
    } else {
        cell.ArrowImageView.hidden = YES;
    }
    if (_lastIndustry && [_lastIndustry[@"childid"] isEqual:dict[@"childid"]] &&!_isJob) {
        cell.textLabel.text = @"不限";
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.textLabel.text = dict[@"name"];
    }
    return cell;
}



#pragma mark - 设置分割线从头开始
-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,10,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,10,0,0)];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}




#pragma mark - tableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = _dataSource[indexPath.row];
    if ([dict[@"haschild"] integerValue] == 1 && ![_lastIndustry[@"childid"] isEqual:dict[@"haschild"]]) {
        [_saveDic addObject:dict];
        
        self.topLevel = NO;
        [self setLastIndustry:dict];
        _provincename = dict[@"name"];
        self.parentID = dict[@"childid"] ;
        [self loadData];
    } else if(self.delegate && [self.delegate respondsToSelector:@selector(changeIndustryOrAreaCellSelected:andSaveDic:)]){
        //最后一级行业或者城市
        [self.delegate changeIndustryOrAreaCellSelected:dict andSaveDic:_saveDic];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
