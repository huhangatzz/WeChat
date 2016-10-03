//
//  Content.h
//  WeChat
//
//  Created by huhang on 16/9/24.
//  Copyright © 2016年 huhang. All rights reserved.
//

#ifndef Content_h
#define Content_h

//自定义日志
#ifdef DEBUG

#define NSLog(...) NSLog(@"%s\n %@",__func__,[NSString stringWithFormat:__VA_ARGS__])
#else   

#endif



#endif /* Content_h */
