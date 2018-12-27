//
//  MeController.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 2018/1/4.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import "MeController.h"

#define KTableHeadHight 260

@interface MeController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    UITableView * backTableView;
    UIImageView *backImageView;
    UIImageView * leftImageView;
    UIImageView * rightImageView;
    NSArray *dataArray;
    UIImageView *headImageView;
    UILabel *nameLabel;
    UILabel *positionLabel ;
    UILabel *companyLabel;
}

@end

@implementation MeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [KNotificationCenter addObserver:self selector:@selector(payDoneAction:) name:PAY_DONE_NOTI object:nil];
    [KNotificationCenter addObserver:self
                            selector:@selector(updateUserinfoSuccess)
                                name:UserinfoChangedNotification
                              object:nil];
    
    [KNotificationCenter addObserver:self
                            selector:@selector(focuNumChangeAction:)
                                name:KFocuNumChange
                              object:nil];
    [KNotificationCenter addObserver:self selector:@selector(readInfoMsg:) name:MESSAGEREADED_NOTIFI object:nil];
    [KNotificationCenter addObserver:self selector:@selector(systemReadMsgPush:) name:KUNREADMSG object:nil];
    dataArray =  @[@{@"title":@"VIP特权",@"icon":@"VIPicon"},
                   @{@"title":@"我的报告",@"icon":@"我的报告icon"},
                   @{@"title":@"我的关注",@"icon":@"我的关注icon"},
                   @{@"title":@"我的消息",@"icon":@"我的消息icon"},
                   @{@"title":@"修改资料",@"icon":@"修改资料icon"},
                   @{@"title":@"意见反馈",@"icon":@"意见反馈icon"},
                   /*@{@"title":@"推荐给朋友",@"icon":@"推荐给朋友icon"},*/
                   
                   ];
                  
    [self drawView];
    
    [self updateUserinfoSuccess];
    
}

#pragma mark - 获取个人信息
-(void)reloadUserInfo
{
    if(USER.userID.length == 0)
    {
        return;
    }
    NSDictionary *dict = @{@"userid":USER.userID};
    [RequestManager getWithURLString:GetUserInfo parameters:dict success:^(id responseObject) {
        
        //NSDictionary *userinfo = responseObject[@"userinfo"];
        if ([responseObject[@"result"] integerValue] == 0) {
            NSLog(@"个人信息===%@",responseObject);
//            [USER giveUserInfo:userinfo];
//            [KNotificationCenter postNotificationName:UserinfoChangedNotification object:nil];
            
            [User clearTable];
            User *model = [User mj_objectWithKeyValues:[responseObject objectForKey:@"userinfo"]];
            [model save];
            [self updateUserinfoSuccess];
        }
        
    } failure:^(NSError *error) {
        
    }];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AccountCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([cell.titleLabel.text isEqualToString:@"VIP特权"]) {
        
        VIPPrivilegeController *vc = [VIPPrivilegeController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([cell.titleLabel.text isEqualToString:@"我的报告"]){
        
        MyReportsController *vc = [MyReportsController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([cell.titleLabel.text isEqualToString:@"我的关注"]) {
        
        [MobClick event:@"Me84"];
        [[BaiduMobStat defaultStat] logEvent:@"Me84" eventLabel:@"个人页－我的关注点击数"];
        
        OwnerFocuceVC *focuce = [OwnerFocuceVC new];
        [self.navigationController pushViewController:focuce animated:YES];
        
    }else if ([cell.titleLabel.text isEqualToString:@"我的消息"]) {
        [MobClick event:@"Me85"];
        [[BaiduMobStat defaultStat] logEvent:@"Me85" eventLabel:@"个人页－我的消息点击数"];
        
        OwnerMessageVC *message = [OwnerMessageVC new];
        [self.navigationController pushViewController:message animated:YES];
        
    }else if ([cell.titleLabel.text isEqualToString:@"修改资料"]) {
        
        [MobClick event:@"Me86"];
        [[BaiduMobStat defaultStat] logEvent:@"Me86" eventLabel:@"个人页－修改资料点击数"];
        
        UpdateAccountInfoVC *account = [UpdateAccountInfoVC new];
        //account.userInfoDict = _userInfoDict;
        [self.navigationController pushViewController:account animated:YES];
        
    }else if ([cell.titleLabel.text isEqualToString:@"意见反馈"]) {
        
        [MobClick event:@"Me87"];
        [[BaiduMobStat defaultStat] logEvent:@"Me87" eventLabel:@"个人页－意见反馈点击数"];
        
        AdviceViewController *advice = [AdviceViewController new];
        
        [self.navigationController pushViewController:advice animated:YES];
        
    }
//    else{
//
//        [MobClick event:@"Me88"];
//        [[BaiduMobStat defaultStat] logEvent:@"Me88" eventLabel:@"个人页－推荐点击数"];
//
//        //分享
//        ShareView *view = [[ShareView alloc]init];
//        //        view.descStr = [NSString stringWithFormat:@"企信宝"];
//        view.detailUrlStr = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.jusfoun.jusfouninquire";
//        view.descStr = @"几千万家企业工商信息、法人信息、失信信息 一次查询全掌握。关注企业更可随时了解企业信息变化。";
//        [[UIApplication sharedApplication ].keyWindow addSubview:view];
//    }
}




- (void)payDoneAction:(NSNotification *)noti{
    NSDictionary *dic = noti.userInfo;
    if ([dic[@"result"] intValue]) {//支付成功刷新个人信息
        [self reloadUserInfo];
    }
}

//系统消息推送通知+1
-(void)systemReadMsgPush:(NSNotification*)noti{
    
    NSInteger msginfo = [USER.systemmessageunread integerValue]+1;
    USER.systemmessageunread= [NSString stringWithFormat:@"%ld",(long)msginfo];
    
    
    [backTableView reloadData];
}
//消息列表点击消息阅读推送通知-1
-(void)readInfoMsg:(NSNotification*)noti{
    
    NSInteger msginfo = [USER.systemmessageunread integerValue]-1;
    USER.systemmessageunread= [NSString stringWithFormat:@"%ld",(long)msginfo];
    [backTableView reloadData];
}
-(void)focuNumChangeAction:(NSNotification*)noti
{
    
    NSString *str = (NSString*)noti.object;
    if ([str isEqualToString:@"0"]) {
        if (USER.myfocuscount) {
            NSInteger count = [USER.myfocuscount integerValue]-1;
            USER.myfocuscount = [NSString stringWithFormat:@"%ld",(long)count];
        }
        
    }else{
        if (USER.myfocuscount) {
            NSInteger count = [USER.myfocuscount integerValue]+1;
            USER.myfocuscount = [NSString stringWithFormat:@"%ld",(long)count];
        }
        
    }
    [backTableView reloadData];
}

-(void)updateUserinfoSuccess
{
    [self setHeadImage];
    [self setAttributeNameLabel];//设置会员类型图标
    [backTableView reloadData];
    
    if (USER.job.length > 0) {
        
        positionLabel.text = USER.job;
    }else
    positionLabel.text = @"暂无职位信息";
    
    if (USER.company.length > 0) {
        
        companyLabel.text = USER.company;
    }else
    companyLabel.text = @"暂无公司信息";
    
    [backTableView reloadData];
    
}

- (void)setAttributeNameLabel{
    
    NSString *name = [NSString stringWithFormat:@"%@ ", USER.nickname?USER.nickname:@""];
    NSString *imageName = [USER.vipType intValue]?@"vip会员":@"普通会员";
    CGRect bounds = [USER.vipType intValue]? KFrame(0, nameLabel.font.descender, 21*2.8, 21):KFrame(0, nameLabel.font.descender, 17*3.1, 17);
    
    NSTextAttachment *atc = [[NSTextAttachment alloc]init];
    atc.image = KImageName(imageName);
    atc.bounds = bounds;
    NSAttributedString * strA =[NSAttributedString attributedStringWithAttachment:atc];
    
    NSMutableAttributedString *ats = [[NSMutableAttributedString alloc]initWithString:name];
    [ats insertAttributedString:strA atIndex:name.length];
    nameLabel.attributedText = ats;
    //    _nameLabel.backgroundColor = [UIColor greenColor];
}

-(void)setHeadImage
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:USER.photo]
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             // progression tracking code
                             //                                     NSLog(@"%ld",receivedSize/expectedSize);
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if (image) {
                                UIImage *headImage = [image jm_imageWithRoundedCornersAndSize:CGSizeMake(82, 82) andCornerRadius:41];
                                headImageView.image = headImage;
                            }else{
                                
                                //失败的话用默认的
                                headImageView.image = [UIImage imageNamed:@"默认头像"];
                            }
                        }];
    
}

/*
-(void)beginAnimateIsUp:(BOOL)isUp
{

    if(isUp)
    {
        [self updateUserinfoSuccess];
        CGFloat scrolly = - KNavigationBarHeight;
        if(@available(iOS 11.0, *))
        {
            scrolly = 0;
        }
        backImageView.alpha = 0;
        
        CGRect leftFrame = leftImageView.frame;
        leftFrame.origin.x = - leftImageView.width;
        leftImageView.frame = leftFrame;
        
        CGRect rightFrame = rightImageView.frame;
        rightFrame.origin.x = KDeviceW + rightImageView.width;
        rightImageView.frame = rightFrame;
        
        
        backTableView.alpha = 0;
        
        CGRect tableFrame = backTableView.frame;
        tableFrame.origin.y = KDeviceH ;
        backTableView.frame = tableFrame;
        
        [UIView animateWithDuration:0.5 animations:^{
            backImageView.alpha = 1;
            leftImageView.alpha = 1;
            CGRect leftFrame = leftImageView.frame;
            leftFrame.origin.x = 0;
            leftImageView.frame = leftFrame;
            
            CGRect rightFrame = rightImageView.frame;
            rightFrame.origin.x = KDeviceW - 383/2.0;
            rightImageView.frame = rightFrame;
            
            
            backTableView.alpha = 1;
            
            CGRect tableFrame = backTableView.frame;
            tableFrame.origin.y = scrolly ;
            backTableView.frame = tableFrame;
        } completion:^(BOOL finished) {
           
        }];
    }
    else
    {
    
        [UIView animateWithDuration:0.3 animations:^{
            backImageView.alpha = 0;
            
            CGRect leftFrame = leftImageView.frame;
            leftFrame.origin.x = - leftImageView.width;
            leftImageView.frame = leftFrame;
            
            CGRect rightFrame = rightImageView.frame;
            rightFrame.origin.x = KDeviceW + rightImageView.width;
            rightImageView.frame = rightFrame;
            
            
            backTableView.alpha = 0;
            
            CGRect tableFrame = backTableView.frame;
            tableFrame.origin.y = KDeviceH ;
            backTableView.frame = tableFrame;
        } completion:^(BOOL finished) {
            [KNotificationCenter postNotificationName:KLoginOutAnimateCompletion object:nil];
            
            leftImageView.alpha = 0;
            
        }];
    }
    
    
}
 
 */

#pragma mark -- tableview   delegate datasource  -methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 54;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return KDeviceH - dataArray.count *54 - KTableHeadHight;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:KFrame(0, 0, tableView.width, KDeviceH - dataArray.count *54 - KTableHeadHight )];
    view.backgroundColor = [UIColor whiteColor];
    
    return view;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return dataArray.count ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     NSString *cellString = [NSString stringWithFormat:@"Identifier%d",(int)indexPath.row];
    AccountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (!cell) {
        cell = [[AccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
        if(indexPath.row == 0 )
        {
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:KFrame(0, 0, backTableView.width, 54) byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(15, 15)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = cell.bounds;
            maskLayer.path = maskPath.CGPath;
            cell.layer.mask = maskLayer;
        }
    }
    cell.redBtn.hidden = YES;
    cell.titleLabel.text = dataArray[indexPath.row][@"title"];
    
    cell.iconImg.image = [UIImage imageNamed:dataArray[indexPath.row][@"icon"]];
    if(indexPath.row == 0 )
    {
        cell.redBtn.hidden = [USER.vipType intValue];//普通用户显示红点

    }
    else if (indexPath.row == 2)
    {
        if (USER.myfocuscount.length > 0 && ![USER.myfocuscount isEqual:[NSNull null]])
        {
            cell.subtitleLabel.text = USER.myfocuscount;
        }
        else
        {
            cell.subtitleLabel.text = @"";
        }
    }
    else if (indexPath.row == 3)
    {
        cell.redBtn.hidden = ![USER.systemmessageunread intValue];
    }
   
    
    return cell;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == backTableView)
    {
        CGFloat offsetY = scrollView.contentOffset.y ;
        
        if(offsetY < 0)
        {
            CGFloat scale = -offsetY / KDeviceH;
            leftImageView.transform = CGAffineTransformMakeScale(1 + scale, 1 + scale);
        }
    }
}


-(UIView*)createtableHeaderView
{
   
    UIView *backView = [[UIView alloc] initWithFrame:KFrame(0, 0, backTableView.width, KTableHeadHight)];
    backView.backgroundColor = [UIColor clearColor];
    
    
//    UIView *kuangView = [[UIView alloc]initWithFrame:KFrame(0, backView.height - 105, backView.width, 105)];
//    kuangView.backgroundColor = [UIColor whiteColor];
//    kuangView.layer.cornerRadius = 5;
//    kuangView.clipsToBounds = YES;
//    [backView addSubview:kuangView];
    
    
    companyLabel = [[UILabel alloc] initWithFrame:KFrame(20, backView.height - 13 - 30, backView.width - 40, 13)];
    companyLabel.font = KFont(12);
    companyLabel.textAlignment = NSTextAlignmentCenter;
    companyLabel.textColor =  [UIColor whiteColor];
    [backView addSubview:companyLabel];
    
    positionLabel = [[UILabel alloc] initWithFrame:KFrame(companyLabel.x, companyLabel.y -companyLabel.height - 6, backView.width - 40, companyLabel.height)];
    positionLabel.font = KFont(12);
    positionLabel.textAlignment = NSTextAlignmentCenter;
    positionLabel.textColor = [UIColor whiteColor];
    [backView addSubview:positionLabel];
    
    nameLabel = [[UILabel alloc] initWithFrame:KFrame(companyLabel.x, positionLabel.y - 15-15 , backView.width - 40, 22)];
    nameLabel.font = KFont(16);
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor whiteColor];
    [backView addSubview:nameLabel];
    
    headImageView = [[UIImageView alloc] initWithFrame:KFrame(KDeviceW/2-40, nameLabel.y - 80-20, 80, 80)];
    headImageView.layer.cornerRadius = headImageView.height/2.0;
    headImageView.image = [UIImage imageNamed:@"默认头像"];
    headImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self setHeadImage];
    [backView addSubview:headImageView];
    
    
    
    [self setAttributeNameLabel];
    
   
    
   
    
//    UIView *lineView = [[UIView alloc] init];
//    lineView.frame = KFrame(0, kuangView.height - 1, kuangView.width, 1);
//    lineView.backgroundColor = KRGB(241, 241, 241);
//    [kuangView addSubview:lineView];
    
    
    return backView;
}


-(void)drawView
{
    CGFloat scrolly = - KNavigationBarHeight;
    if(@available(iOS 11.0, *))
    {
        scrolly = 0;
    }
    
    backImageView = [[UIImageView alloc]initWithFrame:KFrame(0, scrolly, KDeviceW, KDeviceH)];
    backImageView.image = KImageName(@"userBack");
    [self.view addSubview:backImageView];
    
    leftImageView = [[UIImageView alloc]initWithFrame:KFrame(0, scrolly, KDeviceW, KDeviceH)];
    leftImageView.image = KImageName(@"个人中心－背景元素");
    [self.view addSubview:leftImageView];
    
//    rightImageView = [[UIImageView alloc]initWithFrame:KFrame(KDeviceW - 383/2.0, scrolly, 383/2.0, 643/2.0)];
//    rightImageView.image = KImageName(@"个人中心banner右侧");
//    [self.view addSubview:rightImageView];
    

    backTableView = [[UITableView alloc]initWithFrame:KFrame(0, scrolly, KDeviceW, KDeviceH) style:UITableViewStyleGrouped];
    backTableView.delegate = self;
    backTableView.dataSource = self;
    
    backTableView.estimatedRowHeight = 0;//禁用self-sizing 计算完整contentsize
    backTableView.estimatedSectionHeaderHeight = 0;
    backTableView.estimatedSectionFooterHeight = 0;
    backTableView.backgroundColor  = [UIColor clearColor];
    backTableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    backTableView.tableHeaderView = [self createtableHeaderView];
    backTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:backTableView];
    
}




-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self scrollViewDidScroll:_mainTableView];
    [backTableView reloadData];
}



-(void)dealloc{
    
    [KNotificationCenter removeObserver:self];
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
