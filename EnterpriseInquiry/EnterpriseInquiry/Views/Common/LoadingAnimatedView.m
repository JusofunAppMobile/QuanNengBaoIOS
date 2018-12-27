//
//  LoadingAnimatedView.m
//  AnimateDemo
//
//  Created by JUSFOUN on 2018/3/1.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import "LoadingAnimatedView.h"

@interface LoadingAnimatedView()

@property (nonatomic ,strong) UIImageView *imageView;
@property (nonatomic ,strong) NSMutableArray *imageArray1;
@property (nonatomic ,strong) NSMutableArray *imageArray2;

@end

@implementation LoadingAnimatedView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 150)];
        _imageView.center = self.center;
        [self addSubview:_imageView];

        for (int i = 0; i<44; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"img%d",i]];
            [self.imageArray1 addObject:image];
        }
        
        for (int i = 44; i<88; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"img%d",i]];
            [self.imageArray2 addObject:image];
        }
        
    }
    return self;
}

- (void)startAnimation{
    [self performSelector:@selector(animation1) withObject:nil afterDelay:0];
    [self performSelector:@selector(animation2) withObject:nil afterDelay:1.8];
}

- (void)stopAnimation{
    [_imageView stopAnimating];
}


- (void)animation1{
    _imageView.animationImages = self.imageArray1;
    _imageView.animationDuration = 1.8;
    _imageView.animationRepeatCount = 1;
    [_imageView startAnimating];
}

- (void)animation2{
    _imageView.animationImages = self.imageArray2;
    _imageView.animationDuration = 1.8;
    _imageView.animationRepeatCount = 0;
    [_imageView startAnimating];
}

- (NSMutableArray *)imageArray1{
    if (!_imageArray1) {
        _imageArray1 = [NSMutableArray array];
    }
    return _imageArray1;
}

- (NSMutableArray *)imageArray2{
    if (!_imageArray2) {
        _imageArray2 = [NSMutableArray array];
    }
    return _imageArray2;
}


@end
