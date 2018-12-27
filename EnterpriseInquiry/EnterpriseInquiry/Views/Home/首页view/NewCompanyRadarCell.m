//
//  NewCompanyRadarCell.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2018/1/5.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import "NewCompanyRadarCell.h"
//#import "ZZCarouselControl.h"
#import "RadarCardCell.h"
#import "ZHCollectionView.h"

@interface NewCompanyRadarCell ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,strong) UIView *containerView;
@property (nonatomic ,strong) ZHCollectionView *collectionview;

@end
@implementation NewCompanyRadarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.estimatedItemSize = CGSizeMake(KDeviceW/2.0, 115);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, -15);
        layout.minimumInteritemSpacing = 10;
        
        self.collectionview = ({
            ZHCollectionView *view = [[ZHCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self.contentView);
                make.height.mas_equalTo(145);
            }];
            view.showsHorizontalScrollIndicator = NO;
            view.backgroundColor = [UIColor whiteColor];
            view.delegate = self;
            view.dataSource = self;
            view;
        });
        [_collectionview registerClass:[RadarCardCell class] forCellWithReuseIdentifier:@"RadarCardCell"];
       
    }
    return self;
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _radarArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RadarCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RadarCardCell" forIndexPath:indexPath];
    NSInteger index = indexPath.item%(_radarArray.count);
    cell.data = _radarArray[index];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    if ([_delegate respondsToSelector:@selector(companyRadarClick:)]) {
        NSInteger index = indexPath.item%(_radarArray.count);
        NSDictionary *dic = _radarArray[index];
        [_delegate companyRadarClick:dic];
    }
}


- (void)setRadarArray:(NSArray *)radarArray{
    if(_radarArray != radarArray&&radarArray.count){
        _radarArray = radarArray;
        [self.collectionview reloadData];
    }
}


@end

