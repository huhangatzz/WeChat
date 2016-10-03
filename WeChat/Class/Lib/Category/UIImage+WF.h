//
//  UIImage+WF.h
//  WeiXin
//
//  Created by huhang on 14-11-19.
//  Copyright (c) 2014年 huhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WF)

/**
 *返回中心拉伸的图片
 */
+(UIImage *)stretchedImageWithName:(NSString *)name;

//防止图片失真
+ (UIImage *)resizableImage:(NSString *)name;

@end
