//
//  ProblemViewController.m
//  EnterpriseInquiry
//
//  Created by ; on 15/11/27.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import "ProblemViewController.h"

@interface ProblemViewController ()

@end

@implementation ProblemViewController
{
    NSString  *_firstUrl;
    NSString  *_nowUrl;
    BOOL      _isFirst;
}

- (void)viewDidLoad {
   [super viewDidLoad];
    
    [self setBackBtn:@"back"];
    [self setNavigationBarTitle:self.titleName ];
    
    self.view.backgroundColor = KHexRGB(0xf2f3f5);
    [self createWebView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, KNavigationBarHeight, KDeviceW, 1);
    lineView.backgroundColor = KHexRGB(0xd9d9d9);
    [self.view addSubview:lineView];
    _isFirst = YES;
     [self loadWithUrl:self.url];
   
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar fs_setBackgroundColor:KHomeNavigationBarBackGroundColor];
}



-(void)createWebView
{
    self.webView.frame = CGRectMake(0, KNavigationBarHeight, KDeviceW, KDeviceH -KNavigationBarHeight);
    self.webView.backgroundColor = [UIColor clearColor];
//    self.webView.delegate = self;

}


-(void)loadWithUrl:(NSString *)strUrl
{
//    NSString  *urlString = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlStr = [strUrl stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSURL*url=[NSURL URLWithString:urlStr];
    NSURLRequest*request;
    if (!url) {
        NSString  *theUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _firstUrl = theUrl;
        NSURL*nowUrl=[NSURL URLWithString:theUrl];
        request=[NSURLRequest requestWithURL:nowUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    }else{
        request=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    }
    
    [self.webView loadRequest:request];
    
}



-(BOOL)isExitString:(NSString *)str withRangeString:(NSString *)rangeStr
{
    if([str rangeOfString:rangeStr].location !=NSNotFound)//_roaldSearchText
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    
//    _nowUrl = [NSString stringWithFormat:@"%@",request.URL.absoluteString];
    NSString *urlStr = request.URL.absoluteString;
    _nowUrl = [urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (_isFirst) {
        _isFirst = NO;
        _firstUrl = _nowUrl;
    }
    if([[_nowUrl substringWithRange:NSMakeRange(0, 14)] isEqualToString:@"companyinfo://"])
    {
        NSString *idStr;
        NSString *nameStr;
        NSString *appendStr = [_nowUrl substringFromIndex:@"companyinfo://".length];
        NSArray *strArray = [appendStr componentsSeparatedByString:@"&"];
        if(strArray.count >0)
        {
            NSString *str1 = [strArray objectAtIndex:0];
            if(str1.length >0)
            {
                NSString *str2 = @"id=";
                idStr = [str1 substringFromIndex:str2.length];
            }
        }
        if(strArray.count >1)
        {
            NSString *str1 = [strArray objectAtIndex:1];
            if(str1.length >0)
            {
                NSString *str2 = @"province=";
                nameStr = [str1 substringFromIndex:str2.length];
            }
        }
        CompanyDetailController *comView = [[CompanyDetailController alloc] init];
        comView.companyId = idStr;
        comView.companyName = nameStr;
        [self.navigationController pushViewController:comView animated:YES];
        return  NO;
    }
    
    
    NSString *titleStr;
    NSString *nowtitle = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if ([self.titleName isEqualToString:@"企业查询"]) {
        titleStr = self.titleName;
    }else{
        if (nowtitle != nil && ![nowtitle  isEqual: @""]) {
            titleStr = nowtitle;
        }else{
            titleStr = self.titleName;
        }
    }
    
    [self setNavigationBarTitle:titleStr ];
    
    return YES;

}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
//    JSContext *str = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

}

-(void)DLPanableWebView:(DLPanableWebView *)webView panPopGesture:(UIPanGestureRecognizer *)pan
{
//    CGPoint point = [pan locationInView:self.view];
//    
//    if(point.x < 100)
//    {
//        [self back];
//    }
}

-(void)back
{
    if ([self.webView canGoBack]) {
        
        [self.webView goBack];        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]){
        if (![self.webView canGoBack]) {
            return YES;
        }else{
            return NO;
        }
    }else if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]&& [otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]){

        return YES;
    }else{
        return  NO;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
