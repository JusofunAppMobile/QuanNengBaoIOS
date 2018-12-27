
//
//  HelpViewController.m
//  EnterpriseInquiry
//
//  Created by clj on 16/8/10.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "HelpViewController.h"
#import <JDFlipNumberView/JDFlipNumberView.h>
#import "HelpCell.h"

#import "AppDelegate.h"
#import "UIView+BorderLine.h"

#define NUMBER_H 45*(KDeviceW/375.f)
#define NUMBER_W 30*(KDeviceW/375.f)


//#define helpHeadHeight 267 //帮助页的头部高度

@implementation HelpViewController
{
    UITableView *_tableView;
    JDFlipNumberView *hundredFlipNumberView;//百位
    JDFlipNumberView *tenThousandFlipNumberView;//十万位
    JDFlipNumberView *millionFlipNumberView;//亿位
    UIImageView *firstDouHaoImageView;
    UIImageView *secondDouHaoImageView;
    //    UIImageView *logoImageView ;//应用logo
    //    UILabel *descLabel;//应用介绍
    HelpModel *helpModel;
    
    NSTimer *fanPaiTimer;//翻牌的定时器
    NSInteger startNumber;
    
    CGFloat HeaderAlpha;//导航栏的不透明度
    
    UIImageView *mainHeadImageView;//头部图片
    ZZCarouselControl *zzCarouseView;//轮播图
    
    BOOL isFirst;//判断是否第一次请求网络
    BOOL isForeground;//判断是否在后台
    BOOL isload;//判断左右滑动是否刷新
    
    int faileNum;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    CGFloat offsetY = _mainScrollView.contentOffset.y;
//    CGFloat alpha = (offsetY - HomeScrollBase)/HomeScrollBase;
//    HeaderAlpha = MIN(alpha, 1);
//    [self.navigationController.navigationBar fs_setBackgroundColor:[KHomeNavigationBarBackGroundColor colorWithAlphaComponent:HeaderAlpha]];
//    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
//    [appDelegate.pageViewController setNavigationBarColor:[UIColor clearColor]];
    
    [self.navigationController.navigationBar fs_setBackgroundColor:[UIColor clearColor]];
    faileNum = 0;
}

-(void)viewDidLoad
{
    
    [self createMainScrollView];
   
    isFirst = YES;
    isForeground = YES;
    isload = NO;
    [self loadHelpData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive)   name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground)    name:UIApplicationDidEnterBackgroundNotification object:nil];
}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (isload) {
        if (startNumber > 100000) {
            //    //
            //    //已进入页面就重置，防止数字显示错误
            [millionFlipNumberView setValue:000 animated:NO];
            [tenThousandFlipNumberView setValue:000 animated:NO];
            [hundredFlipNumberView setValue:000 animated:NO];
            [self setFlipNumWithStart:startNumber andIsAnimaite:NO];
        }
    }
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //    _isScrollToHelp = YES;
}


-(void)becomeActive
{
    isForeground = YES;
    if (isload) {
        if (startNumber > 100000) {
            
            [millionFlipNumberView setValue:000 animated:NO];
            [tenThousandFlipNumberView setValue:000 animated:NO];
            [hundredFlipNumberView setValue:000 animated:NO];
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            NSString *formattedStr = [formatter stringFromNumber:[NSNumber numberWithInteger:startNumber]];
            
            NSArray *numsArray = [formattedStr componentsSeparatedByString:@","];//将格式化的数字以逗号分隔
            if(numsArray.count >=3)
            {
                NSString *millionStr = numsArray[0];
                NSString *tenThousandStr = numsArray[1];
                NSString *hundredStr = numsArray[2];
                [millionFlipNumberView setValue:[millionStr integerValue] animated:NO];
                [tenThousandFlipNumberView setValue:[tenThousandStr integerValue] animated:NO];
                [hundredFlipNumberView setValue:[hundredStr integerValue] animated:NO];
                
            }
            
        }
    }
}

-(void)didEnterBackground
{
    isForeground = NO;
}



-(void)loadHelpData
{
    faileNum ++;
    KWeakSelf;
    [RequestManager postWithURLString:GetHelperTxt parameters:nil success:^(id responseObject) {
        // 请求成功
        if ([responseObject[@"result"] integerValue] == 0) {
            isload = YES;
            helpModel = [HelpModel mj_objectWithKeyValues:responseObject];
            if (isFirst) {
                [_tableView reloadData];
                [self refreshHeadView];
                [zzCarouseView reloadData];
                isFirst = NO;
            }else
            {
                
            }
        }else
        {
            isload = NO;
            if(faileNum < 4)
            {
                [weakSelf loadHelpData];
            }
            
        }
    } failure:^(NSError *error) {
        isload = NO;
        if(faileNum < 4)
        {
            [weakSelf loadHelpData];
        }
    }];
    
}

#pragma mark - scrollViewDelelgae
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    _isScrollToHelp = NO;
//    CGFloat offsetY = scrollView.contentOffset.y;
//    if (offsetY > 0) {
//        CGFloat alpha = (offsetY - HomeScrollBase)/HomeScrollBase;
//        HeaderAlpha = MIN(alpha, 1);
//        [self.navigationController.navigationBar fs_setBackgroundColor:[KHomeNavigationBarBackGroundColor colorWithAlphaComponent:HeaderAlpha]];
//    }else
//    {
//        [self.navigationController.navigationBar fs_setBackgroundColor:[UIColor clearColor]];
//    }
    
//    CGSize defaultSize = CGSizeMake(KDeviceW, headHeight);
//    if (offsetY< 0) {
//        CGFloat newH = defaultSize.height - offsetY;
//        CGFloat newW = defaultSize.width * (newH/(defaultSize.height));
//        mainHeadImageView.frame = CGRectMake(-(newW-defaultSize.width)/2, offsetY, newW, newH);
//    }
}


-(void)refreshHeadView
{
    if (isFirst) {
        AppModel *model ;
        if (helpModel.apprecommenlist.count > 0) {
            model = helpModel.apprecommenlist[0];
        }
        if (helpModel.topData[@"startnumber"]!= nil && helpModel.topData[@"rate"]!= nil) {
            NSInteger tempStartNumber = [helpModel.topData[@"startnumber"] integerValue];
            
            [self setFlipNumWithStart:tempStartNumber andIsAnimaite:YES];
            
            double rate = [helpModel.topData[@"rate"] doubleValue];
            if (rate <= 1) {
                NSNumber *countEachTime = [NSNumber numberWithInteger:((NSInteger)(1/rate) + 1)];
                fanPaiTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeFlipTime:) userInfo:countEachTime repeats:YES];
            }else
            {
                fanPaiTimer = [NSTimer scheduledTimerWithTimeInterval:rate target:self selector:@selector(changeFlipTime:) userInfo:nil repeats:YES];
            }
            [[NSRunLoop mainRunLoop] addTimer:fanPaiTimer forMode:NSRunLoopCommonModes];
        }
        
        
    }
}



-(void)setFlipNumWithStart:(NSInteger )tempStartNumber andIsAnimaite:(BOOL)isAnimated
{
    startNumber = tempStartNumber;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSString *formattedStr = [formatter stringFromNumber:[NSNumber numberWithInteger:startNumber]];
    
    NSArray *numsArray = [formattedStr componentsSeparatedByString:@","];//将格式化的数字以逗号分隔
    if(numsArray.count >=3)
    {
        NSString *millionStr = numsArray[0];
        NSString *tenThousandStr = numsArray[1];
        NSString *hundredStr = numsArray[2];
        if(self.view.window != nil && isForeground==true){
            [millionFlipNumberView setValue:[millionStr integerValue] animated:isAnimated];
            [tenThousandFlipNumberView setValue:[tenThousandStr integerValue] animated:isAnimated];
            [hundredFlipNumberView setValue:[hundredStr integerValue] animated:isAnimated];
        }
    }
}


#pragma mark - 定时器的方法
-(void)changeFlipTime:(NSTimer *)timer
{
    if (timer.userInfo == nil) {
        startNumber +=1;
    }else
    {
        NSInteger addCount = [timer.userInfo integerValue];
        startNumber += addCount;
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSString *formattedStr = [formatter stringFromNumber:[NSNumber numberWithInteger:startNumber]];
    NSArray *numsArray = [formattedStr componentsSeparatedByString:@","];//将格式化的数字以逗号分隔
    if(numsArray.count>=3)
    {
        NSString *millionStr = numsArray[0];
        NSString *tenThousandStr = numsArray[1];
        NSString *hundredStr = numsArray[2];
        if(self.view.window != nil && isForeground)
        {
            [millionFlipNumberView setValue:[millionStr integerValue] animated:YES];
            [tenThousandFlipNumberView setValue:[tenThousandStr integerValue] animated:YES];
            [hundredFlipNumberView setValue:[hundredStr integerValue] animated:YES];
        }
    }
    
    
}


#pragma mark - tableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (indexPath.row == 0) {
            NSLog(@"常见问题");
            [MobClick event:@"Help77"];//帮助页－常见问题点击数
            [[BaiduMobStat defaultStat] logEvent:@"Help77" eventLabel:@"帮助页－常见问题点击数"];
            
            CommonWebViewController *commomwevView = [[CommonWebViewController alloc] init];
            commomwevView.titleStr = @"常见问题";
            commomwevView.urlStr = [NSString stringWithFormat:@"%@",oftenProblem];
            [self.navigationController pushViewController:commomwevView animated:YES];
        }else if(indexPath.row == 1){
            NSLog(@"意见反馈");
            [MobClick event:@"Help78"];//帮助页－意见反馈点击数
            [[BaiduMobStat defaultStat] logEvent:@"Help78" eventLabel:@"帮助页－意见反馈点击数"];
            
            AdviceViewController *adviceView = [[AdviceViewController alloc] init];
            [self.navigationController pushViewController:adviceView animated:YES];
        }else if (indexPath.row == 2) {
            [MobClick event:@"Help79"];//帮助页－QQ点击数
            [[BaiduMobStat defaultStat] logEvent:@"Help79" eventLabel:@"帮助页－QQ点击数"];
        }else if(indexPath.row == 3)
        {
            [MobClick event:@"Help80"];//帮助页－QQ群点击数
            [[BaiduMobStat defaultStat] logEvent:@"Help80" eventLabel:@"帮助页－QQ群点击数"];
            
        }else if(indexPath.row == 4)
        {
            [MobClick event:@"Help81"];//帮助页－邮箱点击数
            [[BaiduMobStat defaultStat] logEvent:@"Help81" eventLabel:@"帮助页－邮箱点击数"];
            
        }else {
            NSLog(@"客服");
            [MobClick event:@"Help82"];//帮助页－电话点击数,
            [[BaiduMobStat defaultStat] logEvent:@"Help82" eventLabel:@"帮助页－电话点击数"];
            
            
            NSString *string = helpModel.customerphone;
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",string];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            
            //            MyAlertView *alertView = [[MyAlertView alloc] initWithTitle:@"提示" icon:nil message:[NSString stringWithFormat:@"确定拨打电话：%@ ？",helpModel.customerphone] delegate:self buttonTitles:@"呼叫",@"取消", nil];
            //            [alertView show];
        }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentity = @"helpCell";
    HelpCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell == nil) {
        cell = [[HelpCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentity];
        cell.textLabel.textColor = KHexRGB(0x999999);
        
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *textStr;//
    NSString *cellImageName;
    NSString *detailStr = @"";
    cell.detailTextLabel.textColor = KHexRGB(0x333333);
    
    if (indexPath.row == 0) {
        textStr = @"常见问题";
        cellImageName = @"ofenProblem";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if(indexPath.row == 1)
    {
        textStr = @"意见反馈";
        cellImageName = @"意见反馈icon";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else  if (indexPath.row == 2) {
        textStr = @"QQ:";
        cellImageName = @"qqicon";
        detailStr = helpModel.customerqq;
    }else if(indexPath.row == 3)
    {
        textStr = @"QQ群:";
        cellImageName = @"qq群";
        detailStr = helpModel.qqgroup;
    }else if(indexPath.row == 4)
    {
        textStr = @"邮箱:";
        cellImageName = @"邮件";
        detailStr = helpModel.customermail;
    }else
    {
        textStr = @"电话:";
        cellImageName = @"电话";
        detailStr = helpModel.customerphone;
        cell.detailTextLabel.textColor = KHexRGB(0x4B8BAD);
    }

    cell.textLabel.text = textStr;
    cell.imageView.image = [UIImage imageNamed:cellImageName];
    cell.detailTextLabel.text = detailStr;
    cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}


#pragma mark - 是否拨打电话

-(void)alertView:(MyAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSLog(@"取消");
    }else
    {
        NSLog(@"呼叫");
        NSString *string = helpModel.customerphone;
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",string];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}


-(UITableView *)createTableViewWithFrame:(CGRect)frame
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorColor = KSeparatorColor;
        _tableView.estimatedRowHeight = 0;//禁用self-sizing 计算完整contentsize
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [self setCornerRaduis:_tableView byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight size:CGSizeMake(15, 15)];
//        _tableView.tableFooterView = [self createTableFootView];
    }
    return _tableView;
}

#pragma mark - ZZCarouseControllerDelegate
-(NSArray *)zzcarousel:(ZZCarouselControl *)carouselView
{
    return helpModel.apprecommenlist;
}


-(UIView *)zzcarousel:(ZZCarouselControl *)carouselView carouselFrame:(CGRect)frame data:(NSArray *)data viewForItemAtIndex:(NSInteger)index
{
    
    UIView *zzCarView = [[UIView alloc] initWithFrame:frame];
    AppModel *model = data[index];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 54, 54)];
    [logoImageView sd_setImageWithURL:[NSURL URLWithString:model.appicon] placeholderImage:nil];
    
    [zzCarView addSubview: logoImageView];
    
    UILabel *appNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(logoImageView.frame) + 5, 32, 50, 20)];
    appNameLabel.font =[UIFont fontWithName:FontName size:16];
    appNameLabel.text = model.appname;
    [zzCarView addSubview:appNameLabel];
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(appNameLabel.frame) +5, 20, KDeviceW - 15 - CGRectGetMaxX(appNameLabel.frame), 44)];
    descLabel.numberOfLines = 2;
    descLabel.textColor = KHexRGB(0x999999);
    descLabel.font = [UIFont fontWithName:FontName size:14];
    descLabel.text = model.appintro;
    [zzCarView addSubview:descLabel];
    
    return zzCarView;
}


//点击方法
-(void)zzcarouselView:(ZZCarouselControl *)zzcarouselView data:(NSArray *)data didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"app信息点击");
    [MobClick event:@"Help83"];//帮助页－聚信广告点击数
    [[BaiduMobStat defaultStat] logEvent:@"Help83" eventLabel:@"帮助页－聚信广告点击数"];
    
    AppModel *model = data[index];
    CommonWebViewController *commonWeb = [[CommonWebViewController alloc] init];
    commonWeb.titleStr = model.appname;
    commonWeb.urlStr = model.appurl;
    [self.navigationController pushViewController:commonWeb animated:YES];
}


-(void)initFlipNumberWithSpace:(CGFloat)space//width数字宽度
{
    millionFlipNumberView = [[JDFlipNumberView alloc] initWithDigitCount:3 imageBundleName:@"SmallDigitalImage"];
    millionFlipNumberView.zDistance = 0;
    millionFlipNumberView.frame = CGRectMake(space, 0, NUMBER_W *3, NUMBER_H);
    millionFlipNumberView.value = 000;
    //    [millionFlipNumberView setValue:00 animated:YES];
    
//    firstDouHaoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width*3, NUMBER_H - 14.5, 8, 14.5)];
//    firstDouHaoImageView.image = [UIImage imageNamed:@"comma"];
    
    tenThousandFlipNumberView = [[JDFlipNumberView alloc] initWithDigitCount:3 imageBundleName:@"SmallDigitalImage"];
    tenThousandFlipNumberView.zDistance = 0;
    tenThousandFlipNumberView.frame = CGRectMake(millionFlipNumberView.maxX + NUMBER_W/2, 0, NUMBER_W*3, NUMBER_H);
    tenThousandFlipNumberView.value = 000;
    //    [tenThousandFlipNumberView setValue:234 animated:YES];
    
//    secondDouHaoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tenThousandFlipNumberView.frame), NUMBER_H - 14.5, 0 , 14.5)];
//    secondDouHaoImageView.image = [UIImage imageNamed:@"comma"];
    
    hundredFlipNumberView = [[JDFlipNumberView alloc] initWithDigitCount:3 imageBundleName:@"SmallDigitalImage"];
    hundredFlipNumberView.zDistance = 0;
    hundredFlipNumberView.frame = CGRectMake(tenThousandFlipNumberView.maxX+NUMBER_W/2, 0, NUMBER_W*3, NUMBER_H);
    hundredFlipNumberView.value = 000;
    //    [hundredFlipNumberView setValue:567 animated:YES];
}

-(void )createMainScrollView
{

    CGFloat scrolly = - KNavigationBarHeight;
    if(@available(iOS 11.0, *))
    {
        scrolly = 0;
    }
    mainHeadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, scrolly, KDeviceW, KDeviceH+20)];
    //mainHeadImageView.backgroundColor = KHexRGB(0x104c92);
    mainHeadImageView.image = [UIImage imageNamed:@"helpHeadBackGround"];
    [self.view addSubview:mainHeadImageView];
    
   UIImageView *qiuImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, scrolly, KDeviceW, KDeviceW*729/750)];
    //mainHeadImageView.backgroundColor = KHexRGB(0x104c92);
    qiuImageView.image = [UIImage imageNamed:@"关于我们背景上元素"];
    [self.view addSubview:qiuImageView];
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scrolly, KDeviceW, KDeviceH)];
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.delegate =self;
    [self.view addSubview:_mainScrollView];
    
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 57.5, 57.5)];
    logoImageView.image = [UIImage imageNamed:@"helpLogo"];
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    logoImageView.center = CGPointMake( KDeviceW/2,(KNavigationBarHeight +30) );
    [_mainScrollView addSubview:logoImageView];
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(logoImageView.frame) + 10, KDeviceW - 40, 16)];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.font = KFont(14);
    versionLabel.textColor = [UIColor whiteColor];
    [_mainScrollView addSubview:versionLabel];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    versionLabel.text =[NSString stringWithFormat:@"版本：%@",appCurVersion];
    
    //        UIImageView *descImageView = [[UIImageView alloc] initWithFrame:CGRectMake(35, CGRectGetMaxY(versionLabel.frame) + 6, KDeviceW - 70, 23)];
    //        descImageView.image =[UIImage imageNamed:@"helpTipIcon"];
    //        descImageView.contentMode = UIViewContentModeScaleAspectFit;
    //        [_mainScrollView addSubview:descImageView];
    
//    UILabel *miaoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(versionLabel.frame) + 10, KDeviceW - 40, 0)];
//    miaoLabel.textAlignment = NSTextAlignmentCenter;
//    miaoLabel.font = KBlodFont(18);
//    miaoLabel.text = @"更权威的企业信息查询平台";
//    miaoLabel.textColor = [UIColor whiteColor];
//    [_mainScrollView addSubview:miaoLabel];
    
    
    CGFloat space = (KDeviceW -NUMBER_W*10)/2;//

    UIView *fanpaiView = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(versionLabel.frame) + 20, KDeviceW, NUMBER_H)];
    fanpaiView.backgroundColor = [UIColor clearColor];
    [_mainScrollView addSubview:fanpaiView];
    [self initFlipNumberWithSpace:space];
    
 
    [fanpaiView addSubview:millionFlipNumberView];
//    [fanpaiView addSubview:firstDouHaoImageView];
    [fanpaiView addSubview:tenThousandFlipNumberView];
//    [fanpaiView addSubview:secondDouHaoImageView];
    [fanpaiView addSubview:hundredFlipNumberView];
    
    UILabel *tiplabel = [[UILabel alloc] initWithFrame:CGRectMake(20, fanpaiView.maxY + 15, KDeviceW - 40, 20)];
    tiplabel.text = @"数据持续更新中...";
    tiplabel.font = KFont(10);
    tiplabel.textAlignment = NSTextAlignmentCenter;
    tiplabel.textColor = KHexRGB(0xFFEEC4);
    [_mainScrollView addSubview:tiplabel];
    
    
//    CGRect qiuFrame =  qiuImageView.frame;
//    qiuFrame.size.height = tiplabel.maxY +;
//    qiuImageView.frame = qiuFrame;
    
    CGFloat tableViewHight = 50*6 + 15*3;
    if(tableViewHight+tiplabel.maxY + 15<=KDeviceH)
    {
        tableViewHight = KDeviceH - (tiplabel.maxY + 15);
    }
    
    [_mainScrollView addSubview:[self createTableViewWithFrame:CGRectMake(0, tiplabel.maxY  + 15, KDeviceW, tableViewHight)]];
    _mainScrollView.contentSize = CGSizeMake(KDeviceW, CGRectGetMaxY(_tableView.frame));
    _mainScrollView.backgroundColor = [UIColor clearColor];
}



//-(UIView *)createTableFootView
//{
//    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KDeviceW,84)];
//    footView.backgroundColor = [UIColor whiteColor]; //KHexRGB(0xf5f5f5);
//    if (zzCarouseView == nil) {
//        zzCarouseView = [[ZZCarouselControl alloc] initWithFrame:CGRectMake(0,0, KDeviceW, 84)];
//        zzCarouseView.delegate = self;
//        zzCarouseView.dataSource = self;
//        zzCarouseView.carouseScrollTimeInterval = 2.0f;
//        [footView addSubview:zzCarouseView];
//    }
//
//    UIView *lineTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KDeviceW, 1)];
//    lineTop.backgroundColor = KSeparatorColor;
//    [zzCarouseView addSubview:lineTop];
//
//    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 83, KDeviceW, 1)];
//    bottomLine.backgroundColor = KSeparatorColor;
//    [zzCarouseView addSubview:bottomLine];
//    return footView;
//}




- (void)setCornerRaduis:(UIView *)view byRoundingCorners:(UIRectCorner)corners size:(CGSize)size{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:size];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}


-(void)dealloc
{
    //注销通知
    [[NSNotificationCenter defaultCenter ] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter ] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}


@end

