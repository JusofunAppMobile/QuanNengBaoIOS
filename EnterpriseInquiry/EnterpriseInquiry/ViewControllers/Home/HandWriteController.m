//
//  HandWriteController.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 17/8/2.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "HandWriteController.h"
#import "PlacherTextView.h"
#import "AESEncrypt.h"
@interface HandWriteController ()
{
    PlacherTextView *textView;
    
    UILabel * resultLabel;
    
    NSString *requestStr;
    
}

@end

@implementation HandWriteController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self drawView];
}


-(void)drawView
{
    
    textView = [[PlacherTextView alloc]initWithFrame:KFrame(15, 74, KDeviceW - 30, 50)];
    textView.placeholder = @"请输入链接";
    textView.text = @"http://gc.ditu.aliyun.com/regeocoding?l=39.938133,116.395739&type=001";
    textView.placeholderColor = [UIColor blackColor];
    textView.textColor = [UIColor blackColor];
    textView.font = KFont(14);
    [self.view addSubview:textView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = KFrame(15, textView.maxY +40, KDeviceW - 30, 44);
    [button setTitle:@"开始请求" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(startLoad) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    resultLabel = [[UILabel alloc]initWithFrame:KFrame(15, button.maxY +40, KDeviceW-30, 150)];
    resultLabel.font = KFont(14);
    // _resultLabel.textAlignment = NSTextAlignmentCenter;
    resultLabel.numberOfLines = 0;
    [self.view addSubview:resultLabel];

    
    
}


#pragma mark - 开始下载
-(void)startLoad
{
    if(textView.text.length == 0)
    {
        [MBProgressHUD showError:@"请输入链接" toView:self.view];
        return;
    }
    
    [MBProgressHUD showMessag:@"正在请求任务数据" toView:self.view];
    KWeakSelf
    [RequestManager requestWithURLString:textView.text parameters:nil type:HttpRequestTypeGet success:^(id responseObject) {
        [MBProgressHUD showSuccess:@"请求任务数据成功" toView:self.view];
       
        requestStr = [weakSelf convertToJsonData:responseObject];
        
        
        [weakSelf upLoadRequest];
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请求任务数据失败" toView:self.view];
       
    }];
    
}

#pragma mark - 上传文件
-(void)upLoadRequest
{
    resultLabel.text = [NSString stringWithFormat:@"请求数据结果:%@",requestStr];
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameter setObject:[AESEncrypt aesEncryptString:[NSString stringWithFormat:@"%@_%@",[self getDateStrWithDate:[NSDate date]],[UIDevice currentDevice].identifierForVendor.UUIDString] aesKey:KAESKey] forKey:@"di"];
    [parameter setObject:requestStr forKey:@"f"];
    [parameter setObject:textView.text forKey:@"u"];
    //KWeakSelf(self);
    [MBProgressHUD showMessag:@"正在上传任务数据" toView:self.view];
    [RequestManager postWithURLString:KPostTask parameters:parameter success:^(id responseObject) {
        
        [MBProgressHUD showSuccess:@"上传任务数据成功" toView:self.view];
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"上传任务数据失败" toView:self.view];
        
    }];
}









-(NSString*)getDateStrWithDate:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYYMMDD"];
    
    return [formatter stringFromDate:date];
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
