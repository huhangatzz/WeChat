//
//  WCEditVCardViewController.h
//  WeChat
//
//  Created by huhang on 16/9/25.
//  Copyright (c) 2016年 huhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WCEditVCardViewController;
@protocol WCEditVCardViewControllerDelegate <NSObject>

-(void)editVCardViewController:(WCEditVCardViewController *)editVc didFinishedSave:(id)sender;

@end

@interface WCEditVCardViewController : UITableViewController

/** 上一个控制器(个人信息控制器)传入的cell */
@property(strong,nonatomic)UITableViewCell *cell;

@property(weak,nonatomic)id<WCEditVCardViewControllerDelegate> delegate;

@end
