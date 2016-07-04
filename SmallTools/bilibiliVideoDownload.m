//
//  bilibiliVideoDownload.m
//  SmallTools
//
//  Created by cxh on 16/7/4.
//  Copyright © 2016年 cxh. All rights reserved.
//

#import "bilibiliVideoDownload.h"
#import "ViedoDownloadCell.h"
#import "DownloadFile.h"
@interface bilibiliVideoDownload ()

@end

@implementation bilibiliVideoDownload{
    NSMutableArray* CIDs_arr;
    NSTableView * _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _message_label.stringValue = @"";
    _AvID_tf.stringValue = @"http://www.bilibili.com/video/av2288962/";
    _startDownload_btn.hidden = YES;
    _clearDownloadList_btn.hidden = YES;
    
    
    //建立tabelview
    NSScrollView * tableContainer = [[NSScrollView alloc] initWithFrame:NSMakeRect(10, 10, 380, 250)];
    _tableView = [[NSTableView alloc] initWithFrame:NSMakeRect(0, 0, tableContainer.frame.size.width , tableContainer.frame.size.height)];
    _tableView.rowHeight = 50;//列高
    
    //初始化一行
    NSTableColumn * column1 = [[NSTableColumn alloc] initWithIdentifier:@"col1"];
    
    [column1 setWidth:tableContainer.frame.size.width-20];//行宽
    column1.headerCell.title = @"视频列表";//行头名称
    [column1 setDataCell:[[ViedoDownloadCell alloc] init]];//设置cell类型
    
    [_tableView addTableColumn:column1];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];

    [tableContainer setDocumentView:_tableView];
    [tableContainer setHasVerticalScroller:YES];
    
    [self.view addSubview:tableContainer];
}


- (IBAction)Download_start:(id)sender {
    if (_AvID_tf.stringValue.length == 0) return;
    //解析Aid
    NSString* Aid = [self getAid:_AvID_tf.stringValue];
    if (Aid.length > 0) {
        _message_label.stringValue = [NSString stringWithFormat:@"视频Aid:%@",Aid];
        [self getCids:Aid Block:^(NSMutableArray *Cids) {
            NSLog(@"%@",Cids);
            CIDs_arr = Cids;
            dispatch_async(dispatch_get_main_queue(), ^{
                _message_label.stringValue = [NSString stringWithFormat:@"视频Aid:%@ 有%lu个视频等待下载",Aid,Cids.count];
                [_tableView reloadData];
                if (Cids.count) {
                    _startDownload_btn.hidden = NO;
                    _clearDownloadList_btn.hidden = NO;
                }
            });
        }];
        
    }else{
        _message_label.stringValue = @"输入有误,没有解析到Aid";
    }
    
    
}
- (IBAction)startDownload:(id)sender {
    for (NSMutableDictionary *dic in CIDs_arr) {
        if ([dic objectForKey:@"mode"] == 0) {
            NSString* url = [NSString stringWithFormat:@"http://www.bilibilijj.com/Files/DownLoad/%@.mp4/www.bilibilijj.com.mp4?mp3=true",[dic objectForKey:@"cid"]];
            NSLog(@"%@",url);
            NSString* savePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Downloads"];
            savePath = [NSString stringWithFormat:@"%@/%@.mp4",savePath,[dic objectForKey:@"title"]];
            
            [DownloadFile start:url savePath:savePath Downloading:^(long long PresentSize, long long WholeSize) {
                NSLog(@"%lld/%lld",PresentSize,WholeSize);
            } Finished:^{
                [dic setObject:@"mode" forKey:@(2)];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadData];
                });
            } error:^(NSString *error) {
                [dic setObject:@"mode" forKey:@(-1)];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadData];
                });
            }];
            
            
        }
    }
}
- (IBAction)clearDownloadList:(id)sender {
    CIDs_arr = [[NSMutableArray alloc] init];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
}

//获取Aid
-(NSString*)getAid:(NSString*)str{
    if ([self isPureInt:str]) {
        return str;
    }
    if ([self isAVID:str]) {
        return [str substringFromIndex:2];
    }
    NSString* outStr = [self isBilibiliURL:str];
    if (outStr.length > 0) {
        return outStr;
    }
    return @"";
}

//获取cids
-(void)getCids:(NSString*)Aid Block:(void(^)(NSMutableArray* Cids))block{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://app.bilibili.com/x/view?actionKey=appkey&aid=%@&appkey=27eb53fc9058f8c3",Aid]]];
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;//忽略本地缓存数据
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          if (!error)
                                          {
                                              NSMutableArray* out_Cids = [[NSMutableArray alloc] init];
                                              NSDictionary* data_dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                              data_dic = [data_dic objectForKey:@"data"];

                                              //顺便把名字合成一下
                                              NSString* av_Title = [data_dic objectForKey:@"title"];
                                              NSLog(@"%@",av_Title);
                                              NSArray* pages = [data_dic objectForKey:@"pages"];
                                              for (NSDictionary *dic in pages) {
                                                  NSString* cid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cid"]];
                                                  NSString* subTitle = [dic objectForKey:@"part"];
                                                  if (subTitle.length == 0) {
                                                      NSInteger page = [[dic objectForKey:@"page"] integerValue];
                                                      if (page > 1) subTitle = [NSString stringWithFormat:@"%lu",page];
                                                  }
                                                  NSString* title = [NSString stringWithFormat:@"%@ %@",av_Title,subTitle];
                                                  NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithDictionary:@{@"cid":cid,@"title":title}];
                                                  [out_Cids addObject:dic];;
                                              }
                                              block(out_Cids);

                                          }
                                          
                                      }];
    // 使用resume方法启动任务
    [dataTask resume];
    
}

#pragma NSTableViewDataSource,NSTableViewDelegate---
//返回有几列（必须实现）
- ( NSInteger )numberOfRowsInTableView:( NSTableView *)tableView
{
    return CIDs_arr.count;
}


//初始化每行数据（必须实现）
-  ( id )tableView:( NSTableView *)tableView objectValueForTableColumn:( NSTableColumn *)tableColumn row:( NSInteger )row
{
    ViedoDownloadCell* cell =  [tableColumn dataCellForRow:row];
    //[cell setBackgroundColor:[NSColor yellowColor]];
    
    //NSString* title = [CIDs_arr[row] objectForKey:@"title"];
    [cell setData:CIDs_arr[row]];
    return cell;
}


//操作cell调用
-( void )tableView:( NSTableView *)tableView setObjectValue:( id )object forTableColumn:( NSTableColumn *)tableColumn row:( NSInteger )row
{
    NSInteger mode = [[CIDs_arr[row] objectForKey:@"mode"] integerValue];
    if (mode == 0) {//下载
        [CIDs_arr[row] setObject:@(-1) forKey:@"mode"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableView reloadData];
        });
        
    } else if(mode == -1){//不下载
        [CIDs_arr[row] setObject:@(0) forKey:@"mode"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableView reloadData];
        });
    } 
}

#pragma  辅助函数
//判断是否为整形
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
//判断是否是av代码
- (BOOL)isAVID:(NSString*)string{
    if(string.length<=2)return NO;
    
    NSString* str = [string substringToIndex:2];
    NSString* str2 = [string substringFromIndex:2];
    if ([str isEqualToString:@"AV"]||
        [str isEqualToString:@"av"]||
        [str isEqualToString:@"Av"]||
        [str isEqualToString:@"aV"])
    {
        return [self isPureInt:str2];
    }
    return NO;
}

//判断是否是bilibli网址
- (NSString*)isBilibiliURL:(NSString*)string{
    if(string.length<=32)return @"";
    
    NSString* str1 = [string substringToIndex:32];
    NSString* str2 = [string substringFromIndex:32];
    if ([str1 compare:@"http://www.bilibili.com/video/av" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        NSRange range = [str2 rangeOfString:@"/"];
        if (range.location != NSNotFound) {
            str2 = [str2 substringToIndex:range.location];
        }
        if ([self isPureInt:str2]) {
            return str2;
        }
        return @"";
    }
    return @"";
}

@end
