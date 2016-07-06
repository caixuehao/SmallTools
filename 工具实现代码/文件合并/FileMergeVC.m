//
//  FileMergeVC.m
//  SmallTools
//
//  Created by cxh on 16/7/6.
//  Copyright © 2016年 cxh. All rights reserved.
//

#import "FileMergeVC.h"
#import "BianLiFileList.h"
@interface FileMergeVC ()

@end

@implementation FileMergeVC{
    BOOL _isMerge;
    NSMutableArray *mergePath_arr;
    NSMutableArray *addPath_arr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [_btn setTitle:@"检查"];
    _isMerge = NO;
}
- (IBAction)start:(id)sender {
    if (_isMerge == NO) {
        
        
        _tv.string = @"";
        [self log:@"开始检查（个人用，直接放在ui线程跑，会卡）..."];
        //初步检查
        if([self inspect1] == NO) return;
        //查看文件夹名字是否相同
        if ([[_tf1.stringValue lastPathComponent] isEqualToString:[_tf2.stringValue lastPathComponent]] == NO) {
            [self log:@"⚠️警告:两个文件夹名字不一样，请确认"];
        }
        //文件夹分析
        NSMutableArray* path_arr1 = [BianLiFileList BianLiPathList:_tf1.stringValue  FileNamePanDuan:nil];
        NSMutableArray* path_arr2 = [BianLiFileList BianLiPathList:_tf2.stringValue  FileNamePanDuan:nil];
        
        mergePath_arr = [[NSMutableArray alloc] init];
        addPath_arr = [[NSMutableArray alloc] init];
        NSLog(@"%lu",path_arr2.count);
        
        
        for (int i = 0; i < path_arr2.count; i++) {
            NSString* path = [_tf1.stringValue stringByAppendingString:[path_arr2[i] substringFromIndex:_tf2.stringValue.length]];
            if ([path_arr1 containsObject:path]) {
                [mergePath_arr addObject:path_arr2[i]];
            }else{
                [addPath_arr addObject:path_arr2[i]];
            }
        }
        [self log:[NSString stringWithFormat:@"需要替换%lu个文件，添加%lu个文件。",mergePath_arr.count,addPath_arr.count]];
        [self log:@"替换文件:"];
        for (NSString* str in mergePath_arr) {
            [self log:str];
        }
        [self log:@"\n\n\n"];
        [self log:@"添加文件:"];
        for (NSString* str in addPath_arr) {
            [self log:str];
        }
       
        
        _isMerge = YES;
        [_btn setTitle:@"替换"];
        
        
        
    }else{
        
        
        
        [self log:@"开始替换（个人用，直接放在ui线程跑，会卡）..."];
        NSFileManager * fm = [NSFileManager defaultManager];
        //添加文件
        for (int i = 0; i < addPath_arr.count; i++) {
            [self log:[NSString stringWithFormat:@"添加文件:%@",addPath_arr[i]]];
            NSString* path = [_tf1.stringValue stringByAppendingString:[addPath_arr[i] substringFromIndex:_tf2.stringValue.length]];
            NSError *error;
            [fm moveItemAtPath:addPath_arr[i] toPath:path error:&error];
            if (error) {
                if([error code] == 4){//文件夹不存在
                     error = nil;
                    //创建文件夹重新移动
                    NSString* fileDirPath = [path substringToIndex:path.length - [path lastPathComponent].length-1];
                    [fm createDirectoryAtPath:fileDirPath withIntermediateDirectories:YES attributes:nil error:nil];
                    [fm moveItemAtPath:addPath_arr[i] toPath:path error:&error];
                }
            }
            if (error) {
                [self log:[NSString stringWithFormat:@"发生错误:%lu,%@",[error code],[error localizedDescription]]];
                return;
            }
        }
        //替换文件
        for (int i = 0; i < mergePath_arr.count; i++) {
            NSError *error;
            NSString* path = [_tf1.stringValue stringByAppendingString:[mergePath_arr[i] substringFromIndex:_tf2.stringValue.length]];
            [self log:[NSString stringWithFormat:@"替换文件:%@",path]];
            //删除文件
            [fm removeItemAtPath:path error:&error];
            //移动文件
            [fm moveItemAtPath:mergePath_arr[i] toPath:path error:&error];
            if (error) {
                [self log:[NSString stringWithFormat:@"发生错误:%lu,%@",[error code],[error localizedDescription]]];
                return;
            }
        }
        
        
        _isMerge = NO;
        [_btn setTitle:@"检查"];
    }
}

-(BOOL)inspect1{
    //检查路径是否一样
    if ([_tf1.stringValue isEqualToString:_tf2.stringValue]) {
        [self log:@"路径一样不能替换"];
        return NO;
    }
    
    //先检查文件夹是否存在
    NSFileManager * fm = [NSFileManager defaultManager];
    
    
    //查看文件是否存在
    if([fm fileExistsAtPath:_tf1.stringValue] == NO){
        [self log:@"主体路径不存在文件"];
        return NO;
    }
    if([fm fileExistsAtPath:_tf2.stringValue] == NO){
        [self log:@"替换路径不存在文件"];
        return NO;
    }
    
    BOOL isDir;
    //检查是否是文件夹
    if (([fm fileExistsAtPath:_tf1.stringValue isDirectory:&isDir] && isDir) == NO){
        [self log:@"主体路径不是文件夹"];
        return NO;
    }
    if (([fm fileExistsAtPath:_tf2.stringValue isDirectory:&isDir] && isDir) == NO){
        [self log:@"替换路径不是文件夹"];
        return NO;
    }
    
    return YES;
}




-(void)log:(NSString*)str{
    NSLog(@"%@",str);
    _tv.string =  [NSString stringWithFormat:@"%@%@\n",_tv.string,str];
}

@end
