//
//  DetailView.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 17/9/4.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "DetailView.h"

#define KFoldBtnTag 89463

@interface DetailView()
{
    UIButton *phoneBtn;
    BOOL isShowPhone;//联系信息
    BOOL isShowRisk;//风险信息
    BOOL isShowManage;//经营状况
    BOOL isShowMoney;//无形资产
    
    NSArray *riskArray;
    NSArray *manageArray;
    NSArray *moneyArray;
    
}

@end

@implementation DetailView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        isShowPhone = NO;
        isShowRisk = NO;
        isShowManage = NO;
        isShowMoney = NO;
        [self addSubview:self.backTableView];
        [self reportView];
    }
    return self;
}

#pragma mark - 打电话
-(void)call
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(callCompany:)])
    {
        [self.delegate callCompany:[[self.detailModel.companyphonelist objectAtIndex:0] objectForKey:@"number"]];
    }
}

-(void)refreshCompany
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(refreshCompany)])
    {
        [self.delegate refreshCompany];
    }
}

-(void)gridButtonClick:(GridButton *)button cellSection:(int)section
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(gridButtonClick: cellSection:)])
    {
        ItemModel *sqModel = [ItemModel mj_objectWithKeyValues:button.buttonDic];
        [self.delegate gridButtonClick:sqModel cellSection:section];
    }
}

-(void)setDetailModel:(CompanyDetailModel *)detailModel
{
    _detailModel = detailModel;
    
    [self.backTableView reloadData];
}

-(void)foldAction:(UIButton*)button
{
    
    Headerype type;
    
    
    BOOL isShow;
    NSArray *array;
    if (button.tag == KFoldBtnTag +3)//风险信息
    {
        type = HeaderRiskType;
        isShow = isShowRisk;
        array = riskArray;
    }
    else if (button.tag == KFoldBtnTag +4)//经营状况
    {
        type = HeaderManageType;
        isShow = isShowManage;
        array = manageArray;
    }
    else //if (button.tag == KFoldBtnTag +5)//无形资产
    {
        type = HeaderMoneyType;
        isShow = isShowMoney;
        array = moneyArray;
    }
    
    
    if(!isShow)
    {
        if(array.count == 0)
        {
            if(self.delegate && [self.delegate respondsToSelector:@selector(headerClick:)])
            {
                [self.delegate headerClick:type];
            }

        }
        else
        {
            [self changeOpen:button];
             [self.backTableView reloadSections:[NSIndexSet indexSetWithIndex:button.tag -KFoldBtnTag] withRowAnimation:UITableViewRowAnimationNone];
            [self.backTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:button.tag -KFoldBtnTag] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
    }
    else
    {
        [self changeOpen:button];
        [self.backTableView reloadSections:[NSIndexSet indexSetWithIndex:button.tag -KFoldBtnTag] withRowAnimation:UITableViewRowAnimationNone];
    }
    
}

-(void)changeOpen:(UIButton*)button
{
    if (button.tag == KFoldBtnTag +3)//风险信息
    {
        
        isShowRisk = !isShowRisk;
        
    }
    else if (button.tag == KFoldBtnTag +4)//经营状况
    {
        
        isShowManage = !isShowManage;
        
    }
    else //if (button.tag == KFoldBtnTag +5)//无形资产
    {
       
        isShowMoney = !isShowMoney;
        
    }

}

-(void)reloadViewWithType:(Headerype)type gridArray:(NSArray *)array animate:(BOOL)animate
{
    
    int section ;
    if (type == HeaderRiskType)//风险信息
    {
        isShowRisk = !isShowRisk;
        section = 3;
        riskArray = array;
    }
    else if (type == HeaderManageType)//经营状况
    {
        isShowManage = !isShowManage;
        section = 4;
        manageArray = array;
    }
    else //if (button.tag == KFoldBtnTag +5)//无形资产
    {
        isShowMoney = !isShowMoney;
        section = 5;
        moneyArray = array;
    }
    
    [self.backTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    if(animate)
    {
        
        [self.backTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:NSNotFound inSection:section] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }

}

-(void)beginRefreshAnimation
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    DetailInfoCell *cell = (DetailInfoCell*)[self.backTableView cellForRowAtIndexPath:indexPath];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 0.6;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    [cell.refreshBtn.imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
}

-(void)stopRefreshAnimation
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    DetailInfoCell *cell = (DetailInfoCell*)[self.backTableView cellForRowAtIndexPath:indexPath];
    [cell.refreshBtn.imageView.layer removeAllAnimations];
}

-(void)checkReport
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(checkReport)])
    {
        [self.delegate checkReport];
    }
}

#pragma mark - 展开联系方式
-(void)showPhone
{
    isShowPhone = !isShowPhone;
    
    [self.backTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            if(self.detailModel.latitude.length == 0||[self.detailModel.latitude isEqualToString:@"-"]||self.detailModel.longitude.length == 0||[self.detailModel.longitude isEqualToString:@"-"])
            {
                return ;
            }
            if(self.delegate && [self.delegate respondsToSelector:@selector(companyAdress)])
            {
                [self.delegate companyAdress];
            }
        }
        else if (indexPath.row == 1)
        {
            if (self.detailModel.neturl.count > 0) {
                NSString *addressURL = [NSString stringWithFormat:@"%@",[[self.detailModel.neturl objectAtIndex:0] objectForKey:@"url"]];
                if (addressURL.length > 0) {//地址不为空才跳转
                    
                    if(self.delegate && [self.delegate respondsToSelector:@selector(CompanyUrl:)])
                    {
                        [self.delegate CompanyUrl:addressURL];
                    }
                }

        }
        }
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else if(section == 1)
    {
        if(isShowPhone)
        {
            return 2;
        }
        else
        {
            return 0;
        }
    }
    else if(section == 2)
    {
        return 1;
    }
    else if(section == 3)
    {
        if(isShowRisk)
        {
            return 1;
        }
        else
        {
            return 0;
        }
    }
    else if(section == 4)
    {
        if(isShowManage)
        {
            return 1;
        }
        else
        {
            return 0;
        }
    }
    else if(section == 5)
    {
        if(isShowMoney)
        {
            return 1;
        }
        else
        {
            return 0;
        }
    }
    return 0;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"%d%did",(int)indexPath.section,(int)indexPath.row];
    if(indexPath.section == 0)
    {
       
        DetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell)
        {
            cell = [[DetailInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell.refreshBtn addTarget:self action:@selector(refreshCompany) forControlEvents:UIControlEventTouchUpInside];
        cell.detailModel = _detailModel;
        
        return cell;
    }
    else if (indexPath.section == 1)
    {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(indexPath.row == 1)
            {
                UIView *lineView = [[UIView alloc]initWithFrame:KFrame(0, 1, KDeviceW, 1)];
                lineView.tag = 34751;
                lineView.backgroundColor =KHexRGB(0xebebeb);
                [cell.contentView addSubview:lineView];
                
                UIView *lineView2 = [[UIView alloc]initWithFrame:KFrame(0, 44, KDeviceW, 1)];
                lineView.tag = 34752;
                lineView2.backgroundColor =KHexRGB(0xebebeb);
                [cell.contentView addSubview:lineView2];
            }
           
        }
        
        cell.textLabel.font = KFont(13);
        cell.textLabel.textColor = KHexRGB(0x666666);
        cell.textLabel.numberOfLines = 0;
        if(indexPath.row == 0)
        {
            cell.imageView.image = KImageName(@"地址icon");
            cell.textLabel.text = self.detailModel.address;
           
        }
        else
        {
            cell.imageView.image = KImageName(@"网址icon");
            cell.textLabel.text = self.detailModel.neturl.count>0?[[self.detailModel.neturl objectAtIndex:0] objectForKey:@"url"]:@"--";
        }
        
        return cell;
    }
    else if (indexPath.section == 2)
    {
        DetailGridCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell)
        {
            cell = [[DetailGridCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.detailGridDelegate = self;
        }
        cell.section = (int)indexPath.section;
        [cell setCellData:self.detailModel.subclassMenu];
        return cell;
        
    }
    else if (indexPath.section == 3)
    {
        DetailGridCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell)
        {
            cell = [[DetailGridCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.detailGridDelegate = self;

        }
        cell.section = (int)indexPath.section;
        [cell setCellData:riskArray];
        return cell;
        
    }
    else if (indexPath.section == 4)
    {
        DetailGridCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell)
        {
            cell = [[DetailGridCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.detailGridDelegate = self;

        }
        cell.section = (int)indexPath.section;
        [cell setCellData:manageArray];
        return cell;
        
    }
    else
    {
        DetailGridCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell)
        {
            cell = [[DetailGridCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.detailGridDelegate = self;

        }
        cell.section = (int)indexPath.section;
        [cell setCellData:moneyArray];
        return cell;
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        DetailInfoCell *cell = (DetailInfoCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        
        return cell.frame.size.height;
    }
    else if(indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            NSString *adress = self.detailModel.address;
            
            CGFloat hight = [Tools getHeightWithString:adress fontSize:13 maxWidth:KDeviceW - 50 - 15]+ 20;
            
            return hight >45 ? hight:45;
        }
        else
        {
            return 45;
        }
        
    }
    else if (indexPath.section == 2)
    {
        NSArray *array = self.detailModel.subclassMenu;
        if(array.count >0)
        {
            return KDetailGridWidth* (array.count%4>0?(array.count/4+1):array.count/4);
        }
        else
        {
            return KDetailGridWidth *3;
        }
    }
    else if (indexPath.section == 3)
    {
        if(self.detailModel)
        {
            return KDetailGridWidth* (riskArray.count%4>0?(riskArray.count/4+1):riskArray.count/4);
        }
        else
        {
            return KDetailGridWidth ;
        }
    }
    else if (indexPath.section == 4)
    {
        if(self.detailModel)
        {
             return KDetailGridWidth* (manageArray.count%4>0?(manageArray.count/4+1):manageArray.count/4);
        }
        else
        {
            return KDetailGridWidth ;
        }
    }
    else if (indexPath.section == 5)
    {
        if(self.detailModel)
        {
            return KDetailGridWidth* (moneyArray.count%4>0?(moneyArray.count/4+1):moneyArray.count/4);
        }
        else
        {
            return KDetailGridWidth ;
        }
    }
    
    return 0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return nil;
    }
    else if(section == 1)
    {
        UIView *phoneView = [[UIView alloc]initWithFrame:KFrame(0, 0, KDeviceW, 45)];
        phoneView.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1.00];
        
        phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        phoneBtn.frame = KFrame(15, 0, KDeviceW - 30 -100, 45);
        [phoneBtn setImage:KImageName(@"电话icon") forState:UIControlStateNormal];
        NSString *str = [ NSString stringWithFormat:@"  %@",self.detailModel.companyphonelist.count >0?[[self.detailModel.companyphonelist objectAtIndex:0] objectForKey:@"number"]:@"--"];
        if([str isEqualToString:@"  --"]||[str isEqualToString:@"  "])
        {
            phoneBtn.enabled = NO;
        }
        [phoneBtn setTitle:str forState:UIControlStateNormal];
        [phoneBtn setTitleColor:KHexRGB(0x666666) forState:UIControlStateNormal];
        phoneBtn.titleLabel.font = KFont(13);
        phoneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [phoneBtn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
        [phoneView addSubview:phoneBtn];
        
        
        UILabel*label = [[UILabel alloc]initWithFrame:KFrame(KDeviceW - 100, 0, 100, 45)];
        label.text = @"联系信息";
        label.textColor = KHexRGB(0x666666);
        label.font = KFont(13);
        [phoneView addSubview:label];
        
        UIImageView * phoneImageView = [[UIImageView alloc]initWithFrame:KFrame(KDeviceW -15-15, 15, 15, 15)];
        phoneImageView.image = KImageName(@"灰色三角下拉");
        phoneImageView.contentMode = UIViewContentModeScaleAspectFit;
        [phoneView addSubview:phoneImageView];
        
        if(isShowPhone)
        {
            phoneImageView.image = KImageName(@"橙色上拉小三角");
        }
        else
        {
            phoneImageView.image = KImageName(@"灰色三角下拉");
        }
        

        
        UIButton *phoneFoldBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        phoneFoldBtn.frame = label.frame;
        [phoneFoldBtn addTarget:self action:@selector(showPhone) forControlEvents:UIControlEventTouchUpInside];
        [phoneView addSubview:phoneFoldBtn];
        
        UIView *lineView = [[UIView alloc]initWithFrame:KFrame(0, 44, KDeviceW, 1)];
        lineView.backgroundColor =KHexRGB(0xebebeb);
        [phoneView addSubview:lineView];
        
        
        return phoneView;
    }
    else
    {
        return [self headViewWithTag:(int)(KFoldBtnTag + section)];
    }
    
}


-(UIView*)headViewWithTag:(int)tag
{
    UIView *view = [[UIView alloc]initWithFrame:KFrame(0, 0, KDeviceW, 45)];
    view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    
    UIView *kuanView = [[UIView alloc]initWithFrame:KFrame(15, 15, 5, 15)];
    kuanView.backgroundColor = KRGB(75, 147, 246);
    kuanView.layer.cornerRadius = 2;
    kuanView.clipsToBounds = YES;
    [view addSubview:kuanView];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:KFrame(KDeviceW -15-15, 15, 15, 15)];
    
    imageView.tag = tag *100;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:imageView];
    
    UIButton *phoneFoldBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneFoldBtn.frame = view.frame;
    phoneFoldBtn.tag = tag;
    [phoneFoldBtn addTarget:self action:@selector(foldAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:phoneFoldBtn];
    
    NSString *title;
    BOOL isShow = NO;
    if(tag == KFoldBtnTag+2)
    {
        title = @"企业背景";
        [imageView removeFromSuperview];
        [phoneFoldBtn removeFromSuperview];
    }
    else if (tag == KFoldBtnTag +3)
    {
        title = @"风险信息";
        isShow = isShowRisk;
    }
    else if (tag == KFoldBtnTag +4)
    {
        title = @"经营状况";
        isShow = isShowManage;
    }
    else if (tag == KFoldBtnTag +5)
    {
        title = @"无形资产";
        isShow = isShowMoney;
    }
    
    if (isShow)
    {
        imageView.image = KImageName(@"橙色上拉小三角");
        
    }
    else
    {
        imageView.image = KImageName(@"灰色三角下拉");
    }

    
    UILabel *label = [[UILabel alloc]initWithFrame:KFrame(kuanView.maxX + 10, 0, KDeviceW - 100, view.height)];
    label.text = title;
    label.textColor = KHexRGB(0x333333);
    label.font = KBlodFont(14);
    [view addSubview:label];
    
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:KFrame(0, 44, KDeviceW, 1)];
    lineView.backgroundColor =KHexRGB(0xebebeb);
    [view addSubview:lineView];

    return view;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return  0.0001;
    }
    else
    {
        return 45;
    }
   
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}




-(UITableView *)backTableView
{
    if(!_backTableView)
    {
        _backTableView = [[UITableView alloc]initWithFrame:KFrame(0, 0, self.width, self.height - 48) style:UITableViewStyleGrouped];
        _backTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _backTableView.delegate = self;
        _backTableView.dataSource = self;
        _backTableView.backgroundColor = [UIColor clearColor];
        _backTableView.estimatedRowHeight = 0;//禁用self-sizing 计算完整contentsize
        _backTableView.estimatedSectionHeaderHeight = 0;
        _backTableView.estimatedSectionFooterHeight = 0;
    }
    
    return _backTableView;
}



-(void)reportView
{
    UIView *backView = [[UIView alloc]initWithFrame:KFrame(0, self.height - 48, KDeviceW, 48)];
    backView.backgroundColor = [UIColor colorWithRed:0.99 green:0.99 blue:0.99 alpha:1.00];
    backView.layer.shadowOpacity = 0.5;// 阴影透明度
    backView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    backView.layer.shadowRadius = 3;// 阴影扩散的范围控制
    backView.layer.shadowOffset  = CGSizeMake(1, 1);// 阴影的范围
    [self addSubview:backView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = KFrame(15, 0, 120, backView.height);
    [button setImage:KImageName(@"我的报告icon") forState:UIControlStateNormal];
    [button setTitle:@"  企业报告" forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleLabel.font = KFont(14);
    [button setTitleColor:KRGB(42, 160, 248) forState:UIControlStateNormal];
    [backView addSubview:button];
    
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = KFrame(KDeviceW - 100, 0, 100, backView.height);
    button2.backgroundColor = KRGB(48, 131, 250);
    [button2 setTitle:@"查看" forState:UIControlStateNormal];
    button2.titleLabel.font = KFont(15);
    [button2 addTarget:self action:@selector(checkReport) forControlEvents:UIControlEventTouchUpInside];
    [button2 setTitleColor:KHexRGB(0xffffff) forState:UIControlStateNormal];
    [backView addSubview:button2];
    

    
}













@end
