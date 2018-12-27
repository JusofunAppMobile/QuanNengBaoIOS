//
//  FeedBackVC.m
//  EnterpriseInquiry
//
//  Created by LEZ on 16/8/10.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "FeedBackVC.h"
//#import "nss"

@interface FeedBackVC ()<UITableViewDelegate,UITableViewDataSource>

{
    
    UITextView      *_inputView;
    UIScrollView    *_scrollView;
    
    UITableView     *_tableView;
    
    UIView          *_searchView;
}

@end

@implementation FeedBackVC

-(void)layout
{
    
    
    
    UILabel *lab = [[UILabel alloc] initWithFrame:KFrame(0, 40+KNavigationBarHeight, KDeviceW, 20)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"开始搜索";
    [self.view addSubview:lab];
    
    _tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0,KNavigationBarHeight, KDeviceW,KDeviceH)style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:_tableView];

    _searchView = [[UIView alloc] initWithFrame:KFrame(0, 0, KDeviceW, KDeviceH)];
    _searchView.backgroundColor = [UIColor redColor];
    _searchView.hidden = YES;
    [self.view addSubview:_searchView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:KFrame(KDeviceW-100, 10, 90, 44)];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [_searchView addSubview:button];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar fs_setBackgroundColor:KHomeNavigationBarBackGroundColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KHexRGB(0xf2f2f2);
//    //self.automaticallyAdjustsScrollViewInsets = YES;
    [self layout];
}


#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *identity = @"personCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identity];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identity];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        
    }
    

    return cell;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

    NSLog(@"%f",scrollView.contentOffset.y);
    CGFloat padding = scrollView.contentOffset.y;
    if (padding < -70) {
        
        [UIView animateWithDuration:0.3 animations:^{
            _tableView.frame = KFrame(0, KDeviceH, KDeviceW, KDeviceH);
        } completion:^(BOOL finished) {
            self.navigationController.navigationBar.hidden = YES;
            _searchView.hidden = NO;
            _tableView.frame = KFrame(0, KNavigationBarHeight, KDeviceW, KDeviceH);
        }];
    }
}

-(void)cancelAction
{

    self.navigationController.navigationBar.hidden = NO;
    _searchView.hidden = YES;
}

@end
