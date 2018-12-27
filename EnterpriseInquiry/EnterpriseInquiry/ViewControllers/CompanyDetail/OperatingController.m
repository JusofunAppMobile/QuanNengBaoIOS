//
//  OperatingController.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 17/9/6.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "OperatingController.h"

@interface OperatingController ()

@property (nonatomic ,strong) NSMutableArray *vcs;

@end

@implementation OperatingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initControllers];
    [self loadViewController:self.itemModel];
}


#pragma mark - 初始化控制器
- (void)initControllers{
    
    for (int i = 0; i < self.itemArray.count; i++) {
        
        NSDictionary *dic = self.itemArray[i];
        ItemModel *model = [ItemModel mj_objectWithKeyValues:dic];
        
        if ([model.type intValue] == 1 || [model.type intValue] == 5) {//工资查询
            
            DetailWebBasicController *vc = [DetailWebBasicController new];
            vc.itemModel = model;
            
            [self.vcs addObject:vc];
        }
        
        if ([model.type intValue] == 7) {//招聘列表
            
            JobController *vc = [JobController new];
            vc.companyId = self.companyId;
            vc.companyName = self.companyName;
            vc.itemModel = model;
            
            
            [self.vcs addObject:vc];
        }
        
        if ([model.type intValue] == 6) {//中标
            
            BidController *vc = [BidController new];
            vc.itemModel = model;
            vc.companyName = self.companyName;
            vc.companyId = self.companyId;
            
            [self.vcs addObject:vc];
        }
        if ([model.type intValue] == 13) {//招标
            
            ZhaoBiaoController *vc = [ZhaoBiaoController new];
            vc.itemModel = model;
            vc.companyName = self.companyName;
            vc.companyId = self.companyId;
            
            [self.vcs addObject:vc];
        }
    }
}


- (void)loadViewController:(ItemModel *)model{
    
    [self hideViewController:self.currentVc];
    
    for (BasicViewController *vc in _vcs) {
        if ([model.menuid isEqualToString:vc.itemModel.menuid]) {
            self.currentVc = vc;
            break;
        }
    }
    
    [self displayViewController:self.currentVc];
}


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
