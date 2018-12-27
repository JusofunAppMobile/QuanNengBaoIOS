//
//  NearListController.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 2017/12/21.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "NearListController.h"

@interface NearListController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    BlankSpaceView *blankSpaceView;

    UILabel *countLabel;
    NSURLSessionDataTask *requestTask;
}

@end

@implementation NearListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
   
    _dataArray = [[NSMutableArray alloc] init];
   
    [self createTableView];
}

#pragma mark -  请求数据
-(void)loadData
{
    if(requestTask)
    {
        [requestTask cancel];
    }
 
    NSString *url = [NSString stringWithFormat:@"%@?maptype=%d&currentlatlng=%f,%f&pageindex=%d&mycoordinate=%f,%f&province=%@&city=%@&pageSize=20&maxLat=%f&minLat=%f&maxLng=%f&minLng=%f",kGetMapCompanyList,KNear.maptype,KNear.mapCenterLat,KNear.mapCenterLng,_loadNum,KNear.userLat,KNear.userLng,KNear.province,KNear.city,KNear.mapMinPoint.latitude,KNear.mapMaxPoint.latitude,KNear.mapMaxPoint.longitude,KNear.mapMinPoint.longitude];
    if(blankSpaceView)
    {
        [blankSpaceView removeFromSuperview];
        blankSpaceView = nil;
    }
    KBolckSelf;
   url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //网络请求
    [MBProgressHUD showMessag:@"" toView:self.view];
   requestTask = [RequestManager getWithURLString:url parameters:nil success:^(id response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [ blockSelf.dataTableView.mj_header endRefreshing];
        [blockSelf.dataTableView.mj_footer endRefreshing];
       NSLog(@"地图列表数据==%@",response);
        if(blankSpaceView)
        {
            [blankSpaceView removeFromSuperview];
            blankSpaceView = nil;
        }

        if([[response objectForKey:@"result"] intValue] == 0)
        {
            NSArray *tmpArray = [NearCompanyModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"] ];
            
            if (tmpArray.count <20)
            {
                [blockSelf.dataTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            if(blockSelf.loadNum == 1)
            {
                [blockSelf setCountLabel:[response objectForKey:@"total"]];
                [blockSelf.dataArray removeAllObjects];
                blockSelf.dataArray = [NSMutableArray arrayWithCapacity:1];
            }
            if(tmpArray.count == 0)
            {
                [blockSelf performSelector:@selector(showNothingView:) withObject:nil afterDelay:0.3];
            }
            
            [blockSelf.dataArray addObjectsFromArray:tmpArray];

           
            [blockSelf.dataTableView reloadData];
            blockSelf.loadNum ++;
        }
        else
        {
            [MBProgressHUD hideHUDForView:blockSelf.view animated:YES];
            [blockSelf.dataArray removeAllObjects];
            [_dataTableView reloadData];
            [blockSelf performSelector:@selector(showNothingView:) withObject:[response objectForKey:@"msg"] afterDelay:0.3];
        }
       
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:blockSelf.view animated:YES];
        
        if(error.code == -999)//取消请求
        {
            return ;
        }
        
        [blockSelf.dataTableView.mj_header endRefreshing];
        [blockSelf.dataTableView.mj_footer endRefreshing];
        if(blockSelf.dataArray.count > 0)
        {
            [MBProgressHUD showError:@"加载失败，请重新加载" toView:blockSelf.view];
        }
        else
        {
            
            [blockSelf performSelector:@selector(showNothingView:) withObject:@"连接失败,请检查你的网络设置" afterDelay:0.3];
        }
        
        
    }];
}

-(void)showNothingView:(NSString*)str
{
    if(blankSpaceView)
    {
        [blankSpaceView removeFromSuperview];
        blankSpaceView = nil;
    }
    
    
    // NSString * str = @"连接失败,请检查你的网络设置";
    if(str.length >0)
    {
        // str = @"连接失败,请检查你的网络设置";
        blankSpaceView = [[BlankSpaceView alloc] initWithFrame:KFrame(0, KNavigationBarHeight, KDeviceW, KDeviceH - KNavigationBarHeight) image:@"faild" text:str];
        blankSpaceView.delegate = self;
        [self.view insertSubview:blankSpaceView belowSubview:_dataTableView];
    }
    else
    {
        str = @"暂无符合您条件的企业";
        blankSpaceView = [[BlankSpaceView alloc] initWithFrame:KFrame(0, KNavigationBarHeight, KDeviceW, KDeviceH - 64 -KNavigationBarHeight) image:@"find" text:str];
        [self.view insertSubview:blankSpaceView belowSubview:_dataTableView];
    }
}
-(void)blankSpaceViewTag
{
    [MBProgressHUD showMessag:@"" toView:self.view];
    [self loadData];
}

-(void)setCountLabel:(NSString *)str2
{
    str2 = [NSString stringWithFormat:@"%@",str2];
    NSString *str1 = @"  共匹配到 ";
    NSString *str3 = @" 家公司";
    NSString *allStr = [NSString stringWithFormat:@"%@%@%@",str1,str2,str3];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:allStr];
    
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(0, allStr.length)];
    
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:KRGB(154, 154, 154)
                          range:NSMakeRange(0, str1.length)];
    
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:KRGB(252, 144, 79)
                          range:NSMakeRange(str1.length,str2.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:KRGB(154, 154, 154)
                          range:NSMakeRange(str1.length+str2.length,str3.length)];
    
    countLabel.attributedText = attributedStr;
}

#pragma mark -tableView  delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identity = @"mapList";
    NearListCell *cell = [tableView dequeueReusableCellWithIdentifier:Identity];
    if (!cell) {
        cell = [[NearListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identity];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.companyModel = [self.dataArray objectAtIndex:indexPath.row];
//    cell.isSearch =  NO;
//    cell.isMapList = YES;
//    [cell setFrameWithModel:[self.dataArray objectAtIndex:indexPath.row]];
//    [cell reloadCellColor];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 175;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NearCompanyModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    NearDetailController *indo = [[NearDetailController alloc]init];
    //indo.companyModel = model;
    indo.companyName = model.name;
    indo.companyId = model.companyId;
    indo.mycoordinate = self.MyCoordinate.location.coordinate;
    [self.navigationController pushViewController:indo animated:YES];
    
    return;

}



-(void )createTableView
{
    countLabel = [[UILabel alloc]initWithFrame:KFrame(0, KNavigationBarHeight, KDeviceW, 30)];
    countLabel.backgroundColor = KRGB(248, 248, 248);
    countLabel.font = KFont(14);
    [self.view addSubview:countLabel];
    
    _dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, countLabel.maxY, KDeviceW, KDeviceH - KNavigationBarHeight-countLabel.height) style:UITableViewStylePlain];
    _dataTableView.delegate = self;
    _dataTableView.dataSource = self;
    _dataTableView.backgroundColor = [UIColor whiteColor];
    _dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _dataTableView.tableFooterView = [[UIView alloc] init];
    _dataTableView.estimatedRowHeight = 0;
    _dataTableView.estimatedSectionHeaderHeight = 0;
    _dataTableView.estimatedSectionFooterHeight = 0;
    __weak typeof(self) weakSelf = self;
    
    _dataTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        _loadNum = 1;
        [weakSelf loadData];
    }];
    _dataTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    
    [self.view addSubview:_dataTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
