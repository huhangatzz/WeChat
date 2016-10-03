//
//  NSString+Extension.h
//  QQ聊天
//
//  Created by huhang on 16/3/9.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)

//返回字符串所占用的尺寸
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

@end
