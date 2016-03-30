//
//  BianLiFileList.m
//  ceshi
//
//  Created by duole on 15/8/7.
//  Copyright (c) 2015年 duole. All rights reserved.
//

#import "BianLiFileList.h"

@implementation BianLiFileList
+(NSMutableArray *)BianLiPathList:(NSString*)path FileNamePanDuan:(BOOL (^)(NSString *))panduan{
    NSMutableArray* PathList = [[NSMutableArray alloc] init] ;
    //获取子文件
    NSFileManager * fm = [NSFileManager defaultManager];
    NSArray * array = [fm contentsOfDirectoryAtPath:path error:nil];
//    NSLog(@"%@",array);

    for(NSString *str in array){

        //字符串文件名预处理
        NSString *pathin = [[NSString alloc] initWithFormat:@"%@/%@",path,str];

        BOOL isDir;
        if ([fm fileExistsAtPath:pathin isDirectory:&isDir] && isDir) {
//            NSLog(@"%@ is a directory", pathin);
            [PathList addObjectsFromArray:[self BianLiPathList:pathin FileNamePanDuan:panduan]];
        }
        else {
//            NSLog (@"%@ is a file", pathin);
            if (!panduan(str)) {
                continue;
            }
            [PathList addObject:pathin];
        }
    }

    return PathList;
}
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
+(NSMutableArray *)BianLiPathList:(NSString*)path{
    NSMutableArray* PathList = [[NSMutableArray alloc] init];
    
    //获取子文件
    NSFileManager * fm = [NSFileManager defaultManager];
    NSArray * array = [fm contentsOfDirectoryAtPath:path error:nil];
    //    NSLog(@"%@",array);
    
    for(NSString *str in array){
        
        //字符串文件名预处理
        NSString *pathin = [[NSString alloc] initWithFormat:@"%@/%@",path,str];
        
        BOOL isDir;
        if ([fm fileExistsAtPath:pathin isDirectory:&isDir] && isDir) {
            //            NSLog(@"%@ is a directory", pathin);
            [PathList addObjectsFromArray:[self BianLiPathList:pathin]];
        }
        else {
            [PathList addObject:pathin];
            //            NSLog (@"%@ is a file", pathin);
        }
    }
    
    return PathList;
}
@end
