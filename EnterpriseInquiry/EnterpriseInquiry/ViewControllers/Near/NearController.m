//
//  NearController.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 2017/12/21.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "NearController.h"

@interface NearController ()
{
    UIButton *rightBtn;
    BOOL isShowList;
}

@end

@implementation NearController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar fs_setBackgroundColor:[UIColor whiteColor]];
    isShowList = YES;

    [self setNavigationBarTitle:@"企业列表" ];
    [self setBackBtn];
    [self setRightBarBtn];
    [self initControllers];
    
   
    [self changeViewController];
}

#pragma mark - 初始化控制器
- (void)initControllers{
    
    KBolckSelf;
    
    _listController = [[NearListController alloc]init];
    
    _mapController = [[NearMapController alloc]init];
    _mapController.getLocationBlock = ^{
        [blockSelf changeViewController];
    };
    

}


-(void)changeViewController
{
    if(isShowList)
    {
        [rightBtn setImage:KImageName(@"nearList") forState:UIControlStateNormal];
        [self displayViewController:_mapController];
        [self setNavigationBarTitle:@"附近企业" andTextColor:[UIColor blackColor]];
        
    }
    else
    {
        if(KNear.mapCenterLat ==  0)
        {
            [MBProgressHUD showHint:@"正在加载地图信息，请稍等" toView:nil];
            return;
        }
        
        [rightBtn setImage:KImageName(@"nearMap") forState:UIControlStateNormal];
        [self displayViewController:_listController];
        [self setNavigationBarTitle:@"企业列表" andTextColor:[UIColor blackColor]];
        
        if(KNear.isMapChange)
        {
            _listController.loadNum = 1;
            [_listController loadData];
            KNear.isMapChange = NO;
        }
    }
    
    isShowList = !isShowList;
}

#pragma mark - 返回
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setBackBtn
{
    
    UIButton* backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    //backBtn.frame = CGRectMake(-8, (44 - 18)/2, 10, 16);
    [backBtn setImage:KImageName(@"back") forState:UIControlStateNormal];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    //backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* reloadBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    reloadBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    [reloadBtn setImage:KImageName(@"刷新") forState:UIControlStateNormal];
    reloadBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [reloadBtn addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    //UIBarButtonItem* reloadItem = [[UIBarButtonItem alloc]initWithCustomView:reloadBtn];
    
    self.navigationItem.leftBarButtonItems = @[leftItem];
}

//创建navigaiton上的东西
-(void)setRightBarBtn
{
    
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:KImageName(@"nearList") forState:UIControlStateNormal];
   // rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0,-10);
    rightBtn.frame = CGRectMake(0, 0, 44, 44);
    [rightBtn setTitleColor:KHexRGB(0xffffff) forState:UIControlStateNormal];
    rightBtn.titleLabel.font = KNormalFont;
    [rightBtn addTarget:self action:@selector(changeViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}
- (void)displayViewController:(UIViewController *)controller {
    
    if (!controller) {
        return;
    }
    
    UIViewController *oldController ;
    
  
    
    [self addChildViewController:controller];
    
    [self.view addSubview:controller.view];
    
    [controller didMoveToParentViewController:self];
    
    if(controller == _listController)
    {
        [self hideViewController:_mapController];
        oldController = _mapController;
    }
    else
    {
        [self hideViewController:_listController];
        oldController = _listController;
    }
    
}

- (void)hideViewController:(UIViewController *)controller {
    
    if (!controller) {
        return;
    }
    [controller willMoveToParentViewController:nil];
    
    [controller.view removeFromSuperview];
    
    [controller removeFromParentViewController];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapController.nearMapView dataMapViewWillDisappear];
}

-(void)viewWillAppear:(BOOL)animated
{
    [_mapController.nearMapView dataMapViewWillAppear];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"附近xiao'shi");
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
