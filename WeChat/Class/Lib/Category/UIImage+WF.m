//
//  UIImage+WF.m
//  WeiXin
//
//  Created by huhang on 14-11-19.
//  Copyright (c) 2014年 huhang. All rights reserved.
//

#import "UIImage+WF.h"

@implementation UIImage (WF)

+(UIImage *)stretchedImageWithName:(NSString *)name{
    
    UIImage *image = [UIImage imageNamed:name];
    int leftCap = image.size.width * 0.5;
    int topCap = image.size.height * 0.5;
    return [image stretchableImageWithLeftCapWidth:leftCap topCapHeight:topCap];
}

+ (UIImage *)resizableImage:(NSString *)name{
    
    UIImage *image = [UIImage imageNamed:name];
    CGFloat w = image.size.width * 0.5;
    CGFloat h = image.size.height * 0.5;
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w)];
}

@end
