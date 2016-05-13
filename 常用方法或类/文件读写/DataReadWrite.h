//
//  DataReadWrite.h
//  SmallTools
//
//  Created by cxh on 16/5/11.
//  Copyright © 2016年 cxh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataReadWrite : NSObject
/**
 *  用来获取保存本地化的数据
 *
 *  @param key key
 *
 *  @return value
 */
+(id)objectForKey:(NSString*)key;

/**
 *  用来保存本地化的数据
 *
 *  @param value value
 *  @param key   key
 */
+(void)setValue:(id)value Key:(NSString*)key;


@end
