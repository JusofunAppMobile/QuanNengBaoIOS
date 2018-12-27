//
//  ZHCollectionView.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2018/2/27.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import "ZHCollectionView.h"
#import "ZHCollectionViewInterceptor.h"

@interface ZHCollectionView ()

@property (nonatomic, strong) ZHCollectionViewInterceptor * dataSourceInterceptor;
@property (nonatomic, assign) NSInteger actualRows;
@property (nonatomic ,assign)  CGPoint lastPoint;

@end

@implementation ZHCollectionView

#pragma mark - LayoutSubviews Override
- (void)layoutSubviews {
    [self resetContentOffsetIfNeeded];
    [super layoutSubviews];
}

- (void)resetContentOffsetIfNeeded {
    CGPoint contentOffset  = self.contentOffset;
    if (CGPointEqualToPoint(_lastPoint, contentOffset)) {//防止此方法被无限调用
        return;
    }
    _lastPoint = contentOffset;
    //scroll over top
    if (contentOffset.x < 0.0) {
        contentOffset.x = self.contentSize.width / 3.0;
    }
    //scroll over bottom
    else if (contentOffset.x >= (self.contentSize.width - self.bounds.size.width)) {
        contentOffset.x = self.contentSize.width / 3.0 - self.bounds.size.width;
    }
    [self setContentOffset: contentOffset];
}

#pragma mark - DataSource Delegate Setter/Getter Override
- (void)setDataSource:(id<UICollectionViewDataSource>)dataSource {
    self.dataSourceInterceptor.receiver = dataSource;
    [super setDataSource:(id<UICollectionViewDataSource>)self.dataSourceInterceptor];
}

- (ZHCollectionViewInterceptor *)dataSourceInterceptor {
    if (!_dataSourceInterceptor) {
        _dataSourceInterceptor = [[ZHCollectionViewInterceptor alloc]init];
        _dataSourceInterceptor.middleMan = self;
    }
    return _dataSourceInterceptor;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    self.actualRows = [self.dataSourceInterceptor.receiver collectionView:collectionView numberOfItemsInSection:section];
    if (self.actualRows<3) {//防止个数少 占不满屏还循环
        return self.actualRows;
    }
    return self.actualRows*3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath * actualIndexPath = [NSIndexPath indexPathForRow:indexPath.row % self.actualRows inSection:indexPath.section];
    return [self.dataSourceInterceptor.receiver collectionView:collectionView cellForItemAtIndexPath:actualIndexPath];
}

@end
