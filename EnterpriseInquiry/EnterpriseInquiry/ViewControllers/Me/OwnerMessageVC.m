//
//  OwnerMessageVC.m
//  EnterpriseInquiry
//
//  Created by LEZ on 16/8/10.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "OwnerMessageVC.h"
#import "SystemMessageCell.h"
#import "CompanyDetailController.h"
#import "CommonWebViewController.h"
#import "UITableView+NoData.h"

@interface OwnerMessageVC ()<UITableViewDelegate,UITableViewDataSource>

{
    
    UITableView         *_tableView;
    NSMutableArray      *_dataSource;
    
    int                 _p;
    UIImageView         *_loadFaildImage;
    UILabel             *_faildLable;
}
@end

@implementation OwnerMessageVC


-(void)layout
{
    
    _tableView = [[UITableView alloc] initWithFrame:KFrame(0, KNavigationBarHeight, KDeviceW, KDeviceH-KNavigationBarHeight)
                                              style:UITableViewStylePlain];
    _tableView.delegate         = self;
    _tableView.dataSource       = self;
    _tableView.backgroundColor  = [UIColor clearColor];
    _tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:_tableView];
    
    __weak typeof(self) weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _p = 1;
        [weakSelf refreshData];
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getMoreData];
    }];
    
}

-(void)getMoreData
{
    
    [self getDataFromNet:NO];
}

-(void)refreshData
{
    
    [self getDataFromNet:NO];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar fs_setBackgroundColor:KHomeNavigationBarBackGroundColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.automaticallyAdjustsScrollViewInsets = NO;
    [self setNavigationBarTitle:@"我的消息" ];
    [self setBackBtn:@"back"];
    
    USER.messageUnread = @"0";
    
    
    _p = 1;
    _dataSource = [NSMutableArray arrayWithCapacity:0];
    [self getDataFromNet:YES];
    [self layout];
}

-(void)getDataFromNet:(BOOL)loading
{
    if (loading) {
        [self showLoadDataAnimation];
    }
    NSString *userid = USER.userID;
    NSString *pageIndex = [NSString stringWithFormat:@"%d",_p];
    NSString *pageSize = @"10";
    NSDictionary *dict = @{
                           @"userid":userid,
                           @"PageIndex":pageIndex,
                           @"pagesize":pageSize,
                           };
    KWeakSelf
    [RequestManager getWithURLString:GetUserMessage parameters:dict success:^(id responseObject) {
        [weakSelf hideLoadDataAnimation];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if (_p == 1) {
            [_dataSource removeAllObjects];
        }
        if ([responseObject[@"result"] integerValue] == 0) {
            [_dataSource addObjectsFromArray:responseObject[@"systemlist"]];
            if ([responseObject[@"ismore"] boolValue]) {
                [_tableView.mj_footer resetNoMoreData];
            }else{
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [_tableView nd_reloadData];
            
            if (_dataSource.count > 0) {
                _loadFaildImage.hidden = YES;
                _faildLable.hidden = YES;
                _tableView.mj_footer.hidden = NO;
            }else{
            
                _loadFaildImage.hidden = NO;
                _faildLable.hidden = NO;
                _tableView.mj_footer.hidden = YES;
            }
            _p ++;
            
        }else{
            [MBProgressHUD showHint:responseObject[@"msg"] toView:self.view];

        }
        
    } failure:^(NSError *error) {
        if (loading) {
            [weakSelf showNetFailViewWithFrame:_tableView.frame];
        }
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}

-(void)abnormalViewReload
{
    [self getDataFromNet:YES];
}


-(void)editMessageWithAction:(NSString*)action row:(NSInteger)row
{

    //action--1--删除  action--2--标记已读
    NSString *userid = USER.userID;
    NSString *messageid = [NSString stringWithFormat:@"%@",_dataSource[row][@"id"]];
    NSDictionary *dict = @{
                           @"userid":userid,
                           @"messageid":messageid,
                           @"type":action,
                           };
    [RequestManager getWithURLString:EditUserMessage parameters:dict success:^(id responseObject) {
        
        if ([responseObject[@"result"] integerValue] == 0) {
            if ([action integerValue] == 1) {
                [_dataSource removeObjectAtIndex:row];
                
                [_tableView reloadData];
            }else{
            
                for (int i = 0; i < _dataSource.count; i++) {
                    if (i == row) {
                        
                        NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:_dataSource[i]];
                        NSString *readType =  [temp objectForKey:@"read"];
                        if ([readType integerValue] == 0) {
                            [KNotificationCenter postNotificationName:MESSAGEREADED_NOTIFI object:nil];
                        }
                        
                        [temp setValue:@"1" forKey:@"read"];
                        
                        [_dataSource replaceObjectAtIndex:i withObject:temp];
                       
                        [_tableView reloadData];
                       
                       
                        
                       
                        break;
                        
                    }
                }
                
                
            }
        }else{
        
            if ([action integerValue] == 1) {
//                [MBProgressHUD showMessag:@"删除失败" toView:self.view];
                [MBProgressHUD showHint:@"删除失败" toView:self.view];
            }else{
            
            }
        }
        
    } failure:^(NSError *error) {
        
//        [MBProgressHUD showMessag:@"网络错误！" toView:self.view];
        [MBProgressHUD showHint:@"网络错误！" toView:self.view];
    }];
    
}

#pragma mark -- tableview   delegate datasource  -methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    SystemMessageCell *cell = (SystemMessageCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell.frame.size.height;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dataSource.count;
//    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellString = @"AccountCellString";
    SystemMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (!cell) {
        cell = [[SystemMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    if (_dataSource.count > 0) {
        NSDictionary *dict = _dataSource[indexPath.row];
        [cell cellDataWith:dict];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self editMessageWithAction:@"2" row:indexPath.row];
    NSDictionary *dict = _dataSource[indexPath.row];
    NSString *theType = [NSString stringWithFormat:@"%@",dict[@"type"]];
    if ([theType isEqualToString:@"1"]) {
        //企业详情
        CompanyDetailController *company = [[CompanyDetailController alloc]init];
        company.companyName = @"";
        company.companyId = dict[@"objectid"];
        [self.navigationController pushViewController:company animated:YES];
        
    }else if ([theType isEqualToString:@"2"]){
        //H5界面
        CommonWebViewController *probVC = [[CommonWebViewController alloc]init];
        probVC.titleStr = dict[@"title"];
        probVC.urlStr = dict[@"h5url"];
        [self.navigationController pushViewController:probVC animated:YES];
    }else{
        //其他类型 不可点击
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.000001;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self editMessageWithAction:@"1" row:indexPath.row];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}



@end
