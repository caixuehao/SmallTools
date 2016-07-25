//
//  DownloadFile2.h
//  SmallTools
//
//  Created by cxh on 16/7/25.
//  Copyright © 2016年 cxh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadFile2 : NSObject
/**
 *  开始下载
 *
 *  @param URL  下载地址
 *  @param savepath 保存地址
 *  @param tmppath  没下完的保存地址（得唯一）
 *  @param downloadingBlock 下载中的回调
 *  @param finishedBlock    下载成功的回调
 *  @param errorBlock       一些错误通知
 */

+(void)start:(NSString*)URL savePath:(NSString*)path tmpPath:(NSString*)tmpPath Downloading:(void(^)(long long PresentSize,long long WholeSize))downloadingBlock Finished:(void(^)(void))finishedBlock error:(void(^)(NSString* error))errorBlock;

@end
