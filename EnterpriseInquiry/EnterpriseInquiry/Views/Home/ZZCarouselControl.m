//
//  ZZCarouselControl.m
//  ZZCarousel
//
//  Created by Yuan on 16/2/15.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import "ZZCarouselControl.h"

@interface ZZCarouselControl()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *coreView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation ZZCarouselControl

#pragma mark --- 懒加载数据数组
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void) makeCoreUI:(CGRect)frame
{
    self.coreView = [[UIScrollView alloc]initWithFrame:CGRectZero];
    self.coreView.showsHorizontalScrollIndicator = NO;
    self.coreView.showsVerticalScrollIndicator = NO;
    self.coreView.delegate = self;
    self.coreView.scrollEnabled = NO;//禁止用户滑动
    self.coreView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.coreView];
}

- (void)layoutSubviews{
    self.coreView.frame = self.frame;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self makeCoreUI:frame];
//        [self makePageUI:frame];
        
    }
    return self;
}

-(void)reloadData
{
    NSArray *data = nil;
    if ([self.dataSource respondsToSelector:@selector(zzcarousel:)]) {
        data = [self.dataSource zzcarousel:self];
    }

    if (data.count == 0 || data == nil) {
        return;
    }
    self.dataArray = [[NSMutableArray alloc] init];
    id firstImage = data.firstObject;
    id lastImage = data.lastObject;
    [self.dataArray addObject:lastImage];
    [self.dataArray addObjectsFromArray:data];
    [self.dataArray addObject:firstImage];

    [self reloadCoreUI:self.dataArray];
    if (data.count > 1) {//如果超过一个的情况才开启定时器
        //添加定时器
        [self createTimer];
    }
}

-(void) reloadCoreUI:(NSMutableArray *)dataArray
{
    if (dataArray.count != 0) {
        for (int i = 0; i < dataArray.count; i++) {
            CGFloat imageW = self.frame.size.width;
            CGFloat imageH = self.frame.size.height;
            CGFloat imageY = 0;
            CGFloat imageX = 0;
            if (_direction == 0) {
                imageY = i * self.frame.size.height;
            }else{
                imageX = i * self.frame.size.width;
            }
            
            CGRect frame = CGRectMake(imageX, imageY, imageW, imageH);
            
            UIView *realView = [self.dataSource zzcarousel:self carouselFrame:frame data:dataArray viewForItemAtIndex:i];
            realView.userInteractionEnabled = YES;
            realView.tag = i + 100;
            [self.coreView addSubview:realView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tapped:)];
            [realView addGestureRecognizer:tap];
        }
        
        //设置轮播器的滚动范围
        
        CGSize contentsize;
        if (_direction == 0) {
            contentsize = CGSizeMake(0,dataArray.count * self.frame.size.height);
        }else{
            contentsize = CGSizeMake(dataArray.count * self.frame.size.width,0);
        }
        self.coreView.contentSize = contentsize;
        self.coreView.contentOffset = CGPointMake(0,0);
        
        //打开分页功能
        self.coreView.pagingEnabled = YES;
        //设置分页的页数
//        self.pageControl.numberOfPages = dataArray.count - 2;
    }
    
}

/*
 *  创建定时器
 */

- (void)createTimer
{
    [_timer invalidate];
    _timer = nil;
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:_carouseScrollTimeInterval target:self selector:@selector(autoCarouselScroll) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];

    }
}

/*
 * 执行定时器方法
 */

- (void)autoCarouselScroll
{
    CGPoint offset;
    if (_direction == 0) {
        CGFloat offsetY;
        NSInteger result = (int)self.coreView.contentOffset.y % (int)self.bounds.size.height;
        NSInteger positionNum = (int)self.coreView.contentOffset.y / (int)self.bounds.size.height;
        if (result != 0) {
            offsetY = self.bounds.size.height * positionNum + self.bounds.size.height;
        }else
        {
            offsetY = self.coreView.contentOffset.y + self.bounds.size.height;
        }
         offset = CGPointMake(0, offsetY);
    }else{
        CGFloat offsetX;
        NSInteger result = (int)self.coreView.contentOffset.x % (int)self.bounds.size.width;
        NSInteger positionNum = (int)self.coreView.contentOffset.x / (int)self.bounds.size.width;
        if (result != 0) {
            offsetX = self.bounds.size.width * positionNum + self.bounds.size.width;
        }else
        {
            offsetX = self.coreView.contentOffset.x + self.bounds.size.width;
        }
        offset = CGPointMake(offsetX,0);
    }
   
    [self.coreView setContentOffset:offset animated:YES];
    
}

-(void)Tapped:(UIGestureRecognizer *) gesture
{
    
    NSInteger index = gesture.view.tag-100        ;
    if (index < 0) {
        index = 0;
    }
    
    if ([self.delegate respondsToSelector:@selector(zzcarouselView:data:didSelectItemAtIndex:)]) {
        [self.delegate zzcarouselView:self data:self.dataArray didSelectItemAtIndex:index];
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (_direction == 0) {
        if (self.coreView.contentOffset.y <= 0)
        {
            self.coreView.contentOffset = CGPointMake( 0,self.bounds.size.height * (self.dataArray.count - 2));
        }else if (self.coreView.contentOffset.y >= self.bounds.size.height * (self.dataArray.count - 1))
        {
            self.coreView.contentOffset = CGPointMake(0,self.bounds.size.height);
        }
    }else{
        if (self.coreView.contentOffset.x <= 0)
        {
            self.coreView.contentOffset = CGPointMake( self.bounds.size.width * (self.dataArray.count - 2),0);
        }else if (self.coreView.contentOffset.x >= self.bounds.size.width * (self.dataArray.count - 1))
        {
            self.coreView.contentOffset = CGPointMake(self.bounds.size.width,0);
        }
    }
    
   
}




- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}



@end
