//
//  NSString+Extension.m
//  QQ聊天
//
//  Created by huhang on 16/3/9.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

//计算文本高度
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize{
    
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGSize size = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

@end
