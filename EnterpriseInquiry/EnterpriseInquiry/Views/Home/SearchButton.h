//
//  SearchButton.h
//  EnterpriseInquiry
//
//  Created by clj on 16/8/14.
//  Copyright © 2016年 王志朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchButton : UIButton


@property (nonatomic,strong) UIImageView *searchImageView;
@property (nonatomic,strong) UILabel *searchLabel;

- (instancetype)initWithFrame:(CGRect)frame andPlaceText:(NSString *)placeText;
@end
