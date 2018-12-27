//
//  DownTaskView.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 17/8/2.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "DownTaskView.h"

@implementation DownTaskView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        
        _udidLabel = [[UILabel alloc]initWithFrame:KFrame(15,KNavigationBarHeight, KDeviceW-30, 40)];
        _udidLabel.text =[NSString stringWithFormat:@"设备id:%@",[UIDevice currentDevice].identifierForVendor.UUIDString] ;
        _udidLabel.font = KFont(14);
        _udidLabel.numberOfLines = 0;
        [self addSubview:_udidLabel];

      
        _urlLabel = [[UILabel alloc]initWithFrame:KFrame(15,_udidLabel.maxY, KDeviceW-30, 50)];
        _urlLabel.font = KFont(14);
        _urlLabel.numberOfLines = 0;
        [self addSubview:_urlLabel];
        
        _statusLabel = [[UILabel alloc]initWithFrame:KFrame(15, _urlLabel.maxY +10, KDeviceW-30, 20)];
        _statusLabel.font = KFont(14);
        //_statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.numberOfLines = 0;
        [self addSubview:_statusLabel];
        
        _nextLabel = [[UILabel alloc]initWithFrame:KFrame(15, _statusLabel.maxY +10, KDeviceW-30, 20)];
        _nextLabel.font = KFont(14);
        //_statusLabel.textAlignment = NSTextAlignmentCenter;
        _nextLabel.numberOfLines = 0;
        [self addSubview:_nextLabel];
        
        _resultLabel = [[UILabel alloc]initWithFrame:KFrame(15, _nextLabel.maxY +10, KDeviceW-30, 150)];
        _resultLabel.font = KFont(14);
       // _resultLabel.textAlignment = NSTextAlignmentCenter;
        _resultLabel.numberOfLines = 0;
        [self addSubview:_resultLabel];
        
        
        
    }
    return self;
}

-(void)reloadTaskViewWithTaskModel:(DownTaskModel*)model
{
    if(model)
    {
        _urlLabel.text = [NSString stringWithFormat:@"请求链接:%@",model.u] ;
        
        if(model.taskType == TaskGetSucces)
        {
            _statusLabel.text = @"请求状态:请求任务成功";
        }
        else if (model.taskType == TaskGetFail)
        {
            _statusLabel.text = @"请求状态:请求任务失败";
        }
        else if (model.taskType == TaskRequestSucces)
        {
            _statusLabel.text = @"请求状态:任务请求数据成功";
        }
        else if (model.taskType == TaskRequestFail)
        {
            _statusLabel.text = @"请求状态:任务请求数据失败";
        }
        else if (model.taskType == TaskUploadSucces)
        {
            _statusLabel.text = @"请求状态:将数据上传成功";
        }
        else if (model.taskType == TaskUploadFail)
        {
            _statusLabel.text = @"请求状态:将数据上传失败";
        }
        
        //_resultLabel.text = @"";
        
    }
    else
    {
      //  _urlLabel.text = @"";
        //_statusLabel.text = @"";
        //_resultLabel.text = @"";
    }
    
    
    
}


@end
