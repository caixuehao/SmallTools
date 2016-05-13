//
//  DataReadWrite.m
//  SmallTools
//
//  Created by cxh on 16/5/11.
//  Copyright © 2016年 cxh. All rights reserved.
//

#import "smallToolsInfo.h"
#import "DataReadWrite.h"


@implementation DataReadWrite


/**
 *  用来获取保存本地化的数据
 *
 *  @param key key
 *
 *  @return value
 */
+(id)objectForKey:(NSString*)key{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithContentsOfFile:[DataReadWrite getPath]];
    return [dic objectForKey:key];
}

/**
 *  用来保存本地化的数据
 *
 *  @param value value
 *  @param key   key
 */
+(void)setValue:(id)value Key:(NSString*)key{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithContentsOfFile:[DataReadWrite getPath]];
    if (dic == nil) {
        dic = [[NSMutableDictionary alloc] init];
    }
    [dic setValue:value forKey:key];
    [dic writeToFile:[DataReadWrite getPath] atomically:YES];
}


+(NSString*)getPath{
    NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:Main_Path];
    NSString* BundleName = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleName"];
    path =[path stringByAppendingPathComponent: BundleName];
    
    //检查 创建 文件夹
    BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    if (bo==NO) {
        NSLog(@"创建目录失败");
    }
    //end
    
    path =[path stringByAppendingPathComponent: BundleName];
    path = [path stringByAppendingString:@".plist"];
    
    return path;
}
@end
