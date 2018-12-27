//
//  FilterView.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2018/1/12.
//  Copyright © 2018年 王志朋. All rights reserved.
//

#import "FilterView.h"
#import "FilterSectionHeader.h"
#import "FilterCollectionCell.h"
#import "NearSearchCondition.h"
#import "ChooseDataModel.h"
#import "FilterPlainSeionHeader.h"
#import "UIView+BorderLine.h"


@interface FilterView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CollectionCellDelegate,UIGestureRecognizerDelegate,FilterSectionHeaderDelegate>

@property (nonatomic ,strong) UICollectionView *collectionview;
@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) NSMutableArray *selectedItems;
@property (nonatomic ,strong) UIButton *resetBtn;
@property (nonatomic ,strong) UIButton *confirmBtn;
@property (nonatomic ,assign) BOOL isProviceOpen;//是否展开省列表
@property (nonatomic ,assign) BOOL isCityOpen;//是否展开城市列表
@property (nonatomic ,strong) UIView *footerView;
@property (nonatomic ,assign) BOOL isSXXX;//失信筛选


@end

@implementation FilterView

- (instancetype)initWithFrame:(CGRect)frame isSX:(BOOL)isSX{
    
    if (self = [super initWithFrame:frame]) {
        _isSXXX = isSX;
        _dataArray = [NSMutableArray array];
        
        self.hidden = YES;
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideChooseView)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        [self addSubview:self.collectionview];
        [self requestData];
    }
    return self;
}

#pragma mark - lazy load

- (UICollectionView *)collectionview{
    if (!_collectionview) {
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        
        _collectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(KDeviceW, 0, KChooseWidth, KDeviceH-38) collectionViewLayout:layout];
        _collectionview.delegate = self;
        _collectionview.dataSource = self;
        _collectionview.backgroundColor = [UIColor whiteColor];
        _collectionview.contentInset = UIEdgeInsetsMake(KStatusBarHeight+10, 0, 0, 0);
        
        [_collectionview registerClass:[FilterCollectionCell class] forCellWithReuseIdentifier:@"FilterCollectionCell"];
        [_collectionview registerClass:[FilterSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FilterSectionHeader"];
        [_collectionview registerClass:[FilterPlainSeionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FilterPlainSeionHeader"];
        
        
        self.footerView = [[UIView alloc]initWithFrame:KFrame(KDeviceW- KChooseWidth, self.height, KChooseWidth, 38)];
        _footerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_footerView];
        
        _resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _resetBtn.frame = KFrame(0, 0, KChooseWidth/2, 38);
        _resetBtn.backgroundColor = [UIColor whiteColor];
        _resetBtn.titleLabel.font = KFont(16);
        [_resetBtn setBorderWithTop:YES left:NO bottom:NO right:NO borderColor:KHexRGB(0xc8c8c8) borderWidth:.5];
        [_resetBtn setTitle:@"重置" forState:UIControlStateNormal];
        [_resetBtn setTitleColor:KHexRGB(0x666666) forState:UIControlStateNormal];
        [_resetBtn addTarget:self action:@selector(resetAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:_resetBtn];
        
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmBtn.frame = KFrame(_resetBtn.maxX, 0 , KChooseWidth/2, 38);
        _confirmBtn.titleLabel.font = KFont(16);
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setBackgroundImage:KImageName(@"渐变导航栏") forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:_confirmBtn];
        
    }
    return _collectionview;
}

- (void)addTableHeaderView{
    
    _collectionview.contentInset = UIEdgeInsetsMake(KStatusBarHeight+10+14+15, 0, 0, 0);//KStatusBarHeight+10
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, -(14+15), KChooseWidth-15*2, 14)];
    label.text = @"所在城市";
    label.font = KFont(14);
    label.textColor = KHexRGB(0x333333);
    [_collectionview addSubview:label];
}

#pragma mark - cell点击
- (void)selectCollectionViewCell:(FilterCellModel *)model{
    [_selectedItems enumerateObjectsUsingBlock:^(FilterCellModel *savedModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([savedModel.type intValue] == [model.type intValue]) {
            [_selectedItems removeObject:savedModel];
        }else if ([savedModel.type intValue]<=2&&[model.type intValue]<=2){//省市不能同时存在
            [_selectedItems removeObject:savedModel];
        }
    }];
    [self.selectedItems addObject:model];
    [_collectionview reloadData];
    
    [self UMengTJWithType:model.type];//友盟统计
}

- (void)deselectCollectionViewCell:(FilterCellModel *)model{
    
    [_selectedItems enumerateObjectsUsingBlock:^(FilterCellModel *savedModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if (savedModel.name == model.name) {
            [_selectedItems removeObject:savedModel];
        }
    }];
    [_collectionview reloadData];
}

//友盟统计
- (void)UMengTJWithType:(NSString *)type{
    
    if([type isEqual: @"1"])
    {
        [MobClick event:@"Search48"];//城市筛选点击数
        [[BaiduMobStat defaultStat] logEvent:@"Search48" eventLabel:@"搜索结果页－城市筛选点击数"];
    }
    else if ([type isEqual: @"2"])
    {
        [MobClick event:@"Search49"];//省份筛选点击数
        [[BaiduMobStat defaultStat] logEvent:@"Search49" eventLabel:@"搜索结果页－省份筛选点击数"];
        
    }else if ([type isEqual: @"3"])
    {
        [MobClick event:@"Search50"];//搜索结果页－行业筛选点击数,
        [[BaiduMobStat defaultStat] logEvent:@"Search50" eventLabel:@"搜索结果页－行业筛选点击数"];
    }
    else if ([type isEqual: @"4"])
    {
        [MobClick event:@"Search52"];//搜索结果页－注资筛选点击数
        [[BaiduMobStat defaultStat] logEvent:@"Search52" eventLabel:@"搜索结果页－注资筛选点击数"];
    }
    else if ([type isEqual: @"5"])
    {
        [MobClick event:@"Search53"];//年限筛选点击数
        [[BaiduMobStat defaultStat] logEvent:@"Search53" eventLabel:@"搜索结果页－年限筛选点击数"];
    }
    
}

#pragma mark - delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [_dataArray count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    ChooseDataModel *model = _dataArray[section];
    
    if (!_isSXXX) {
        if ([model.type intValue] == 1&&!_isCityOpen) {
            return 0;
        }
        if ([model.type intValue] == 2&&!_isProviceOpen) {
            return 0;
        }
    }
   
    return model.filterItemList.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ChooseDataModel *model = _dataArray[indexPath.section];
    FilterCellModel *cellModel = model.filterItemList[indexPath.row];
    cellModel.key = model.key;
    cellModel.type = model.type;
    cellModel.selected = NO;//当数组为0时,不会走遍历，此处需要设置
    [_selectedItems enumerateObjectsUsingBlock:^(FilterCellModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:cellModel.name]) {
            cellModel.selected = YES;
            *stop = YES;
        }
    }];
    
    FilterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FilterCollectionCell" forIndexPath:indexPath];
    cell.model = cellModel;
    cell.delegate = self;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    ChooseDataModel *model = _dataArray[indexPath.section];
    
    if (([model.type intValue] == 1||[model.type intValue] == 2)&&!_isSXXX) {
        BOOL select = [model.type intValue] == 1?_isCityOpen:_isProviceOpen;//按钮选中状态，需要设置
        FilterSectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FilterSectionHeader" forIndexPath:indexPath];
        header.model = _dataArray[indexPath.section];
        header.delegate = self;
        header.openBtn.selected = select;
        return header;
    }else{
        FilterPlainSeionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FilterPlainSeionHeader" forIndexPath:indexPath];
        header.model = _dataArray[indexPath.section];
        return header;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section <=1) {
        return UIEdgeInsetsMake(10, 15, 10, 15);
    }
    return UIEdgeInsetsMake(20, 15, 20, 15);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(.1, .1);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(KChooseWidth, 34);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseDataModel *sectionMode = _dataArray[indexPath.section];
//    FilterCellModel *model = sectionMode.filterItemList[indexPath.row];
    //    CGFloat height = MAX([self getTextHeight:model.name], 30);
    if ([sectionMode.type isEqualToString:@"4"]) {
        return CGSizeMake((KChooseWidth-15*2-10*1)/2, 30);
    }
    return CGSizeMake((KChooseWidth-15*2-10*2)/3, 30);
}

- (CGFloat)getTextHeight:(NSString *)text{
    CGRect rect = [text boundingRectWithSize:CGSizeMake((KChooseWidth-15*2-10*2)/3, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    return rect.size.height;
}

#pragma mark - 重置 确定
- (void)resetAction{
    [_selectedItems removeAllObjects];
    [_collectionview reloadData];
}

- (void)confirmAction{
    if ([self.delegate respondsToSelector:@selector(didSelectFilterView:)]) {
        [self.delegate didSelectFilterView:_selectedItems];
    }
    [self hideChooseView];
}

#pragma mark - 打开关闭列表

- (void)filterHeaderOpen:(BOOL)open type:(NSString *)type{
    if ([type intValue] == 1) {
        _isCityOpen = open;
    }else{
        _isProviceOpen = open;
    }
    [_collectionview reloadData];
    
}
- (void)openOrCloseFilterSetion:(NSString *)type{
    if ([type intValue] == 1) {
        _isCityOpen = !_isCityOpen;
    }else{
        _isProviceOpen = !_isProviceOpen;
    }
    [_collectionview reloadData];
}

#pragma mark - 网络请求
- (void)requestData{
    
    NSString *urlStr;
    NSArray *array ;
    HttpRequestType requestType;
    if(_isSXXX)
    {
        array = [NearSearchCondition sharedInstance].sxChooseArray;
        urlStr = PriviceListDeal;
        requestType = HttpRequestTypeGet;
    }
    else
    {
        array = [NearSearchCondition sharedInstance].chooseArray;
        urlStr = GetKeyWordSummary;
        requestType = HttpRequestTypePost;
    }
    
    
    if(array.count >0)
    {
        _dataArray = [array mutableCopy];
        [self addTableHeaderView];//yin wei n
        [self.collectionview reloadData];
        //        [self drawProvinceView];
    }
    else
    {
        
        KWeakSelf
        [RequestManager requestWithURLString:urlStr parameters:nil type:requestType success:^(id responseObject) {
            [MBProgressHUD hideHudToView:self animated:YES];
            if([[responseObject objectForKey:@"result"] intValue] == 0)
            {
                NSArray *tmpArray = [responseObject objectForKey:@"filterList"];
                NSArray *array = [ChooseDataModel mj_objectArrayWithKeyValuesArray:tmpArray];
                
                weakSelf.dataArray = [NSMutableArray arrayWithArray:array];
                
                NSDictionary *saveLocDic = [KUserDefaults objectForKey:KUserLocation];
                if(weakSelf.dataArray.count >0&&saveLocDic&&!_isSXXX)
                {
                    ChooseDataModel *changeModel;
                    
                    int num = 0;
                    
                    for(int i = 0;i<weakSelf.dataArray.count;i++)
                    {
                        ChooseDataModel *tmpModel = [weakSelf.dataArray objectAtIndex:i];
                        NSString *type = tmpModel.type;
                        if([type isEqualToString:@"1"])
                        {
                            num = i;
                            changeModel = tmpModel;
                            break;
                        }
                    }
                    
                    NSArray *cityArray = changeModel.filterItemList;
                    NSMutableArray *muArray = [NSMutableArray arrayWithArray:cityArray];
                    
                    FilterCellModel *model = [FilterCellModel new];
                    model.value = KDingWei;
                    model.name = [saveLocDic objectForKey:@"city"];
                    [muArray insertObject:model atIndex:0];
                    
                    ChooseDataModel *saveModel = [[ChooseDataModel alloc]init];
                    saveModel.name = changeModel.name;
                    saveModel.type = changeModel.type;
                    saveModel.filterItemList = muArray;
                    saveModel.key = changeModel.key;
                    [weakSelf.dataArray replaceObjectAtIndex:num withObject:saveModel];
                    
                    [weakSelf addTableHeaderView];//添加表头
                }
                if(_isSXXX)
                {
                    [NearSearchCondition sharedInstance].sxChooseArray = weakSelf.dataArray;
                }
                else
                {
                    [NearSearchCondition sharedInstance].chooseArray = weakSelf.dataArray;
                }
                [weakSelf.collectionview reloadData];
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
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
        CGRect frame = _collectionview.frame;
        frame.origin.x = KDeviceW- KChooseWidth;
        _collectionview.frame = frame;

        CGRect frame2 = _footerView.frame;
        frame2.origin.y = self.height - frame2.size.height;
        _footerView.frame = frame2;
    }];
}

-(void)hideChooseView{
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _collectionview.frame;
        frame.origin.x = KDeviceW ;
        _collectionview.frame = frame;

        CGRect frame2 = _footerView.frame;
        frame2.origin.y = self.frame.size.height ;
        _footerView.frame = frame2;

        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

//取消collectionview对self点击事件的响应
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:_collectionview]) {
        return NO;
    }
    return YES;
}

#pragma mark - lazy load

- (NSMutableArray *)selectedItems{
    if (!_selectedItems) {
        _selectedItems = [NSMutableArray array];
    }
    return _selectedItems;
}

@end

