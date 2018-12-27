//
//  RiskContainerController.m
//  EnterpriseInquiry
//
//  Created by JUSFOUN on 2017/9/7.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "RiskContainerController.h"
#import "OweTaxController.h"

@interface RiskContainerController ()<UIGestureRecognizerDelegate>

@property (nonatomic ,strong) NSMutableArray *vcs;

@end

@implementation RiskContainerController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackBtn:@"back"];
    [self initControllers];
    [self loadViewController:self.itemModel];
    
    // Do any additional setup after loading the view.
}

#pragma mark 初始化控制器
- (void)initControllers{
    
    for (int i = 0; i<[self.itemArray count]; i++) {
     
        NSDictionary *dic = [self.itemArray objectAtIndex:i];
        
        ItemModel *model = [ItemModel mj_objectWithKeyValues:dic];
        
        if ([model.type intValue] == 1||[model.type intValue] == 5) {
            
            DetailWebBasicController *vc = [DetailWebBasicController new];
            vc.itemModel = model;
            [self.vcs addObject:vc];
        }
        
         if ([model.type intValue] == 10) {
            
            OweTaxController *vc = [OweTaxController new];
            vc.entName = self.companyName;
            vc.taxCode = @"";

            vc.itemModel = model;

            [self.vcs addObject:vc];
        }
        if ([model.type intValue] == 11) {
            
            PenaltyController *vc = [PenaltyController new];
            vc.companyId = self.companyId;
            vc.companyName = self.companyName;
            
            vc.itemModel = model;
            
            [self.vcs addObject:vc];
        }
        if ([model.type intValue] == 12) {
            
            GuQuanController *vc = [GuQuanController new];
            vc.companyId = self.companyId;
            vc.companyName = self.companyName;
            
            vc.itemModel = model;
            
            [self.vcs addObject:vc];
        }
        
    }
}
#pragma mark 显示控制器
- (void)loadViewController:(ItemModel *)model{
    
    [self hideViewController:self.currentVc];

    for (BasicViewController *vc in _vcs ) {
        if ([model.menuid isEqualToString:vc.itemModel.menuid]) {
            self.currentVc = vc;
            break;
        }
    }
    [self displayViewController:self.currentVc];
    
}

#pragma mark点击切换控制器
-(void)pullItemButtonClick:(ItemButton *)button
{
    ItemModel *model = button.squareModel;
    button.selected = YES;
    self.saveTitleStr = model.menuname;
    self.itemModel = model;
    
    [self setDetailNavigationBarTitle:self.saveTitleStr];
    [self showItemView];
    
    [self loadViewController:model];
}


-(void)detailWebPush:(NSString *)title
{
    self.isWebViewPush = YES;
    // self.titleLabel.text = title;
    // [self.titleLabel sizeToFit];
    [self setDetailNavigationBarTitle:title];
    self.titleImageView.hidden = YES;
    self.errorBtn.hidden = YES;
    self.titleButton.enabled = NO;
}

-(void)detailWebPop
{
    self.isWebViewPush = NO;
    [self setDetailNavigationBarTitle:self.saveTitleStr];
    self.titleImageView.hidden = NO;
    self.errorBtn.hidden = NO;
    self.titleButton.enabled = YES;
}

#pragma mark - lazy load
- (NSMutableArray *)vcs{
    if (!_vcs) {
        _vcs = [NSMutableArray array];
    }
    return _vcs;
}



@end
