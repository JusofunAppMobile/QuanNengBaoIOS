//
//  HotInformationController.m
//  EnterpriseInquiry
//
//  Created by 方首滔 on 16/9/22.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "HotInformationController.h"
#import "HotInformationCell.h"
#import "CommonWebViewController.h"
#import "HotNewsModel.h"
#import "NewsModel.h"
#define KIdentifier @"HotInformationCell"


@interface HotInformationController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *HotInforimationTableview;
@property (nonatomic,strong)NSMutableArray *HotInformationArray;
@property (nonatomic,assign)NSInteger  pageIndex;
@property (nonatomic,strong)HotNewsModel *model;
@property (nonatomic,strong)NSMutableArray *HotnewAarry;
@end

@implementation HotInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageIndex = 1;
    
    [self setNavigationBarTitle:@"热门资讯" ];
    [self setBackBtn:@"back"];
    [self.view addSubview:self.HotInforimationTableview];
//    if (@available(iOS 11.0, *)) {
//        self.HotInforimationTableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    } else {
//        //self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    [self setupRefresh];
    [self loadData];

     //self.navigationController.navigationBar.translucent=NO;
    self.HotInforimationTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
   
   
}


-(void)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
   
    [self.navigationController.navigationBar fs_setBackgroundColor:KHomeNavigationBarBackGroundColor];
}

-(void)viewWillDisappear:(BOOL)animated
{
     //self.navigationController.navigationBar.translucent=YES;
}

#pragma mark 网络数据请求
-(void)loadData{
    
    [MBProgressHUD showMessag:@"" toView:self.view];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:@"20" forKey:@"pageSize"];
    [parameter setObject:[NSString stringWithFormat:@"%ld",(long)_pageIndex] forKey:@"pageIndex"];

    [RequestManager postWithURLString:SearchInformationList parameters:parameter success:^(id responseObject) {
        [self endRefresh];
        [MBProgressHUD hideHudToView:self.view animated:YES];
        if ([responseObject[@"result"] integerValue] == 0) {
                self.model = [HotNewsModel mj_objectWithKeyValues:responseObject];
            
            if (_pageIndex == 1) {
                [self.HotnewAarry removeAllObjects];
            }[self.HotnewAarry  addObjectsFromArray:self.model.hotnewslist];
           
            [self.HotInforimationTableview reloadData];
            
    }
        
        else{
            _pageIndex--;
            [self endRefresh];
            [MBProgressHUD showError:responseObject[@"msg"] toView:self.view];
        }
        
            } failure:^(NSError *error) {
            _pageIndex--;
            [self endRefresh];
            [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error] toView:self.view];
    }];
    
}


#pragma mark - 刷新 上拉  下拉
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    
    __weak typeof(self) weakSelf          = self;
    
 
    self.HotInforimationTableview.mj_header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageIndex  = 1;
        [weakSelf loadData ];
    }];
    // 1.下拉刷新(进入刷新状态就会调用self的footerRereshing)
    self.HotInforimationTableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
         _pageIndex++;
        [weakSelf loadData];
    }];
  
}

#pragma mark -统计热门资讯的阅读数

-(void)endRefresh{
    [self.HotInforimationTableview.mj_header endRefreshing];
    [self.HotInforimationTableview.mj_footer endRefreshing];
    
}

-(void)readyCountWithNewsId:(NSString *)newsId
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:newsId forKey:@"newsid"];
    [RequestManager postWithURLString:InformationReadCount parameters:parameter success:^(id responseObject) {
        //不管成功失败，只是告诉服务器
        if ([responseObject[@"result"] integerValue] == 0) {
            NSLog(@"统计成功");
        }else
        {
            NSLog(@"统计失败");
        }
    } failure:^(NSError *error) {
        NSLog(@"error %@",error.description);
    }];
    
}



#pragma mark delegate


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.HotnewAarry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    HotInformationCell  *cell = [tableView  dequeueReusableCellWithIdentifier:KIdentifier ];
    
    if (!cell) {
        cell = [[HotInformationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.HotnewAarry.count >0) {
        cell.newsModel = [_HotnewAarry objectAtIndex:indexPath.row];
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [MobClick event:@"Hotlist94"];//热门资讯列表－资讯条目点击数
    NewsModel *model = self.HotnewAarry[indexPath.row];
     [self readyCountWithNewsId:[NSString stringWithFormat:@"%@",model.newsid]];//统计阅读数
    CommonWebViewController *commomwevView = [[CommonWebViewController alloc] init];
    commomwevView.titleStr = @"热门资讯";
    commomwevView.isNeedShare = YES;
    commomwevView.webType = newsType;
    commomwevView.urlStr = [NSString stringWithFormat:@"%@",model.newdetailurl];
    [self.navigationController pushViewController:commomwevView animated:YES];
    
}


#pragma mark 懒加载
-(UITableView *)HotInforimationTableview{
    
    if (_HotInforimationTableview == nil) {
        _HotInforimationTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, KNavigationBarHeight, KDeviceW, KDeviceH-KNavigationBarHeight)style:UITableViewStylePlain];
        _HotInforimationTableview.delegate = self;
        _HotInforimationTableview.dataSource = self;
    }
    return _HotInforimationTableview;
}

-(NSMutableArray *)HotnewAarry{
    
    if (_HotnewAarry == nil) {
        _HotnewAarry = [[NSMutableArray alloc]init];
        
    }
    return _HotnewAarry;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
