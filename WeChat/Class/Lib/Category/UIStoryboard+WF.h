//
//  UIStoryboard+WF.h
//  WeiXin
//
//  Created by huhang on 14-11-20.
//  Copyright (c) 2014年 huhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStoryboard (WF)

/**
 * 1.显示Storybaord的第一个控制器到窗口
 */
+(void)showInitialVCWithName:(NSString *)name;
+(id)initialVCWithName:(NSString *)name;
@end
