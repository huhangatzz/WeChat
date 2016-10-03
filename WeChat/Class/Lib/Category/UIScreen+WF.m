//
//  UIScreen+WF.m
//  WeiXin
//
//  Created by huhang on 14-11-22.
//  Copyright (c) 2014年 huhang. All rights reserved.
//

#import "UIScreen+WF.h"

@implementation UIScreen (WF)

-(CGFloat)screenH{
    return [UIScreen mainScreen].bounds.size.height;
}

-(CGFloat)screenW{
    return [UIScreen mainScreen].bounds.size.width;
}

@end
