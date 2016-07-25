//
//  DownloadFile2.m
//  SmallTools
//
//  Created by cxh on 16/7/25.
//  Copyright © 2016年 cxh. All rights reserved.
//

#import "DownloadFile2.h"
typedef void (^Downloading)(long long PresentSize,long long WholeSize);
typedef void (^Finished)(void);
typedef void (^ErrorMsg)(NSString* str);

@interface DownloadFile2()<NSURLSessionDownloadDelegate>
//下载任务
@property (nonatomic, strong)NSURLSessionDownloadTask *downTask;

//网络会话
@property (nonatomic, strong)NSURLSession * downLoadSession;

@end
@implementation DownloadFile2{
    //下载中的回调
    Downloading _downloadingBlock;
    //下载成功的回调
    Finished _finishedBlock;
    //一些错误通知
    ErrorMsg _errorBlock;
    //文件临时地址
    NSString* _tmpPath;
    //文件保存地址
    NSString* _savePath;
    //文件下载地址
    NSString* _URL;
}
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
+(void)start:(NSString*)URL savePath:(NSString*)path tmpPath:(NSString*)tmpPath Downloading:(void(^)(long long PresentSize,long long WholeSize))downloadingBlock Finished:(void(^)(void))finishedBlock error:(void(^)(NSString* error))errorBlock{
    DownloadFile2* downloadFile = [[DownloadFile2 alloc] init];
    [downloadFile start:URL savePath:path tmpPath:tmpPath Downloading:downloadingBlock Finished:finishedBlock error:errorBlock];
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

-(void)start:(NSString*)URL savePath:(NSString*)path tmpPath:(NSString*)tmpPath Downloading:(void(^)(long long PresentSize,long long WholeSize))downloadingBlock Finished:(void(^)(void))finishedBlock error:(void(^)(NSString* error))errorBlock{
    
    _URL = URL;
    _savePath = path;//[path stringByAppendingString:@".tmp"];
    _downloadingBlock = downloadingBlock;
    _finishedBlock = finishedBlock;
    _errorBlock = errorBlock;
    _tmpPath = tmpPath;
    
    //创建网络会话
    self.downLoadSession =[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:NULL];;

    //数据请求
    /*
     *@param URL 资源url
     *@param timeoutInterval 超时时长
     */
    NSURLRequest *imgRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:URL] cachePolicy:5 timeoutInterval:60.f];
    //创建下载任务
    self.downTask = [self.downLoadSession downloadTaskWithRequest:imgRequest];
    //启动下载任务
    [self.downTask resume];
}


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    //移动文件
    //判断是否移动
    NSFileManager* mgr = [NSFileManager defaultManager];
    NSError* error;
    for (int i = 0; 1; i++) {
        NSString *savepath = [[NSString alloc] initWithString:_savePath];
        //合成名字
        if (i) {
            NSRange range = [savepath rangeOfString:@"." options:NSBackwardsSearch];//从末位搜索
            if (range.location != NSNotFound) {
                NSString* str1 = [savepath substringToIndex:range.location];
                NSString* str2 = [savepath substringFromIndex:range.location];
                savepath = [NSString stringWithFormat:@"%@(%d)%@",str1,i,str2];
            }else {
                savepath = [NSString stringWithFormat:@"%@(%d)",savepath,i];
            }
        }
        
        if ([mgr moveItemAtPath:[location path] toPath:savepath error:&error] == NO){
            if(516 == [error code]){
                
            }else{
                _errorBlock([error localizedDescription]);
                break;
            }
        }else{
            if(_finishedBlock)_finishedBlock();
            break;
        }
    }
    [session invalidateAndCancel];
}
#pragma mark - 下载成功 获取下载内容
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite; {
//        printf("%lf / %lld / %lld\n", (double)totalBytesWritten / (double)totalBytesExpectedToWrite, totalBytesWritten, totalBytesExpectedToWrite);
    if(_downloadingBlock)_downloadingBlock(totalBytesWritten,totalBytesExpectedToWrite);
}

#pragma mark 下载完成 无论成功失败
-(void)URLSession:(NSURLSession *)session task: (NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
//    NSLog(@" function == %s, line == %d, error ==  %@",__FUNCTION__,__LINE__,error);
    if (error) {
          _errorBlock([error localizedDescription]);
    }
     [session invalidateAndCancel];
}
@end
