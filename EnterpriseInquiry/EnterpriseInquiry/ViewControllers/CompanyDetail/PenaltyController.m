//
//  PenaltyController.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 2018/1/8.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import "PenaltyController.h"
#import "PenaltyCell.h"
#import "UITableView+NoData.h"
@interface PenaltyController ()
{
    UITableView *backTableView;
    int pageIndex;
    NSMutableArray *dataArray;
    UILabel *countLabel;
}
@end

@implementation PenaltyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    [self drawTableView];
}


-(void)loadData:(BOOL)loading
{
    if (loading) {
        [self showLoadDataAnimation];
    }
    KWeakSelf;
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:self.companyId forKey:@"companyid"];
    [paraDic setObject:self.companyName forKey:@"companyname"];
    [paraDic setObject:USER.userID forKey:@"userid"];
    [paraDic setObject:self.companyName forKey:@"entname"];
    [paraDic setObject:@"20" forKey:@"pageSize"];
    [paraDic setObject:[NSNumber numberWithInt:pageIndex] forKey:@"pageIndex"];
    [RequestManager getWithURLString:KGetPenalty parameters:paraDic success:^(id responseObject) {
        [weakSelf hideLoadDataAnimation];
        [weakSelf endRefresh];

        if([[responseObject objectForKey:@"result"] intValue] == 0)
        {
            if(pageIndex == 1)
            {
                dataArray = [NSMutableArray arrayWithCapacity:1];
                [weakSelf setCountLabel:[responseObject objectForKey:@"totalCount"]];
            }
            [dataArray addObjectsFromArray:[responseObject objectForKey:@"dataResult"]];
            [backTableView nd_reloadData];
            if(dataArray.count >= [[responseObject objectForKey:@"totalCount"] intValue])
            {
                [backTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            pageIndex ++;
        }
        else
        {
            [MBProgressHUD showError:[responseObject objectForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
        if (loading) {
            [weakSelf showNetFailViewWithFrame:KFrame(0, KNavigationBarHeight, KDeviceW, KDeviceH-KNavigationBarHeight)];
        }
        [weakSelf endRefresh];
    }];
    
}

- (void)abnormalViewReload{
    [self loadData:YES];
}

-(void)setCountLabel:(NSString *)str2
{
    str2 = [NSString stringWithFormat:@"%@",str2];
    NSString *str1 = @"  共匹配到 ";
    NSString *str3 = @" 个行政处罚";
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

-(void)endRefresh
{
    [backTableView.mj_header endRefreshing];
    [backTableView.mj_footer endRefreshing];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [dataArray objectAtIndex:indexPath.row];
    
    
    CommonWebViewController *commomwevView = [[CommonWebViewController alloc] init];
    commomwevView.titleStr = @"行政处罚";
    commomwevView.urlStr = [dic objectForKey:@"url"];
    commomwevView.dataDic = dic;
    [self.navigationController pushViewController:commomwevView animated:YES];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ideterfir = @"ideterfir";
    
    PenaltyCell *cell = [tableView dequeueReusableCellWithIdentifier:ideterfir];
    if(!cell)
    {
        cell = [[PenaltyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ideterfir];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *dic = [dataArray objectAtIndex:indexPath.row];
    
    cell.numLabel.text = [dic objectForKey:@"bookNumber"];
    cell.typeLabel.text = [dic objectForKey:@"legalType"];
    cell.dateLabel.text = [dic objectForKey:@"punishmentDate"];
    
    return cell;
}


-(void)drawTableView
{
    countLabel = [[UILabel alloc]initWithFrame:KFrame(0, KNavigationBarHeight, KDeviceW, 30)];
    countLabel.backgroundColor = KRGB(255, 250, 245);
    countLabel.font = KFont(14);
    [self.view addSubview:countLabel];
    
    backTableView = [[UITableView alloc]initWithFrame:KFrame(0, countLabel.maxY, KDeviceW, KDeviceH-KNavigationBarHeight - countLabel.height) style:UITableViewStylePlain];
    backTableView.delegate = self;
    backTableView.dataSource = self;
    backTableView.rowHeight = 115;
    backTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    backTableView.estimatedRowHeight = 0;
    backTableView.estimatedSectionHeaderHeight = 0;
    backTableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:backTableView];
    
    KWeakSelf;
    
    backTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageIndex = 1;
        [weakSelf loadData:NO];
    }];
    [backTableView.mj_header beginRefreshing];
    backTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadData:NO];
    }];
    
}


@end