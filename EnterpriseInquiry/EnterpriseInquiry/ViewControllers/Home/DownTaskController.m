//
//  DownTaskController.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 17/7/31.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "DownTaskController.h"
#import "AESEncrypt.h"
#import <AFNetworkReachabilityManager.h>

@interface DownTaskController ()
{
    DownTaskView *taskView;
    
    DownTaskModel *taskModel;
    
    NSString *requestStr;
    
    NSTimer *timer;
    
    BOOL isStop;
    
    int nextTime;
    
    NSTimer *nextTimer;
    
}

@end

@implementation DownTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isStop = NO;
    
    [self makeNavigationbarButton];
    
    [KNotificationCenter addObserver:self selector:@selector(netChnage) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    
    
    taskView = [[DownTaskView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:taskView];
    
    
    //[self startRequest];
    
    
}

-(void)startRequest
{
    [self whichTaskType];
}


-(void)netChnage
{
    if([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable && isStop == YES)
    {
        [self whichTaskType];
    }
}

-(void)whichTaskType
{
    NSArray *array = [DownTaskModel findAll];
    if(array.count == 0)
    {
        NSDictionary *dic = [KUserDefaults objectForKey:KSaveTimeDic];
        
        if(dic)
        {
            NSString *dateStr = [dic objectForKey:KSaveDate];
            NSString *spaceStr = [dic objectForKey:KSaveSpace];
            
            
            NSDateFormatter *df = [[NSDateFormatter alloc] init];//格式化
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString * s1 = [df stringFromDate:[NSDate date]];
            
            double space = [self dateTimeDifferenceWithStartTime:dateStr endTime:s1];
            if(space > [spaceStr doubleValue])
            {
                [self getTask];
            }
            else
            {
                [self beginTimer:[spaceStr doubleValue] - space];
                
                nextTime = [spaceStr doubleValue] - space;
                
                taskView.nextLabel.text = [NSString stringWithFormat:@"下次请求时间:%f",[spaceStr doubleValue] - space];
            }

        }
        else
        {
            [self getTask];
        }
        
    }
    else
    {
        taskModel = [array objectAtIndex:0];
        if(taskModel.taskType == TaskGetFail || taskModel.taskType == TaskGetFail ||taskModel.taskType == TaskGetFail)
        {
            [self beginTimer:KNextTime];
        }
        else if (taskModel.taskType == TaskGetSucces)
        {
            [self startLoad];
        }
        else if (taskModel.taskType == TaskRequestSucces)
        {
            [self upLoadRequest];
        }
        
        
    }
    
}



#pragma mark - 获取任务
-(void)getTask
{
    if([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable)
    {
        //[MBProgressHUD showError:@"无网络,请稍后再试" toView:self.view];
        isStop = YES;
        return;
    }
    
    //[MBProgressHUD showMessag:@"正在请求任务" toView:self.view];
    taskModel = [[DownTaskModel alloc]init];
    KWeakSelf;
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameter setObject:[AESEncrypt aesEncryptString:[NSString stringWithFormat:@"%@_%@",[self getDateStrWithDate:[NSDate date]],[UIDevice currentDevice].identifierForVendor.UUIDString] aesKey:KAESKey] forKey:@"di"];
    
    [RequestManager getWithURLString:KGetTask parameters:parameter success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if([responseObject[@"result"] integerValue] == 0)
        {
            //[MBProgressHUD showSuccess:@"请求任务成功" toView:self.view];
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            taskModel.u = [AESEncrypt aesDecryptString:[dic objectForKey:@"u"] aesKey:KAESKey];
            taskModel.t = [NSString stringWithFormat:@"%f",[[dic objectForKey:@"t"] floatValue]/1000.00];
            
            taskModel.taskType = TaskGetSucces;
            [taskModel save];
            [taskView reloadTaskViewWithTaskModel:taskModel];
            
            NSDateFormatter *df = [[NSDateFormatter alloc] init];//格式化
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString * s1 = [df stringFromDate:[NSDate date]];
            
            NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithCapacity:1];
            [tmpDic setObject:s1 forKey:KSaveDate];
            [tmpDic setObject:taskModel.t forKey:KSaveSpace];
            [KUserDefaults setObject:tmpDic forKey:KSaveTimeDic];
            
            [weakSelf startLoad];
        }
        else
        {
            //[MBProgressHUD showError:@"请求任务失败" toView:self.view];
            taskModel.taskType = TaskGetFail;
            [weakSelf beginTimer:KNextTime];
            [taskModel save];
            [taskView reloadTaskViewWithTaskModel:taskModel];
        }
        
    } failure:^(NSError *error) {
        //[MBProgressHUD showError:@"请求任务失败" toView:self.view];
        taskModel.taskType = TaskGetFail;
        [weakSelf beginTimer:KNextTime];
        [taskModel save];
        [taskView reloadTaskViewWithTaskModel:taskModel];
    }];
    
    
}


#pragma mark - 开始下载
-(void)startLoad
{
    if(taskModel.u.length == 0)
    {
        [self upLoadSuccess];
        return;
    }
    if([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable)
    {
        //[MBProgressHUD showError:@"无网络,请稍后再试" toView:self.view];
        isStop = YES;
        return;
    }
    
    //[MBProgressHUD showMessag:@"正在请求任务数据" toView:self.view];
    KWeakSelf
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)taskModel.u,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,kCFStringEncodingUTF8));
    
    [RequestManager getWithURLString:encodedString parameters:nil success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
    
    [RequestManager getHttpResponseWithURLString:encodedString parameters:nil success:^(id responseObject) {
        //[MBProgressHUD showSuccess:@"请求任务数据成功" toView:self.view];
        taskModel.taskType = TaskRequestSucces;
        requestStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //requestStr = [weakself convertToJsonData:responseObject];
        [taskModel save];
        [taskView reloadTaskViewWithTaskModel:taskModel];
        [weakSelf upLoadRequest];
        
    } failure:^(NSError *error) {
        //[MBProgressHUD showError:@"请求任务数据失败" toView:self.view];
        taskModel.taskType = TaskRequestFail;
        taskModel.requestFailCount = taskModel.requestFailCount+1;
        if(taskModel.requestFailCount >= 2)
        {
            requestStr = error.description;
            [weakSelf upLoadRequest];
        }
        else
        {
            [weakSelf beginTimer:KNextTime];
        }
        [taskModel save];
        [taskView reloadTaskViewWithTaskModel:taskModel];
        
    }];

}

#pragma mark - 上传文件
-(void)upLoadRequest
{
    if([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable)
    {
        //[MBProgressHUD showError:@"无网络,请稍后再试" toView:self.view];
        isStop = YES;
        return;
    }
    taskView.resultLabel.text = [NSString stringWithFormat:@"请求数据结果:%@",requestStr];
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameter setObject:[AESEncrypt aesEncryptString:[NSString stringWithFormat:@"%@_%@",[self getDateStrWithDate:[NSDate date]],[UIDevice currentDevice].identifierForVendor.UUIDString] aesKey:KAESKey] forKey:@"di"];
    [parameter setObject:requestStr forKey:@"f"];
    [parameter setObject:taskModel.u forKey:@"u"];
    KWeakSelf
    //[MBProgressHUD showMessag:@"正在上传任务数据" toView:self.view];
    [RequestManager postWithURLString:KPostTask parameters:parameter success:^(id responseObject) {
        //[MBProgressHUD showSuccess:@"上传成功" toView:self.view];
        [weakSelf upLoadSuccess];
        
    } failure:^(NSError *error) {
        //[MBProgressHUD showError:@"上传任务数据失败" toView:self.view];
        taskModel.taskType = TaskUploadFail;
        taskModel.requestFailCount = taskModel.uploadFailCount+1;
        [taskModel save];
        [taskView reloadTaskViewWithTaskModel:nil];
        [weakSelf beginTimer:KNextTime];
        

    }];
}

-(void)beginTimer:(int)num
{
    NSLog(@"==================================%d",num);
    timer = [NSTimer timerWithTimeInterval:num target:self selector:@selector(timerSelector) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];
}



-(void)timerSelector
{
    if(taskModel)
    {
        if(taskModel.taskType == TaskGetFail)
        {
            [self getTask];
        }
        else if(taskModel.taskType == TaskRequestFail)
        {
            if(taskModel.requestFailCount >=2)
            {
                [self upLoadRequest];
            }
            else
            {
                [self startLoad];
            }
        }
        else if(taskModel.taskType == TaskUploadFail)
        {
            if(taskModel.uploadFailCount >= 5)
            {
                [self upLoadSuccess];
            }
            else
            {
                [self upLoadRequest];
            }
        }

    }
    else
    {
        [self getTask];
    }
    
}



-(void)upLoadSuccess
{
    //[MBProgressHUD showSuccess:@"上传任务数据成功" toView:self.view];
    [taskView reloadTaskViewWithTaskModel:nil];
    [DownTaskModel clearTable];
    taskModel = nil;
    [self whichTaskType];
}


-(NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}


/**
 * 开始到结束的时间差
 */
- (double)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    return value;
}

-(void)sendAdvice
{
    HandWriteController *vc  = [[HandWriteController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSString*)getDateStrWithDate:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYYMMDD"];
    
    return [formatter stringFromDate:date];
}

#pragma mark- 绘制导航栏按钮
-(void)makeNavigationbarButton
{
    
    
    UIButton *buttonRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonRight setTitle:@"单测" forState:UIControlStateNormal];
    buttonRight.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    buttonRight.titleLabel.textAlignment = NSTextAlignmentRight;
    buttonRight.frame = CGRectMake(0, 0, 50, 22);
    [buttonRight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    buttonRight.titleLabel.font = KNormalFont;
    [buttonRight addTarget:self action:@selector(sendAdvice) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar fs_setBackgroundColor:KHomeNavigationBarBackGroundColor];
}


-(void)dealloc
{
    [KNotificationCenter removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







@end
