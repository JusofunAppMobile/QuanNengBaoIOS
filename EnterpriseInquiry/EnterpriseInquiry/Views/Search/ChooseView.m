//
//  ChooseView.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 16/8/15.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import "ChooseView.h"
#import "NearSearchCondition.h"
#import "FilterCellModel.h"


@interface ChooseView ()
{
    UIView *coverView;
    UIScrollView *backScrollView;
    
    UIButton *resetBtn;
    UIButton *confirmBtn;
    
    
   // UIView *lastCoverView;//覆盖最后一个的view的view
    
    NSMutableArray *dataArray;
    
    NSMutableArray *viewArray;
    
    NSMutableArray *minHightArray;//展示的高度的数组
    
    NSMutableArray *hightArray;//实际高度的数组
    
    NSMutableArray *chooseSelectArray;
    
    NSMutableArray *buttonArray;//按钮的数组
    
    BOOL isSXXX;//是否是失信信息

}


@end


@implementation ChooseView

-(instancetype)initWithFrame:(CGRect)frame isSX:(BOOL)isSX
{
    self = [super initWithFrame:frame];
    if (self) {
        
        isSXXX = isSX;
        
        dataArray  = [NSMutableArray arrayWithCapacity:1];
        chooseSelectArray = [NSMutableArray arrayWithCapacity:1];
        buttonArray = [NSMutableArray arrayWithCapacity:1];
        
        coverView = [[UIView alloc]initWithFrame:KFrame(0, 0, self.width, self.height)];
        coverView.backgroundColor = [KHexRGB(0x929393) colorWithAlphaComponent:0.0];
        [self addSubview:coverView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideChooseView)];
        [coverView addGestureRecognizer:tap];
        
        backScrollView = [[UIScrollView alloc]initWithFrame:KFrame(KDeviceW, 0, KChooseWidth, frame.size.height - 38)];
        backScrollView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backScrollView];
        
        resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        resetBtn.frame = KFrame(KDeviceW- KChooseWidth, frame.size.height, KChooseWidth/2, 38);
        resetBtn.backgroundColor = KRGB(228,228,228);
        [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
        [resetBtn setTitleColor:KRGB(255,132,70) forState:UIControlStateNormal];
        [resetBtn addTarget:self action:@selector(reloadButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:resetBtn];
        
        confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBtn.frame = KFrame(resetBtn.maxX, frame.size.height , KChooseWidth/2, 38);
        confirmBtn.backgroundColor = KRGB(255,119,46);
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:KRGB(255,255,255) forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(confirrm) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:confirmBtn];
        
       
        [self requestData];
        
        
    }
    return self;
}

#pragma mark  - 加载数据
-(void)requestData
{
    NSString *urlStr;
    NSArray *array ;
    HttpRequestType requestType;
    if(isSXXX)
    {
        array = KNear.sxChooseArray;
        urlStr = PriviceListDeal;
        requestType = HttpRequestTypeGet;
    }
    else
    {
        array = KNear.chooseArray;
        urlStr = GetKeyWordSummary;
        requestType = HttpRequestTypePost;
    }

    
    if(array.count >0)
    {
        dataArray = [NSMutableArray arrayWithArray:array];
        [self drawProvinceView];
    }
    else
    {
        __weak ChooseView *weakSelf = self;
        
        [RequestManager requestWithURLString:urlStr parameters:nil type:requestType success:^(id responseObject) {
            [MBProgressHUD hideHudToView:self animated:YES];
            if([[responseObject objectForKey:@"result"] intValue] == 0)
            {
                NSArray *tmpArray = [responseObject objectForKey:@"filterList"];
                NSArray *array = [ChooseDataModel mj_objectArrayWithKeyValuesArray:tmpArray];
                
                dataArray = [NSMutableArray arrayWithArray:array];
                
                NSDictionary *saveLocDic = [KUserDefaults objectForKey:KUserLocation];
                if(dataArray.count >0&&saveLocDic&&!isSXXX)
                {
                    ChooseDataModel *changeModel;
                    
                    int num = - 1;
                    
                    for(int i = 0;i<dataArray.count;i++)
                    {
                        ChooseDataModel *tmpModel = [dataArray objectAtIndex:i];
                        NSString *type = tmpModel.type;
                        if([type isEqualToString:@"1"])
                        {
                            num = i;
                            changeModel = tmpModel;
                            break;
                        }
                    }
                    if(num >=0)
                    {
                        NSArray *cityArray = changeModel.filterItemList;
                        NSMutableArray *muArray = [NSMutableArray arrayWithArray:cityArray];
                        NSMutableDictionary *locDic = [NSMutableDictionary dictionaryWithCapacity:1];
                        [locDic setObject:KDingWei forKey:@"value"];
                        [locDic setObject:[saveLocDic objectForKey:@"city"] forKey:@"name"];
                        [muArray insertObject:locDic atIndex:0];
                        
                        ChooseDataModel *saveModel = [[ChooseDataModel alloc]init];
                        saveModel.name = changeModel.name;
                        saveModel.type = changeModel.type;
                        saveModel.filterItemList = muArray;
                        saveModel.key = changeModel.key;
                        [dataArray replaceObjectAtIndex:num withObject:saveModel];
                    }
                    
                }
                if(isSXXX)
                {
                    KNear.sxChooseArray = dataArray;
                }
                else
                {
                    KNear.chooseArray = dataArray;
                }
                [weakSelf drawProvinceView];
            }
            else
            {
                [MBProgressHUD showError:[responseObject objectForKey:@"msg"] toView:self];
            }

        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"请求失败" toView:self];
        }];
        
    }
    
    
}

-(void)showChooseView
{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        
        coverView.backgroundColor = [KHexRGB(0x929393) colorWithAlphaComponent:0.9];
        
        CGRect frame = backScrollView.frame;
        frame.origin.x = KDeviceW- KChooseWidth;
        backScrollView.frame = frame;
        
        CGRect frame2 = confirmBtn.frame;
        frame2.origin.y = self.frame.size.height - 38;
        confirmBtn.frame = frame2;
        
        CGRect frame3 = resetBtn.frame;
        frame3.origin.y = self.frame.size.height - 38;
        resetBtn.frame = frame3;
        
    }];

}


-(void)hideChooseView
{
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = backScrollView.frame;
        frame.origin.x = KDeviceW ;
        backScrollView.frame = frame;
        
        CGRect frame2 = confirmBtn.frame;
        frame2.origin.y = self.frame.size.height ;
        confirmBtn.frame = frame2;
        
        CGRect frame3 = resetBtn.frame;
        frame3.origin.y = self.frame.size.height ;
        resetBtn.frame = frame3;
        
        coverView.backgroundColor = [KHexRGB(0x929393) colorWithAlphaComponent:0.0];

        
    } completion:^(BOOL finished) {
        CGRect frame = self.frame;
        frame.origin.x = KDeviceW;
        self.frame = frame;
        //[chooseView hideChooseView];
    }];
}

#pragma mark  - 按钮选择
-(void)buttonChoose:(ChooseButton*)sender
{
   // NSLog(@"%@",sender.name);
    
    if([sender.type isEqual: @"1"])
    {
        [MobClick event:@"Search48"];//城市筛选点击数
        [[BaiduMobStat defaultStat] logEvent:@"Search48" eventLabel:@"搜索结果页－城市筛选点击数"];


    }
    else if ([sender.type isEqual: @"2"])
    {
        [MobClick event:@"Search49"];//省份筛选点击数
        [[BaiduMobStat defaultStat] logEvent:@"Search49" eventLabel:@"搜索结果页－省份筛选点击数"];

    }else if ([sender.type isEqual: @"3"])
    {
        [MobClick event:@"Search50"];//搜索结果页－行业筛选点击数,
        [[BaiduMobStat defaultStat] logEvent:@"Search50" eventLabel:@"搜索结果页－行业筛选点击数"];

    }
    else if ([sender.type isEqual: @"4"])
    {
        [MobClick event:@"Search52"];//搜索结果页－注资筛选点击数
        [[BaiduMobStat defaultStat] logEvent:@"Search52" eventLabel:@"搜索结果页－注资筛选点击数"];

    }
    else if ([sender.type isEqual: @"5"])
    {
        [MobClick event:@"Search53"];//年限筛选点击数
        [[BaiduMobStat defaultStat] logEvent:@"Search53" eventLabel:@"搜索结果页－年限筛选点击数"];

    }
    
    
    bool isSelf = NO;
    
    for(ChooseButton*button in chooseSelectArray)
    {
        if([button.name isEqualToString:sender.name])
        {
            if(button.model == sender.model)
            {
                isSelf = YES;
            }
            button.selected = NO;
            [chooseSelectArray removeObject:button];
            break;
        }
        //城市和省份只能选择一个
        if(([button.type isEqualToString:@"1"] && [sender.type isEqualToString:@"2"]) || ([button.type isEqualToString:@"2"] && [sender.type isEqualToString:@"1"]))
        {
            button.selected = NO;
            [chooseSelectArray removeObject:button];
            break;
        }
        
    }
    
    if(!isSelf)
    {
        sender.selected = YES;
        
        [chooseSelectArray addObject:sender];
    }
   
    
    
}
#pragma mark  - 确定
-(void)confirrm
{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(chooseBack:)])
    {
        [self.delegate chooseBack:chooseSelectArray];
    }
    [self hideChooseView];
}

#pragma mark  - 重置
-(void)reloadButton
{
    for(ChooseButton*button in chooseSelectArray)
    {
        button.selected = NO;
    }
    
    [chooseSelectArray removeAllObjects];
}

#pragma mark  - 上下翻
-(void)upbuttonSelector:(UIButton*)sender
{
    
    if(sender.selected)//向上伸缩
    {
        for(int i = 0;i<viewArray.count;i++)
        {
            UIView *view = [viewArray objectAtIndex:i];
            if((view.tag - KBackViewTag) == (sender.tag - KUpbuttonTag))
            {
                CGFloat minHight = [[minHightArray objectAtIndex:i] floatValue];
                
                CGRect frame = view.frame;
                frame.size.height = minHight;
                view.frame = frame;
                
                NSDictionary *btnDic = [buttonArray objectAtIndex:i];
                NSArray *btnArray = [btnDic objectForKey:@"buttonArray"];
                for(ChooseButton *btn in btnArray)
                {
                    if(btn.y >= minHight)
                    {
                        btn.hidden = YES;
                    }
                }

                
                for(int k = i+1;k<viewArray.count;k++)
                {
                    UIView *view = [viewArray objectAtIndex:k];
                    CGFloat y = 20;
                    if(k!=0)
                    {
                        UIView *upView = [viewArray objectAtIndex:k-1];
                        y = upView.maxY;
                    }
                   
                    CGRect frame = view.frame;
                    frame.origin.y = y;
                    view.frame = frame;
                    
                    
                }
                
                break;
            }
        }
    }
    else //向下伸缩
    {
        for(int i = 0;i<viewArray.count;i++)
        {
            UIView *view = [viewArray objectAtIndex:i];
            if((view.tag - KBackViewTag) == (sender.tag - KUpbuttonTag))
            {
                CGFloat maxHight = [[hightArray objectAtIndex:i] floatValue];
                
                CGRect frame = view.frame;
                frame.size.height = maxHight;
                view.frame = frame;
                

                CGFloat minHight = [[minHightArray objectAtIndex:i] floatValue];
                
                NSDictionary *btnDic = [buttonArray objectAtIndex:i];
                NSArray *btnArray = [btnDic objectForKey:@"buttonArray"];
                
                for(ChooseButton *btn in btnArray)
                {
                    if(btn.y >= minHight)
                    {
                        btn.hidden = NO;
                    }
                }

                
                for(int k = i+1;k<viewArray.count;k++)
                {
                    UIView *view = [viewArray objectAtIndex:k];
                    CGFloat y = 20;
                    if(k!=0)
                    {
                        UIView *upView = [viewArray objectAtIndex:k-1];
                        y = upView.maxY;
                    }
                    
                    
                    CGRect frame = view.frame;
                    frame.origin.y = y;
                    view.frame = frame;
                    
                }
                
                
                
                break;
            }
        }
    
    }
    
        UIView *lastView = [viewArray lastObject];
    
        backScrollView.contentSize = CGSizeMake(KChooseWidth,lastView.maxY + KChooseBtnHight);
//        if(lastCoverView)
//        {
//            
//            CGRect frame = lastCoverView.frame;
//            frame.origin.y = lastView.maxY;
//            lastCoverView.frame = frame;
//            
//            backScrollView.contentSize = CGSizeMake(KChooseWidth,lastCoverView.maxY + KChooseBtnHight);
//        }
//        else
//        {
//            
//        }


    sender.selected = !sender.selected;
}



#pragma mark  - 绘制界面
-(void)drawProvinceView
{
    
    viewArray = [NSMutableArray arrayWithCapacity:1];
    minHightArray = [NSMutableArray arrayWithCapacity:1];
    hightArray = [NSMutableArray arrayWithCapacity:1];
    buttonArray = [NSMutableArray arrayWithCapacity:1];
    
   
    
    CGFloat lastHight  = 10+12 + KChooseBtnHight *2;
    CGFloat viewY = KStatusBarHeight;
    
    UIView * backView;
    
    for(int i =0;i<dataArray.count;i++)
    {
        NSMutableArray *saveBtnArray = [NSMutableArray arrayWithCapacity:1];
        ChooseDataModel *model = [dataArray objectAtIndex:i];
        
        backView = [[UIView alloc]initWithFrame:KFrame(0, viewY, KChooseWidth, 100)];
        backView.tag = KBackViewTag + i;
        backView.backgroundColor = [UIColor whiteColor];
        [backScrollView addSubview:backView];
        
        UILabel *locLabel = [[UILabel alloc]initWithFrame:KFrame(10, 0, 70, 0)];
        if(i == 0 && !isSXXX)
        {
            locLabel.frame = KFrame(10, 10, 70, 12);
            locLabel.textColor = KRGB(51,51,51);
            locLabel.font = KFont(12);
            locLabel.text = @"所在地区";
            [backView addSubview:locLabel];
        }
        
        UILabel *label = [[UILabel alloc]initWithFrame:KFrame(10, locLabel.maxY+15, KChooseWidth - 60, 12)];
        label.textColor = KRGB(51,51,51);
        label.font = KFont(12);
        label.text = model.name;
        [backView addSubview:label];
        UIButton * upbutton;
        if(!isSXXX)
        {
            upbutton = [self upbuttonWithFrame:KFrame(0, locLabel.maxY, KChooseWidth, 15+12+10)];
            upbutton.tag = KUpbuttonTag + i;
            [backView addSubview:upbutton];
        }
        
        CGFloat x = 10;
        CGFloat y = label.maxY +10;
        
        CGFloat buttonLastY = 0;
        
        CGFloat buttonHight = KChooseBtnHight;
        
        for(int i = 0;i<model.filterItemList.count;i++)
        {
           FilterCellModel *buttonModel = [model.filterItemList objectAtIndex:i];
            NSString *name = buttonModel.name;
            CGFloat buttonWidth = [Tools getWidthWithString:name fontSize:10 maxHeight:KChooseBtnHight];
            if(buttonWidth > KChooseBtnWidth)
            {
              CGFloat hight = [Tools getHeightWithString:name fontSize:14 maxWidth:KChooseBtnWidth]+20;
                if(buttonHight<hight)
                {
                    buttonHight = hight;
                }
            }
            
        }
        
        for(int i = 0;i<model.filterItemList.count;i++)
        {
        
            FilterCellModel *buttonModel = [model.filterItemList objectAtIndex:i];
            ChooseButton * button = [[ChooseButton alloc]initWithFrame:KFrame(x, y, KChooseBtnWidth, buttonHight)];
            [button addTarget:self action:@selector(buttonChoose:) forControlEvents:UIControlEventTouchUpInside];
            button.model = buttonModel;
            button.name = model.name;
            button.type = model.type;
            button.key = model.key;
            if([model.type isEqualToString:@"1"]&&[buttonModel.value isEqualToString:KDingWei])
            {
                button.isSpecial = YES;
            }
            
            [backView addSubview:button];
            [saveBtnArray addObject:button];
            
            for(ChooseButton * button in chooseSelectArray)
            {
                if(button.model == buttonModel)
                {
                    button.selected = YES;
                }
            }
            
            if(button.y >= lastHight && !isSXXX)
            {
                button.hidden = YES;
            }
            
            x = button.x + KChooseBtnWidth + 10;
            
            y = button.y;
            
            if(x > KChooseWidth - 10)
            {
                x = 10;
                y = button.y + buttonHight +10;
                
                if(i == 2)
                {
                    lastHight = y + buttonHight +10;
                }
            }
            
            buttonLastY = button.maxY;
            
        }
        
        if(!isSXXX)
        {
            CGRect frame = backView.frame;
            frame.size.height = lastHight;
            backView.frame = frame;
            
            [viewArray addObject:backView];
            
            if(lastHight == y)
            {
                upbutton.hidden = YES;
            }
            else
            {
                upbutton.hidden = NO;
            }
            
            [minHightArray addObject:[NSString stringWithFormat:@"%f",lastHight]];
            [hightArray addObject:[NSString stringWithFormat:@"%f",buttonLastY]];
            
            
            viewY = backView.y+lastHight;
            
            
            NSMutableDictionary * btnDic = [NSMutableDictionary dictionaryWithCapacity:1];
            [btnDic setObject:model.type forKey:@"type"];
            [btnDic setObject:saveBtnArray forKey:@"buttonArray"];
            
            [buttonArray addObject:btnDic];

        }
        else
        {
            CGRect frame = backView.frame;
            frame.size.height = buttonLastY;
            backView.frame = frame;
            
            viewY = backView.maxY + KChooseBtnHight;
        }
        
        
        
    }
    
    
    backScrollView.contentSize = CGSizeMake(KChooseWidth,viewY + KChooseBtnHight);

}







-(UIButton *)upbuttonWithFrame:(CGRect)frame
{
    UIButton *upbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    upbutton.frame = frame;
    [upbutton setImage:KImageName(@"botom") forState:UIControlStateNormal];
    [upbutton setImage:KImageName(@"top") forState:UIControlStateSelected];
    [upbutton setImageEdgeInsets:UIEdgeInsetsMake(0, frame.size.width/2 - 20 , 0, -frame.size.width/2 +20)];
    [upbutton addTarget:self action:@selector(upbuttonSelector:) forControlEvents:UIControlEventTouchUpInside];
    return upbutton;
}


-(UILabel *)titleLabelWithFrame:(CGRect)frame title:(NSString *)title
{
    UILabel *label2 = [[UILabel alloc]initWithFrame:frame];
    label2.textColor = KRGB(51,51,51);
    label2.font = KFont(12);
    label2.text = title;
    
    return label2;

}



@end


@implementation ChooseButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:KRGB(102,102,102) forState:UIControlStateNormal];
        self.backgroundColor = KRGB(244,244,244);
        // [self jm_setCornerRadius:2 withBackgroundColor:KRGB(244,244,244)];
        self.layer.cornerRadius = 2;
        self.clipsToBounds = YES;
        self.titleLabel.font = KFont(12);
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}


- (void)setModel:(FilterCellModel *)model{
    _model = model;
    [self setTitle:model.name forState:UIControlStateNormal];
}


-(void)setSelected:(BOOL)selected
{
    if(selected)
    {
        [self setTitleColor:KHexRGB(0xf76732) forState:UIControlStateNormal];
        [self jm_setCornerRadius:2 withBackgroundColor:KHexRGB(0xf6f1e9)];
    }
    else
    {
        [self setTitleColor:KRGB(102,102,102) forState:UIControlStateNormal];
        [self jm_setCornerRadius:2 withBackgroundColor:KRGB(244,244,244)];
    }
}


-(void)setIsSpecial:(BOOL)isSpecial
{
    if(isSpecial)
    {
       // CGFloat titleWidth = [Tools getWidthWithString:self.titleLabel.text fontSize:10 maxHeight:KChooseBtnHight];
        [self setImage:KImageName(@"Pin") forState:UIControlStateNormal];
        //[self setTitleEdgeInsets:UIEdgeInsetsMake(0, -titleWidth + 35 , 0, titleWidth -35 )];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.image.size.width-5, 0, self.imageView.image.size.width+5)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width+5 , 0, - self.titleLabel.bounds.size.width-5 )];
    }
    else
    {
        [self setImage:nil forState:UIControlStateNormal];
    }
}









@end







