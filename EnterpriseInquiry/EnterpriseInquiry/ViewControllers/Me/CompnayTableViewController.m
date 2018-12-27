//
//  CompnayTableViewController.m
//  EnterpriseInquiry
//
//  Created by Ching on 15/11/20.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import "CompnayTableViewController.h"

#define Back_COLOR [UIColor colorWithRed:235.0/255.0 green:236/255.0 blue:238/255.0 alpha:1.0];

#define SIZE_SCALE  ([UIScreen mainScreen].bounds.size.width / 320.0)

@interface CompnayTableViewController ()

@end
@implementation CompnayTableViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.modelArr = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view, typically from a nib.
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pic_background"]];
    
    //    [self.tableView registerNib:[UINib nibWithNibName:@"TBCell" bundle:nil]forCellReuseIdentifier:@"TBCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[BaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    cell.ArrowImageView.hidden = YES;
    
    
    
    if ([self.modelType isEqualToString:@"posit"]) {
//        Position_Message *mode = [self.modelArr objectAtIndex:indexPath.row];
//        if ([mode.haschild isEqualToString:@"1"]) {
//            ArrowView.hidden = NO;
//        }else{
//            ArrowView.hidden = YES;
//        }
//        cell.textLabel.text = mode.name;
    }else{
        NSDictionary *model= [self.modelArr objectAtIndex:indexPath.row];
        NSString *string = model[@"companyname"];
        NSMutableAttributedString *str = [Tools titleNameWithTitle:string otherColor:[UIColor blackColor]];
        cell.textLabel.attributedText = str;
        
    }
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = KHexRGB(0xd9d9d9);
    lineView.frame = CGRectMake(10*SIZE_SCALE, 40, (KDeviceW - 20*SIZE_SCALE), 0.5);
    [cell addSubview:lineView];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.modelType isEqualToString:@"posit"]) {
        
//        if(self.delegate && [self.delegate respondsToSelector:@selector(changPosition:)]){
//            
//            Position_Message *mode = [self.modelArr objectAtIndex:indexPath.row];
//            [self.delegate changPosition:mode];
//        }
    }else{
        if(self.delegate && [self.delegate respondsToSelector:@selector(changComSelect:andCompanyName:)])
        {
            NSDictionary *commodel = [self.modelArr objectAtIndex:indexPath.row];
            [self.delegate changComSelect:commodel andCompanyName:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    
}

- (void)giveDelegate:(id<CompnayTableViewControllerDelegate>)delegate{
    self.delegate = delegate;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(TextFieldresignFirstResponder)]) {
        [self.delegate TextFieldresignFirstResponder];
    }
 }
- (NSString *)CheckTheCompanyName:(NSString*)compName{

    return compName;
}

#pragma mark - 设置分割线从头开始
-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

@end
