//
//  SearchController.m
//  EnterpriseInquiry
//
//  Created by WangZhipeng on 17/9/15.
//  Copyright © 2017年 王志朋. All rights reserved.
//

#import "SearchController.h"

@interface SearchController ()<UISearchBarDelegate,UISearchBarDelegate , UISearchDisplayDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UISearchBar *companySearchBar;
    UITableView *historyTableView;
    UITableView *recommendTableView;
    
    NSMutableArray *histotyArray;
    NSMutableArray *hotArray;
    NSMutableArray *recommendArray;
    
    CGFloat keyboardHight;
    
    NSURLSessionDataTask *recommendTask;
}

@property (nonatomic ,strong)NSArray *saveKeys;

@end

@implementation SearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _saveKeys = @[@"homeSearch",
                  @"Ourmainlocaldata",
                  @"Shareholderlocaldata",
                  @"Addresslocaldata",
                  @"CompanyWeblocaldata",
                  @"Crackcreditlocaldata",
                  @"TaxCodeData",
                  @"JobSearchData"];
    
    [self setBackBtn:@"back"];
    [self setTitleView];
    
    [self setHistoryTableView];
    [self setRecommendTableView];
    
    [self getHistoryData];
    
    [self loadHotData];
    
}

#pragma mark 请求热词
-(void)loadHotData{
    
    NSMutableDictionary *paraDic  = [NSMutableDictionary dictionary];
    
    [paraDic setObject:[NSString stringWithFormat:@"%d",(int)self.searchType] forKey:@"type"];
    
    [RequestManager getWithURLString:GetHotKey parameters:paraDic success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        // [MBProgressHUD hideHudToView:self.view animated:YES];
        if ([responseObject[@"result"] integerValue ]==0) {
            [hotArray removeAllObjects];
            hotArray = [NSMutableArray arrayWithCapacity:1];
            NSArray *array = responseObject[@"hotlist"];
            
            for (int i = 0; i<[array count]; i++) {
                
                NSString *hotKey =  [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] valueForKey:@"hotword"]] ;
                if (hotKey == nil || [hotKey isEqualToString:@"null"] || [hotKey isEqualToString:@"<null>"]  ) {
                    
                }else{
                    [hotArray addObject:hotKey];
                    
                }
            }
            [historyTableView reloadData];
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
        //  [MBProgressHUD showError:@"网络异常" toView:self.view];
        
    }];
    
    
}

#pragma  mark - 根据输入词搜索热词
-(void)loadRecommendData:(NSString*)searchKey
{
    CGRect frame = recommendTableView.frame;
    frame.size.height = KDeviceH - KNavigationBarHeight - keyboardHight;
    recommendTableView.frame = frame;
    
    NSMutableDictionary *paraDic  = [NSMutableDictionary dictionary];
    [paraDic setObject:searchKey forKey:@"searchkey"];
    
    NSString *URLStr ;
    if(self.searchType == CrackcreditType)
    {
        URLStr = SXGetHotSearch;
    }
    else
    {
        URLStr = GetHotSearch;
    }
    
    recommendTask = [RequestManager getWithURLString:URLStr parameters:paraDic success:^(id responseObject) {
        
        //NSLog(@"responseObject= %@",responseObject);
        if ([responseObject[@"result"] integerValue] == 0)
        {
            [recommendArray removeAllObjects];
            recommendArray = [NSMutableArray arrayWithCapacity:1];
            [recommendArray addObjectsFromArray:responseObject[@"hotlist"]];
            
            if ([recommendArray count] > 0) {
                historyTableView.hidden = YES;
                recommendTableView.hidden = NO;
            }else{
                historyTableView.hidden = NO;
                recommendTableView.hidden = YES;
            }
            
            [recommendTableView reloadData];
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"error---%@",error);
        [MBProgressHUD hideHudToView:self.view animated:YES];
        
    }];
    
}


#pragma mark - 跳到详情页
-(void)pushToResult:(NSString*)searchStr
{
    
    companySearchBar.text = searchStr;
    SearchResultController *SearchVc = [[SearchResultController alloc]init];
    SearchVc.btnTitile = searchStr;
    SearchVc.searchType = self.searchType;
    SearchVc.delegate = self;
    [self.navigationController pushViewController:SearchVc animated:YES];
}

- (void)historyButtonClick:(NSString *)str
{
    if (str.length) {//防止字典空值崩溃
        [self saveHistoryData:str];
    }
}


#pragma mark - 获取保存的历史数据
-(void)getHistoryData
{
    histotyArray = [NSMutableArray arrayWithCapacity:1];
    NSArray *array;
    
    if (self.searchType<[_saveKeys count]) {
        
        array  = [KUserDefaults objectForKey:_saveKeys[self.searchType]];
        [histotyArray addObjectsFromArray:array];
        [historyTableView reloadData];
    }
    
}

#pragma mark - 保存搜索数据
-(void)saveHistoryData:(NSString *)searchStr
{
    if (searchStr.length>=2) {//搜索词长度小于2的不保存
        for(int i = 0; i<[histotyArray count]; i++)
        {
            if ([searchStr isEqualToString:histotyArray[i]]) {
                
                [histotyArray removeObjectAtIndex:i];
            }
        }
        
        [histotyArray insertObject:searchStr atIndex:0];
        
        if(histotyArray.count >10)
        {
            [histotyArray removeLastObject];
        }
        
        NSString *saveKey ;
        if (self.searchType<[_saveKeys count]) {
            saveKey = _saveKeys[self.searchType];
            [KUserDefaults setObject:histotyArray forKey:saveKey];
        }
        [historyTableView reloadData];
    }
    
    [self pushToResult:searchStr];
}

#pragma mark - 清除历史记录
-(void)clearHistory
{
    NSString *saveKey ;
    
    if (self.searchType<[_saveKeys count]) {
        saveKey = _saveKeys[self.searchType];
        [histotyArray removeAllObjects];
        [KUserDefaults setObject:@[] forKey:saveKey];
        [historyTableView reloadData];
    }
}

#pragma mark - searchBar 代理
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    
    
    [searchBar resignFirstResponder];
    NSString *str = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(searchBar.text.length <2 || str.length < 2)
    {
        [MBProgressHUD showError:@"请输入至少2个关键字" toView:self.view];
        return;
    }
    
    [self saveHistoryData:str];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    
    // 去除两端空格和回车
    NSString *searchtext = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    
    
    if (searchtext.length > 0 && searchtext !=nil ) {
        
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadRecommendData:) object:searchtext];
        [self performSelector:@selector(loadRecommendData:) withObject:searchtext afterDelay:0.5];
        
    }else{
        
        historyTableView.hidden = NO;
        recommendTableView.hidden =YES;
    }
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [companySearchBar resignFirstResponder];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == historyTableView)
    {
        [companySearchBar resignFirstResponder];
    }
    
}
-(void)searchBackWithClear:(BOOL)isClear
{
    if(isClear)
    {
        historyTableView.hidden = NO;
        recommendTableView.hidden  = YES;
        companySearchBar.text = @"";
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == recommendTableView)
    {
        NSDictionary *dic = [recommendArray objectAtIndex:indexPath.row];
        [self saveHistoryData:[dic objectForKey:@"word"]];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == historyTableView)
    {
        static NSString  *identification = @"cell1";
        SearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identification];
        
        if (!cell) {
            cell  = [[SearchHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identification];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        
        if(indexPath.section == 0){
            [cell setDataArray:histotyArray cellType:SearchHistoryType];
        }else{
            [cell setDataArray:hotArray cellType:SearchHotType];
        }
        
        return cell;
    }
    else
    {
        static NSString  *identification = @"cell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identification];
        
        if (!cell) {
            cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identification];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDictionary *dic = [recommendArray objectAtIndex:indexPath.row];
        
        NSMutableAttributedString *str1 = [Tools titleNameWithTitle:[dic objectForKey:@"hotword"] otherColor:[UIColor blackColor]];
        cell.textLabel.attributedText  = str1;
        
        return cell;
        
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == historyTableView)
    {
        return 2;
    }
    else
    {
        return  1;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == historyTableView)
    {
        return 1;
    }
    else
    {
        return  recommendArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == historyTableView)
    {
        if (indexPath.section == 1)
        {
            if(hotArray.count > 0)
            {
                SearchHistoryCell *cell = (SearchHistoryCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
                
                
                return cell.height;
            }
            else
            {
                return 0.00001;
            }
            
        }
        else
        {
            if (histotyArray.count >0)
            {
                SearchHistoryCell *cell = (SearchHistoryCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
                
                return cell.height;
            }
            else
            {
                
                return 0.00001;
            }
            
        }
    }
    else
    {
        return 45;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == historyTableView)
    {
        if (section == 1)
        {
            if(hotArray.count == 0)
            {
                return 0.00001;
            }
            else
            {
                return 34;
            }
            
        }
        else
        {
            if (histotyArray.count >0)
            {
                return 34;
            }
            else{
                
                return 0.00001;
            }
            
        }
        
    }
    else
    {
        return 0.00001;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == recommendTableView)
    {
        return nil;
    }
    else{
        
        if(section == 0)
        {
            if(histotyArray.count > 0)
            {
                
                return [self createSectionViewWithIndex:0];
            }
            else
            {
                return nil;
            }
            
        }
        else
        {
            if(hotArray.count > 0)
            {
                return [self createSectionViewWithIndex:1];;
            }
            else
            {
                return nil;
            }
        }
        
        
    }
    
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

-(UIView *)createSectionViewWithIndex:(NSInteger)index{
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KDeviceW, 34)];
    NSArray *arr = @[@"历史搜索",@"热门搜索"];//标题数组
    //    NSArray *imgArray = @[@"History",@"Hot"];//颜色数组
    sectionView.backgroundColor = [UIColor whiteColor];
    // sectionView.backgroundColor = [UIColor redColor];
    
    //    UIView *kongView = [[UIView alloc]initWithFrame:KFrame(0, 0, KDeviceW, 10)];
    //    kongView.backgroundColor = KHexRGB(0xf0f4f5);
    //    [sectionView addSubview:kongView];
    //
    //    UIView *lineView = [[UIView alloc]initWithFrame:KFrame(0, 0, KDeviceW, 0.5)];
    //    lineView.backgroundColor = KHexRGB(0xd8d9da);
    //   // [sectionView addSubview:lineView];
    //
    //    UIView *lineView2 = [[UIView alloc]initWithFrame:KFrame(0, kongView.maxY - 0.5, KDeviceW, 0.5)];
    //    lineView2.backgroundColor = KHexRGB(0xd8d9da);
    //    [sectionView addSubview:lineView2];
    
    
    //    UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, kongView.maxY+10, 29/2, 29/2)];
    //    leftImg.image = [UIImage imageNamed:imgArray[index]];
    //    [sectionView addSubview:leftImg];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 34)];
    titleLab.font = [UIFont fontWithName:FontName size:14];
    titleLab.textColor = KHexRGB(0x333333);
    titleLab.text = arr[index];
    
    [sectionView addSubview:titleLab];
    if (index  == 0) {
        UIButton *clearHisBtn = [[UIButton alloc]initWithFrame:CGRectMake(KDeviceW -50 -10, 0, 50, 34)];
        [clearHisBtn setTitle:@"清除" forState:UIControlStateNormal ];
        clearHisBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [clearHisBtn setTitleColor:KHexRGB(0x666666) forState:UIControlStateNormal];
        [clearHisBtn addTarget:self action:@selector(clearHistory) forControlEvents:UIControlEventTouchUpInside];
        clearHisBtn.titleLabel.font = KFont(14);
        [sectionView addSubview:clearHisBtn];
    }
    
    
    return sectionView;
}




-(void)setHistoryTableView
{
    historyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KNavigationBarHeight, KDeviceW, KDeviceH-KNavigationBarHeight) style:UITableViewStyleGrouped];
    historyTableView.delegate = self;
    historyTableView.dataSource = self;
    historyTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    historyTableView.tableFooterView = [[UIView alloc]init];
    historyTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:historyTableView];
}


-(void)setRecommendTableView
{
    recommendTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KNavigationBarHeight, KDeviceW, KDeviceH-KNavigationBarHeight) style:UITableViewStyleGrouped];
    recommendTableView.delegate = self;
    recommendTableView.dataSource = self;
    recommendTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    recommendTableView.tableFooterView = [[UIView alloc]init];
    recommendTableView.backgroundColor = [UIColor colorWithRed:0.94 green:0.96 blue:0.96 alpha:1.00];
    [self.view addSubview:recommendTableView];
    
    recommendTableView.hidden = YES;
    
}




-(void)setTitleView
{
    UIView*searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KDeviceW - 20, 44)];
    searchView.backgroundColor = [UIColor clearColor];
    
    companySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, (44-28)/2, KDeviceW - 85,  28)];
    [[companySearchBar.subviews[0] subviews][0] removeFromSuperview];
    
    
    switch (self.searchType ) {
        case 0:
            companySearchBar.placeholder = KSearchPlaceholder;
            break;
        case 1:
            companySearchBar.placeholder = @"请输入主营产品服务";
            break;
        case 2:
            companySearchBar.placeholder = @"请输入股东法人姓名";
            break;
        case 3:
            companySearchBar.placeholder = @"请输入企业地址或电话";
            break;
        case 4:
            companySearchBar.placeholder = @"请输入企业网址";
            break;
        case 5:
            companySearchBar.placeholder = @"请输入涉诉人名、证件号或企业名称";
            break;
        case 6:
            companySearchBar.placeholder = @"请输入企业名称或统一信用代码";
            break;
        case 7:
            companySearchBar.placeholder = @"请输入企业名称或职位";
            break;
        default:
            break;
    }
    UITextField * searchField = [companySearchBar valueForKey:@"_searchField"];
    searchField.font = KFont(14);
    [searchField setValue:KFont(14) forKeyPath:@"_placeholderLabel.font"];
    
    companySearchBar.backgroundImage = nil;
    companySearchBar.backgroundColor = [UIColor clearColor];
    companySearchBar.delegate = self;
    companySearchBar.layer.cornerRadius = 14.f;
    companySearchBar.layer.masksToBounds = YES;
    companySearchBar.layer.borderColor = KHexRGB(0xc8c8c8).CGColor;
    companySearchBar.layer.borderWidth = 1.f;
    [companySearchBar setImage:[UIImage imageNamed:@"home_search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
   
    [searchView addSubview:companySearchBar];
    
    self.navigationItem.titleView = searchView;
    //[companySearchBar becomeFirstResponder];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [companySearchBar becomeFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar fs_setBackgroundColor:KHomeNavigationBarBackGroundColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [companySearchBar resignFirstResponder];
    
    //self.navigationController.navigationBar.translucent=YES;
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    keyboardHight = keyboardSize.height;
    recommendTableView.frame = CGRectMake(0, KNavigationBarHeight, KDeviceW, KDeviceH-KNavigationBarHeight-keyboardHight);
}

- (void)keyboardWillHide:(NSNotification *)notification{
    recommendTableView.frame = CGRectMake(0, KNavigationBarHeight, KDeviceW, KDeviceH-KNavigationBarHeight);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

