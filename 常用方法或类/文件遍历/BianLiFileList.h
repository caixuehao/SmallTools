//
//  BianLiFileList.h
//  ceshi
//
//  Created by duole on 15/8/7.
//  Copyright (c) 2015年 duole. All rights reserved.
//

#import  <Foundation/Foundation.h>

@interface BianLiFileList :NSObject
/**
 *  @brief  获得指定目录下的文件列表
 *
 *  @param  path  指定目录
 *
 *  @param  panduan 文件名字判断回调函数，如果想要该名字返回YES，否则NO
 *
 *  @return 文件名列表
 */
+(NSMutableArray *)BianLiPathList:(NSString*)path FileNamePanDuan:(BOOL (^)(NSString *str))panduan;
    //调用范例
/*
NSString *path = @"/Users/duole/Documents/小工具/shiyan";
NSMutableArray* arr = [BianLiFileList BianLiPathList:path FileNamePanDuan:^BOOL(NSString *str) {
    //            NSString *str = @"asdfa.cpp";
    NSRange index=[str rangeOfString:@".h"];
    NSRange index2=[str rangeOfString:@".cpp"];
    NSUInteger i1=index.length;
    NSUInteger i2=index2.length;
    if(i1==0&&i2==0){
        return NO;
    }
    return YES;
    
}];
NSLog(@"%@",arr);
*/

/**
 *  @brief  获得指定目录下的文件列表
 *
 *  @param  path  指定目录
 *
 *  @return 文件名列表
 */

+(NSMutableArray *)BianLiPathList:(NSString*)path;
@end
