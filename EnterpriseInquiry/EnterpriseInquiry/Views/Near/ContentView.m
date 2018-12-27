//
//  ContentView.m
//  jusfounData
//
//  Created by jusfoun on 16/3/2.
//  Copyright © 2016年 jusfoun. All rights reserved.
//

#import "ContentView.h"

@interface ContentView ()
{
   
    
    
    UIView *infoBackView;//名字到看详情的的backview
    
    UIView *adressBackView;//地址 电话 简介的backview
    
    UIView *detailBackView;//注册号剩下的backview
    
    NSString *telStr;
    
    //UIView *pullView;
    
    UIButton *collectBtn;
    //UIImageView *pullImageView;
    UIButton *pullBtn;
    
    UIImageView *infoImageView;
    UILabel* companyName;
    UIImageView *addressImageView;
    UILabel *companyAddress ;
    UIImageView *industryImageView;
    UILabel *companyIndustry;
    UIButton *detailBtn;
    UIView *btnBackView;
    UIView *pullBackView;
}


@end

@implementation ContentView


-(void)changeInfoBackView:(BOOL)showBack
{
    
    return;
    if(showBack)
    {
        infoImageView.hidden = NO;
        companyName.textColor = [UIColor whiteColor];
        companyAddress.textColor = [UIColor whiteColor];
        companyIndustry.textColor = [UIColor whiteColor];
        
        addressImageView.image = [UIImage imageNamed:@"白色地址"];
        industryImageView.image = [UIImage imageNamed:@"法人白色"];
        detailBtn.layer.borderColor = [UIColor clearColor].CGColor;
        btnBackView.hidden = NO;
        [detailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        pullBackView.hidden = YES;
        pullBtn.hidden = YES;
    }
    else
    {
        infoImageView.hidden = YES;
        companyName.textColor = KRGB(51, 51, 51);
        companyAddress.textColor = KRGB(51, 51, 51);
        companyIndustry.textColor = KRGB(51, 51, 51);
        
        addressImageView.image = [UIImage imageNamed:@"灰色地址"];
        industryImageView.image = [UIImage imageNamed:@"industry"];
        detailBtn.layer.borderColor = KRGB(253, 201, 169).CGColor;
        btnBackView.hidden = YES;
        [detailBtn setTitleColor:KRGB(237, 103, 38) forState:UIControlStateNormal];
        pullBackView.hidden = NO;
        pullBtn.hidden = NO;
    }

}



- (instancetype)initWithFrame:(CGRect)frame  withCompanyDic:(NSDictionary *)companyDic
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.backgroundColor = [UIColor whiteColor];
      

        
        pullBackView = [[UIView alloc]initWithFrame:KFrame(0, 0, KDeviceW, 30)];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)KRGB(248, 112, 68).CGColor, (__bridge id)KRGB(253, 182, 66).CGColor];
        gradientLayer.locations = @[@0.3, @0.7, @1.0];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1.0, 0);
        gradientLayer.frame = KFrame(0, 0, pullBackView.width, pullBackView.height);
        [pullBackView.layer addSublayer:gradientLayer];
        [self addSubview:pullBackView];
        
        
        pullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        pullBtn.frame = KFrame(0, 0, KDeviceW, 30);
        pullBtn.backgroundColor = [UIColor clearColor];
        [pullBtn setImage:KImageName(@"pull") forState:UIControlStateNormal];
        [pullBtn addTarget:self action:@selector(goTop) forControlEvents:UIControlEventTouchUpInside];
        pullBtn.alpha = 1;
        [self addSubview:pullBtn];
        
        
        
        
        
        infoBackView = [[UIView alloc]initWithFrame:KFrame(10, CGRectGetMaxY(pullBtn.frame), KDeviceW - 20, 125)];
        [self addSubview:infoBackView];
        
        
        infoImageView = [[UIImageView alloc]initWithFrame:KFrame(0, 0, infoBackView.width, infoBackView.height)];
        infoImageView.image = KImageName(@"新增企业的底");
        infoImageView.hidden = YES;
        [infoBackView addSubview:infoImageView];
        
        CGFloat nameHight = [Tools getHeightWithString:[companyDic objectForKey:@"entname"] fontSize:16 maxWidth:infoBackView.width - 30];
        nameHight = nameHight>15?nameHight:15;
        
        //公司名称
        companyName = [[UILabel alloc] init];
        companyName.text = [companyDic objectForKey:@"entname"];
        companyName.frame = CGRectMake(15, 20, infoBackView.width - 30,nameHight);
        companyName.textColor = KRGB(51, 51, 51);
        //companyName.font = [UIFont systemFontOfSize:18];
        companyName.font = KFont(16);
        companyName.numberOfLines = 0;
        companyName.backgroundColor = [UIColor clearColor];
        [infoBackView addSubview:companyName];
        if(companyName.text.length == 0)
        {
            companyName.text = @"公司";
        }
        
        //地址图标
        addressImageView = [[UIImageView alloc] init];
        addressImageView.frame = CGRectMake(10, CGRectGetMaxY(companyName.frame) +15 +3, 13, 16);
        addressImageView.image = [UIImage imageNamed:@"灰色地址"];
        [infoBackView addSubview:addressImageView];
        
        //地址
        companyAddress = [[UILabel alloc] init];
        NSString *addresStr = [companyDic objectForKey:@"area"];
        NSString *distans = [companyDic objectForKey:@"distince"];
        if(addresStr.length >0 && ![addresStr isEqualToString:@"-"] )
        {
            if(distans.length == 0)
            {
                companyAddress.text = addresStr;
            }
            else
            {
                companyAddress.text = [NSString stringWithFormat:@"%@ | %@",distans,addresStr];
            }
            
            companyAddress.textColor = [UIColor whiteColor] ;
        }
        else
        {
            if(distans.length == 0)
            {
                companyAddress.text = @"暂无";
                companyAddress.textColor = KRGB(204, 204, 204);
            }
            else
            {
                companyAddress.text = [NSString stringWithFormat:@"%@",distans];
            }

            
            
            
        }
        companyAddress.textColor = KRGB(51, 51, 51) ;
        companyAddress.font = KFont(14);
        CGSize labelSize = [self labelAutoCalculateRectWith:companyAddress.text FontSize:15 MaxSize:CGSizeMake(infoBackView.width/2, 20)];
        companyAddress.frame = CGRectMake(CGRectGetMaxX(addressImageView.frame)+7, CGRectGetMaxY(companyName.frame) +15,labelSize.width >60?labelSize.width:60, 20);
        [infoBackView addSubview:companyAddress];
        
        //行业图标
        industryImageView = [[UIImageView alloc] init];
        industryImageView.frame = CGRectMake(CGRectGetMaxX(companyAddress.frame) +20, companyAddress.frame.origin.y+4, 15, 12);
        industryImageView.image = [UIImage imageNamed:@"industry"];
        [infoBackView addSubview:industryImageView];
        
        //行业
        companyIndustry = [[UILabel alloc] init];
        NSString *industrStr = [companyDic objectForKey:@"corporateName"];
        if(industrStr.length >0 && ![industrStr isEqualToString:@"-"])
        {
            companyIndustry.text = industrStr;
            companyIndustry.textColor = [UIColor whiteColor];
            
           
        }
        else
        {
            companyIndustry.text = @"暂无";
            companyIndustry.textColor = KRGB(204, 204, 204);
        }
        companyIndustry.frame = CGRectMake(CGRectGetMaxX(industryImageView.frame) +7, companyAddress.frame.origin.y, infoBackView.width - CGRectGetMaxX(industryImageView.frame)-15, 20);
        companyIndustry.textColor = KRGB(51, 51, 51) ;;
        companyIndustry.font = KFont(14);
        [infoBackView addSubview:companyIndustry];
        
        
        btnBackView = [[UIView alloc]initWithFrame:KFrame(0, CGRectGetMaxY(companyIndustry.frame)+15, infoBackView.width , 35)];
        CAGradientLayer *detailLayer = [CAGradientLayer layer];
        detailLayer.colors = @[(__bridge id)KRGB(248, 112, 68).CGColor, (__bridge id)KRGB(253, 182, 66).CGColor];
        detailLayer.locations = @[@0.3, @0.7, @1.0];
        detailLayer.startPoint = CGPointMake(0, 0);
        detailLayer.endPoint = CGPointMake(1.0, 0);
        detailLayer.frame = KFrame(0, 0, btnBackView.width, btnBackView.height);
        [btnBackView.layer addSublayer:detailLayer];
        [infoBackView addSubview:btnBackView];
        btnBackView.hidden = YES;
  
        
        detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [detailBtn setTitle:@"查看详情" forState:UIControlStateNormal];
        [detailBtn setTitleColor:KRGB(237, 103, 38) forState:UIControlStateNormal];
        detailBtn.titleLabel.font = KFont(14);
        detailBtn.frame = KFrame(companyName.x, CGRectGetMaxY(companyIndustry.frame)+15, infoBackView.width - 2*companyName.x, 35);
        detailBtn.layer.cornerRadius = 35/2.0;
        detailBtn.clipsToBounds = YES;
        detailBtn.layer.borderColor = KRGB(253, 201, 169).CGColor;
        detailBtn.layer.borderWidth = 1;
        [detailBtn addTarget:self action:@selector(goDetail:) forControlEvents:UIControlEventTouchUpInside];
        [infoBackView addSubview:detailBtn];
        
        
        CGRect infoFrame = infoBackView.frame;
        infoFrame.size.height = CGRectGetMaxY(detailBtn.frame);
        infoBackView.frame = infoFrame;
        
        CGRect infoImageViewFrame = infoImageView.frame;
        infoImageViewFrame.size.height = CGRectGetMaxY(detailBtn.frame);
        infoImageView.frame = infoImageViewFrame;
        
        
        self.detailBtnHight = detailBtn.maxY +20 + infoBackView.y;
    
        adressBackView = [[UIView alloc]initWithFrame:KFrame(0, CGRectGetMaxY(infoBackView.frame), KDeviceW, 0)];
        [self addSubview:adressBackView];
        
        NSString *addressStr = [companyDic objectForKey:@"address"];

        if(addressStr.length == 0)
        {
            addressStr = @"-";
        }
        
        CGSize addressSize = [self labelAutoCalculateRectWith:addressStr FontSize:15 MaxSize:CGSizeMake(KDeviceW - 40 - 10 , MAXFLOAT)];
        
        UILabel *addresLabel = [[UILabel alloc]initWithFrame:KFrame(40, 20, KDeviceW - 80 - 10, addressSize.height >40?addressSize.height:40)];
        addresLabel.font = KFont(14);
        addresLabel.textColor = KRGB(117, 117, 117);
        addresLabel.numberOfLines = 0;
        addresLabel.text = addressStr;
        [adressBackView addSubview:addresLabel];
        
        
        UIView *lineView = [[UIView alloc]initWithFrame:KFrame(10, CGRectGetMaxY(addresLabel.frame)+10, KDeviceW -20, 1)];
        lineView.backgroundColor = KRGB(247, 247, 247);
        [adressBackView addSubview:lineView];
        
        UIImageView *addressImage = [[UIImageView alloc] init];
        addressImage.frame = CGRectMake(10, addresLabel.y + (addresLabel.height - 20)/2, 17, 20);
        addressImage.image = [UIImage imageNamed:@"地址icon"];
        [adressBackView addSubview:addressImage];
        
        UIImageView *iconRightImage = [[UIImageView alloc] init];
        iconRightImage.frame = CGRectMake(KDeviceW - 40,addresLabel.y + (addresLabel.height - 13)/2 , 7, 13);
        iconRightImage.image = [UIImage imageNamed:@"more"];
        [adressBackView addSubview:iconRightImage];
        
        UIButton *addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addressBtn.frame = KFrame(0, 0, KDeviceW, lineView.maxY);
        [addressBtn addTarget:self action:@selector(goAddress) forControlEvents:UIControlEventTouchUpInside];
        [adressBackView addSubview:addressBtn];

      
        
        
        UIImageView *telImageView = [[UIImageView alloc]initWithFrame:KFrame(10, CGRectGetMaxY(lineView.frame)+10+13, 17, 17)];
        telImageView.image = KImageName(@"电话icon");
        [adressBackView addSubview:telImageView];
        
        
        telStr = [companyDic objectForKey:@"callNum"];
        if(telStr.length == 0)
        {
            telStr = @"-";
        }
        UILabel *telLabel = [[UILabel alloc]initWithFrame:KFrame(CGRectGetMaxX(telImageView.frame)+10, CGRectGetMaxY(lineView.frame)+10, KDeviceW - CGRectGetMaxX(telImageView.frame)- 20 - 40, 40)];
        telLabel.text = telStr;
        telLabel.textColor = KRGB(117, 117, 117);
        telLabel.font = KFont(14);
        [adressBackView addSubview:telLabel];
        
        UIImageView *iconRightImage2 = [[UIImageView alloc] init];
        iconRightImage2.frame = CGRectMake(KDeviceW - 40,CGRectGetMaxY(lineView.frame)+3.5+20, 7, 13);
        iconRightImage2.image = [UIImage imageNamed:@"more"];
        [adressBackView addSubview:iconRightImage2];
        
        
       
        UIView *lineView2 = [[UIView alloc]initWithFrame:KFrame(10, CGRectGetMaxY(telLabel.frame)+10, KDeviceW -20, 1)];
        lineView2.backgroundColor = KRGB(247, 247, 247);
        [adressBackView addSubview:lineView2];
        
        UIButton *telBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        telBtn.frame = KFrame(0, CGRectGetMaxY(lineView.frame), KDeviceW, lineView2.maxY - lineView.maxY);
        [telBtn addTarget:self action:@selector(gotel) forControlEvents:UIControlEventTouchUpInside];
        [adressBackView addSubview:telBtn];
        
    
        adressBackView.frame = KFrame(0,CGRectGetMaxY(infoBackView.frame) , KDeviceW, CGRectGetMaxY(lineView2.frame));
        
        
        detailBackView = [[UIView alloc]initWithFrame:KFrame(0, CGRectGetMaxY(adressBackView.frame), KDeviceW, 0)];
        [self addSubview:detailBackView];
        
        
        UILabel *zhuCe = [self creatViewWithTitle:@"注册号" isTitle:YES];
        zhuCe.frame = KFrame(10, 10, KDeviceW-20, 20);
        
   
        UILabel *zhuCeLabel = [self creatViewWithTitle:[companyDic objectForKey:@"registerNum"] isTitle:NO];
        zhuCeLabel.frame = KFrame(10, CGRectGetMaxY(zhuCe.frame)+5, KDeviceW-20, 20);
        
        UIView *lineView3 = [[UIView alloc]initWithFrame:KFrame(10, CGRectGetMaxY(zhuCeLabel.frame)+10, KDeviceW -20, 1)];
        lineView3.backgroundColor = KRGB(247, 247, 247);
        [detailBackView addSubview:lineView3];
        
        
        UILabel *leixing = [self creatViewWithTitle:@"类型" isTitle:YES];
        leixing.frame = KFrame(10, CGRectGetMaxY(lineView3.frame)+10, KDeviceW-20, 20);
        
        
        UILabel *leixingLabel = [self creatViewWithTitle:[companyDic objectForKey:@"entType"] isTitle:NO];
        leixingLabel.frame = KFrame(10, CGRectGetMaxY(leixing.frame)+5, KDeviceW-20, 20);
        
        
        UIView *lineView4 = [[UIView alloc]initWithFrame:KFrame(10, CGRectGetMaxY(leixingLabel.frame)+10, KDeviceW -20, 1)];
        lineView4.backgroundColor = KRGB(247, 247, 247);
        [detailBackView addSubview:lineView4];
        
        UILabel *faren = [self creatViewWithTitle:@"法人" isTitle:YES];
        faren.frame = KFrame(10, CGRectGetMaxY(lineView4.frame)+10, (KDeviceW-20)/2, 20);
        
        
        UILabel *farenLabel = [self creatViewWithTitle:[companyDic objectForKey:@"corporateName"] isTitle:NO];
        farenLabel.frame = KFrame(10, CGRectGetMaxY(faren.frame)+5, (KDeviceW-20)/2, 20);
        
        
        UILabel *zhucejijin = [self creatViewWithTitle:@"注册资金" isTitle:YES];
        zhucejijin.frame = KFrame(KDeviceW/2, CGRectGetMaxY(lineView4.frame)+10, (KDeviceW-20)/2, 20);
    
        NSString *registerCapitalStr = [companyDic objectForKey:@"registerCapital"];
        if(registerCapitalStr.length == 0||[registerCapitalStr isEqualToString:@"0"]||[registerCapitalStr isEqualToString:@"<null>"]||[registerCapitalStr isEqualToString:@"(null)"]||[registerCapitalStr isEqualToString:@"-"])
        {
            registerCapitalStr = @"-";
        }
        else
        {
            registerCapitalStr = [NSString stringWithFormat:@"%@",[companyDic objectForKey:@"registerCapital"]];
        }
        UILabel *zhucejijinLabel = [self creatViewWithTitle:registerCapitalStr isTitle:NO];
        zhucejijinLabel.frame = KFrame(KDeviceW/2, CGRectGetMaxY(faren.frame)+5, (KDeviceW-20)/2, 20);
        
       
        UIView *lineView5 = [[UIView alloc]initWithFrame:KFrame(10, CGRectGetMaxY(zhucejijinLabel.frame)+10, KDeviceW -20, 1)];
        lineView5.backgroundColor = KRGB(247, 247, 247);
        [detailBackView addSubview:lineView5];

        
        UILabel *chengliriqi = [self creatViewWithTitle:@"成立日期" isTitle:YES];
        chengliriqi.frame = KFrame(10, CGRectGetMaxY(lineView5.frame)+10, (KDeviceW-20)/2, 20);
        
        
        UILabel *chengliriqiLabel = [self creatViewWithTitle:[companyDic objectForKey:@"registerDate"] isTitle:NO];
        chengliriqiLabel.frame = KFrame(10, CGRectGetMaxY(chengliriqi.frame)+5, (KDeviceW-20)/2, 20);
        
        
        UILabel *dengji = [self creatViewWithTitle:@"登记状态" isTitle:YES];
        dengji.frame = KFrame(KDeviceW/2, CGRectGetMaxY(lineView5.frame)+10, (KDeviceW-20)/2, 20);
        
        UILabel *dengjiLabel = [self creatViewWithTitle:[companyDic objectForKey:@"businessState"] isTitle:NO];
        dengjiLabel.frame = KFrame(KDeviceW/2, CGRectGetMaxY(chengliriqi.frame)+5, (KDeviceW-20)/2, 20);
        
        
        UIView *lineView6 = [[UIView alloc]initWithFrame:KFrame(10, CGRectGetMaxY(dengjiLabel.frame)+10, KDeviceW -20, 1)];
        lineView6.backgroundColor = KRGB(247, 247, 247);
        [detailBackView addSubview:lineView6];
        
        UILabel *gudong = [self creatViewWithTitle:@"股东数" isTitle:YES];
        gudong.frame = KFrame(10, CGRectGetMaxY(lineView6.frame)+10, (KDeviceW-20)/2, 20);
        
        
        UILabel *gudongLabel = [self creatViewWithTitle:[companyDic objectForKey:@"shareholderNum"] isTitle:NO];
        gudongLabel.frame = KFrame(10, CGRectGetMaxY(gudong.frame)+5, (KDeviceW-20)/2, 20);
        if([gudongLabel.text isEqualToString:@"-"])
        {
            gudongLabel.text = @"0";
        }
        
        UILabel *touzi = [self creatViewWithTitle:@"投资次数" isTitle:YES];
        touzi.frame = KFrame(KDeviceW/2, CGRectGetMaxY(lineView6.frame)+10, (KDeviceW-20)/2, 20);
        
        UILabel *touziLabel = [self creatViewWithTitle:[companyDic objectForKey:@"investmentNum"] isTitle:NO];
        touziLabel.frame = KFrame(KDeviceW/2, CGRectGetMaxY(touzi.frame)+5, (KDeviceW-20)/2, 20);
        if([touziLabel.text isEqualToString:@"-"])
        {
            touziLabel.text = @"0";
        }


        
        UIView *lineView7 = [[UIView alloc]initWithFrame:KFrame(10, CGRectGetMaxY(touziLabel.frame)+10, KDeviceW -20, 1)];
        lineView7.backgroundColor = KRGB(247, 247, 247);
        [detailBackView addSubview:lineView7];
        
        UILabel *renyuan = [self creatViewWithTitle:@"主要人员" isTitle:YES];
        renyuan.frame = KFrame(10, CGRectGetMaxY(lineView7.frame)+10, (KDeviceW-20)/2, 20);
        
        
        UILabel *renyuanLabel = [self creatViewWithTitle:[companyDic objectForKey:@"mainPersonalNum"] isTitle:NO];
        renyuanLabel.frame = KFrame(10, CGRectGetMaxY(renyuan.frame)+5, (KDeviceW-20)/2, 20);
        
        
        UILabel *gongshang = [self creatViewWithTitle:@"工商变更" isTitle:YES];
        gongshang.frame = KFrame(KDeviceW/2, CGRectGetMaxY(lineView7.frame)+10, (KDeviceW-20)/2, 20);
        
        UILabel *gongshangLabel = [self creatViewWithTitle:[companyDic objectForKey:@"ICchangeNum"] isTitle:NO];
        gongshangLabel.frame = KFrame(KDeviceW/2, CGRectGetMaxY(gongshang.frame)+5, (KDeviceW-20)/2, 20);

        
        UIView *lineView8 = [[UIView alloc]initWithFrame:KFrame(10, CGRectGetMaxY(gongshangLabel.frame)+10, KDeviceW -20, 1)];
        lineView8.backgroundColor = KRGB(247, 247, 247);
        [detailBackView addSubview:lineView8];

        
        UILabel *susong = [self creatViewWithTitle:@"诉讼数" isTitle:YES];
        susong.frame = KFrame(10, CGRectGetMaxY(lineView8.frame)+10, (KDeviceW-20)/2, 20);
        
        
        UILabel *susongLabel = [self creatViewWithTitle:[companyDic objectForKey:@"lawsuitNum"] isTitle:NO];
        susongLabel.frame = KFrame(10, CGRectGetMaxY(susong.frame)+5, (KDeviceW-20)/2, 20);
        
        
        UILabel *chufa = [self creatViewWithTitle:@"处罚数" isTitle:YES];
        chufa.frame = KFrame(KDeviceW/2, CGRectGetMaxY(lineView8.frame)+10, (KDeviceW-20)/2, 20);
        
        UILabel *chufaLabel = [self creatViewWithTitle:[companyDic objectForKey:@"punishNum"] isTitle:NO];
        chufaLabel.frame = KFrame(KDeviceW/2, CGRectGetMaxY(chufa.frame)+5, (KDeviceW-20)/2, 20);
   
        
        
        
        detailBackView.frame = KFrame(0, CGRectGetMaxY(adressBackView.frame)+10, KDeviceW, CGRectGetMaxY(chufaLabel.frame));
        
        CGFloat selfHight = CGRectGetMaxY(detailBackView.frame) + 20;
        if(selfHight < KDeviceH)
        {
            selfHight = KDeviceH;
        }
        self.frame = KFrame(frame.origin.x, frame.origin.y, frame.size.width,selfHight);
        
        
        
    }
    return self;
}

-(void)goDetail:(UIButton *)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(checkDetail)])
    {
        [self.delegate checkDetail];
    }
}


-(void)collectBtnBackGroundcanleShoucang:(UIButton*)sender{
     sender.backgroundColor = KRGB(27, 30, 41);
}
-(void)collectBtnBackGroundcanle:(UIButton*)sender
{
    sender.backgroundColor = KRGB(181, 14, 31);
}

-(void)collectBtnBackGroundHighlighted:(UIButton*)sender
{
    sender.backgroundColor = KRGB(181, 14, 31);
}
-(void)collectCompany:(UIButton*)sender
{
    
    
    sender.backgroundColor = KRGB(27, 30, 41);;
    
    
    
    if(sender.tag == 2400)
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(collectCompany:)])
        {
            [self.delegate collectCompany:YES];
        }

    }
    else
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(collectCompany:)])
        {
            [self.delegate collectCompany:NO];
        }

    }
    
}

-(void)goAddress
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(goAdress)])
    {
        [self.delegate goAdress];
    }

}

-(void)gotel
{
    if(telStr.length == 0||[telStr isEqualToString:@"-"]||[telStr isEqualToString:@"——"]||[telStr isEqualToString:@" "]||[telStr isEqualToString:@"_"])
    {
        return;
    }
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",telStr];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self addSubview:callWebview];
  
    NSLog(@"电话");
}

-(UILabel *)creatViewWithTitle:(NSString *)title isTitle:(BOOL)isTitle
{
    UILabel *zhucejijin = [[UILabel alloc]init];
    if(title.length == 0 || [title isEqualToString:@"0"]|| [title isEqualToString:@"-"])
    {
        zhucejijin.text = @"-";
    }
    else
    {
        zhucejijin.text = title;
    }
    
    zhucejijin.font = [UIFont fontWithName:@"Helvetica" size:15];
    if(isTitle)
    {
        zhucejijin.textColor = KRGB(166, 166, 166);
    }
    else
    {
        zhucejijin.textColor = KRGB(40, 43, 53);
    }
    [detailBackView addSubview:zhucejijin];
    
    return zhucejijin;
}







-(void)goTop
{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(goTop)])
    {
        [self.delegate goTop];
    }

}






























- (CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize

{
    
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    
    NSDictionary* attributes =@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:fontSize],NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    
    
    
    labelSize.height=ceil(labelSize.height);
    
    labelSize.width=ceil(labelSize.width);
    
    return labelSize;
    
}
-(void)changeCollect:(BOOL)isCollect
{
    if(isCollect)//收藏
    {
        [collectBtn setImage:KImageName(@"aready_Collection") forState:UIControlStateNormal];
        collectBtn.tag = 2401;
        [collectBtn setTitle:@"已收藏" forState:UIControlStateNormal];
    }
    else
    {
        [collectBtn setImage:KImageName(@"CollectionXing") forState:UIControlStateNormal];
        collectBtn.tag = 2400;
        [collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    }
}




@end
