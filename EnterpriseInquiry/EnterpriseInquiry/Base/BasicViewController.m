//
//  BasicViewController.m
//  框架
//
//  Created by WangZhipeng on 16/5/18.
//  Copyright © 2016年 WangZhipeng. All rights reserved.
//

#import "BasicViewController.h"

@interface BasicViewController ()

@end

@implementation BasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KHexRGB(0xf8f8fa);
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar fs_setBackgroundColor:KNavigationBarBackGroundColor];
}

-(void)setNavigationBarTitle:(NSString *)title
{
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:KNavigationTitleFontSize],NSForegroundColorAttributeName:[UIColor blackColor]}];
//    self.title = title;
    [self setNavigationBarTitle:title andTextColor:[UIColor blackColor]];
}

/**
 *  设置导航文字，自定义字体颜色和内容
 *
 *  @param title 标题
 *  @param color 颜色
 */
-(void)setNavigationBarTitle:(NSString *)title andTextColor:(UIColor *)color
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:KFont(KNavigationTitleFontSize),NSForegroundColorAttributeName:color}];
    self.title = title;

}



/**
 *  展示加载失败的页面
 *
 *  @param msg 提示语
 */
- (void)showNetFailViewWithFrame:(CGRect)frame{
    
    [self hideLoadDataAnimation];
    
    if (CGRectEqualToRect(CGRectZero, frame)) {
        frame = self.view.bounds;
    }
    if (_netFailView) {
        [_netFailView removeFromSuperview];
    }else{
        _netFailView = [[NetworkFailedView alloc]initWithFrame:frame];
        _netFailView.delegate = self;
    }
    [self.view addSubview:_netFailView];
    [self.view bringSubviewToFront:_netFailView];
}



/**
 *  隐藏加载失败的页面
 */
- (void)hideNetFailView{
    [_netFailView removeFromSuperview];
}

- (void)networkReload{
    [self abnormalViewReload];
}


/**
 *  加载失败动画点击重新加载方法
 */
-(void)abnormalViewReload
{
    
}


-(void)setBackBtn:(NSString *)imageName
{
    
    UIButton *backGroundButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    backGroundButton.backgroundColor = [UIColor clearColor];
    
    UIButton* backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    if(imageName.length == 0)
    {
        backBtn.frame = CGRectMake(- 4, 0, 44, 44);
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [backBtn setTitleColor:KHexRGB(0x999999) forState:UIControlStateNormal];
        backBtn.titleLabel.font = KNormalFont;
    }
    else
    {
//        imageName = @"返回";
        backBtn.frame = CGRectMake(-0, (44 - 18)/2, 10, 16);
        [backBtn setImage:[Tools scaleImage:KImageName(imageName) size:backBtn.size] forState:UIControlStateNormal];
    }
    
    
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backGroundButton addSubview:backBtn];
    [backGroundButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithCustomView:backGroundButton];
    
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

//加载数据动画
-(void)showLoadDataAnimation{
    [self hideNetFailView];
    [self.view addSubview:self.loadingAnimationView];
    [self.view bringSubviewToFront:self.loadingAnimationView];
    [self.loadingAnimationView startAnimation];
}


-(void)hideLoadDataAnimation{
    [_loadingAnimationView stopAnimation];
    [_loadingAnimationView removeFromSuperview];
}

-(LoadingAnimatedView *)loadingAnimationView
{
    if (!_loadingAnimationView) {
        CGFloat width = KDeviceW;
        CGFloat hight = KDeviceH ;
        if (width > hight) {
            _loadingAnimationView = [[LoadingAnimatedView alloc]initWithFrame:CGRectMake(0, 0, hight, width)];
        }else{
            _loadingAnimationView = [[LoadingAnimatedView alloc]initWithFrame:CGRectMake(0, 0, width, hight)];
        }
    }
    
    return _loadingAnimationView;
}

// 支持屏幕旋转
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait /*| UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight*/);
}

// 不自动旋转
- (BOOL)shouldAutorotate
{
    return NO;
}

//
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return (UIInterfaceOrientationPortrait /*| UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight*/);
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
