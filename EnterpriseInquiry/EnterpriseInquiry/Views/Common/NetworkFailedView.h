//
//  NetworkFailedView.h
//  NoDataTest
//
//  Created by JUSFOUN on 2018/3/12.
//  Copyright © 2018年 JUSFOUN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NetworkFailedViewDelegate<NSObject>
- (void)networkReload;
@end

@interface NetworkFailedView : UIView
@property (nonatomic ,weak) id <NetworkFailedViewDelegate>delegate;
@end
