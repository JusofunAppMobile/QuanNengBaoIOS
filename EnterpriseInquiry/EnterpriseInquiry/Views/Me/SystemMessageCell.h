//
//  SystemMessageCell.h
//  EnterpriseInquiry
//
//  Created by Ching on 15/11/26.
//  Copyright © 2015年 jusfoun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserMessageModle;

@interface SystemMessageCell : UITableViewCell

@property (nonatomic,assign)CGFloat cell_height;



-(void)cellDataWith:(NSDictionary*)dict;

@end
