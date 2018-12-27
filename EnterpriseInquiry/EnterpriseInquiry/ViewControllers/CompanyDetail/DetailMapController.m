//
//  DetailMapController.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 17/9/7.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "DetailMapController.h"

@interface DetailMapController ()
{
    NSDictionary *companyMapDic;
}
@end

@implementation DetailMapController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%ff",self.view.frame.size.height);
    [self createCompanyMap];
    
    
}

-(void)abnormalViewReload
{
    [self createCompanyMap];
}

#pragma mark - 企业图谱
-(void)createCompanyMap
{
    
    [MBProgressHUD showMessag:@"" toView:self.view];
    
    NSString *url = [NSString stringWithFormat:@"%@?entid=%@&entname=%@&userid=%@",GetEntAtlasData,self.companyId,self.companyName,USER.userID];
    NSString *requestURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [MBProgressHUD showMessag:@"" toView:self.view];
    [RequestManager getWithURLString:requestURL parameters:nil success:^(id responseObject) {
        [MBProgressHUD hideHudToView:self.view animated:YES];
        
        CompanyMapModel *compModel = [CompanyMapModel mj_objectWithKeyValues:responseObject];
        if([[responseObject objectForKey:@"result"] intValue] == 0)
        {
            companyMapDic = compModel.data;
            [self createCompanyMapWithNumDic:companyMapDic];
        }
        else
        {
            [MBProgressHUD showError:[responseObject objectForKey:@"msg"] toView:self.view];
            
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
        //[MBProgressHUD showMessag:@"" toView:self.view];
        [MBProgressHUD showError:@"请求失败,请稍后重试" toView:self.view];
       // [self showAbnormalViewWithMsg:@"网络不给力，请稍后重试" image:@"ServerCrash"];
    }];

    
}
#pragma mark - 有企业图谱
-(void)createCompanyMapWithNumDic:(NSDictionary *)Dic
{
    CompanyMap *companyView = [[CompanyMap alloc] initWithFrame:KFrame(0, KNavigationBarHeight, KDeviceW, KDeviceH -KNavigationBarHeight ) andDicInfo:Dic];
    companyView.delegate = self;
    [self.view addSubview: companyView ];
}

-(void)zhanKaiCompanyMap
{
    CompanyMapController *view = [[CompanyMapController alloc]init];
    view.entid = self.companyId;
    view.companyDic = companyMapDic;
    view.companyName = self.companyName;
    [self.navigationController pushViewController:view animated:YES];
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
