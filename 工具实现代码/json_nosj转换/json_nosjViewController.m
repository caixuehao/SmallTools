//
//  json_nosjViewController.m
//  SmallTools
//
//  Created by cxh on 16/3/30.
//  Copyright © 2016年 cxh. All rights reserved.
//

#import "json_nosjViewController.h"

@interface json_nosjViewController ()

@end

@implementation json_nosjViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    //设置path
    //    NSString* str = @"/Users/CXH/Desktop";
    //    [PathControl setURL:[NSURL fileURLWithPath:str]];
//    _inPathControl.delegate = self;
    
    [_logTextView setEditable:NO];//设置不可编写
    [self log:@"Hello World!"];
//    NSString* str = @"fate 二次元 好运娱乐 萌化 皇室战争 传奇 nice 王者荣耀 小说 动漫 动作 游戏 百度贴吧 app 漫画 装逼神器 娘化 秀场 天使幻想 卡牌 手游 武神 无尽的纷争 挂机 回合 策略";
//    str = [str stringByReplacingOccurrencesOfString:@" " withString:@","];
//    NSLog(@"%@",str);
}


- (IBAction)btn:(id)sender {
    //检查路径
    NSFileManager * fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:[self getPath:_inPathControl]] == NO) {
        [self log:@"输入路径错误或者文件不存在！"];
        return;
    }
    
    NSString* outPath = [self getPath:_outPathControl];
    if ([fm fileExistsAtPath:outPath] == NO) {
        [self log:@"输出路径错误或者文件不存在！"];
        return;
    }
    BOOL isDir;
    if (([fm fileExistsAtPath:outPath isDirectory:&isDir] && isDir) == NO) {
        outPath = [outPath substringToIndex:outPath.length-([outPath lastPathComponent].length+1)];
        [_outPathControl setURL:[NSURL fileURLWithPath:outPath]];
        [self log:@"输出路径已修正!"];
    }
    [self log:@"开始..."];
    
    //获取列表
    [self log:@"获取文件路径...."];
    NSMutableArray* arr = [self getFilePaths:[self getPath:_inPathControl]];
    
    for (int i = 0; i < arr.count; i++) {
        [self json_nosj_inpath:arr[i] OutPath:outPath];
        [self log:[NSString stringWithFormat:@"%@转换完毕",arr[i]]];
    }
    
    
    [self log:@"结束。"];
}
//添加打印
-(void)log:(NSString*)str{
    NSLog(@"%@",str);
    _logTextView.string =  [NSString stringWithFormat:@"%@%@\n",_logTextView.string,str];
    //    QAQ这里让他置底，可惜不正确
    //    [_logScrollView scrollPoint:NSMakePoint(0,_logScrollView.contentSize.height - _logScrollView.frame.size.height)];
}

//nosj转json或json转json
-(void)json_nosj_inpath:(NSString*)inPath OutPath:(NSString*)outPath{
    
    NSString* str = [inPath lastPathComponent];//获取文件名
    str = [str substringFromIndex:str.length - 5];
    if ( [str isEqualToString:@".json"]) {
        str = [inPath lastPathComponent];
        str = [str substringToIndex:str.length - 5];
        outPath = [NSString stringWithFormat:@"%@/%@.nosj",outPath,str];
        //取出数据
        NSData* fileData = [NSData dataWithContentsOfFile:inPath];
        char* filech = (char*)[fileData bytes];
        
        //处理数据
        for (int i = 0; i < strlen(filech); i++)
            filech[i] = filech[i]+10;
        
        
        //写入数据
        fileData = [NSData dataWithBytes: filech   length:strlen(filech)];
        
        [fileData writeToFile:outPath atomically:YES];
        
    }else{
        str = [inPath lastPathComponent];
        str = [str substringToIndex:str.length - 5];
        outPath = [NSString stringWithFormat:@"%@/%@.json",outPath,str];
        //取出数据
        NSData* fileData = [NSData dataWithContentsOfFile:inPath];
        char* filech = (char*)[fileData bytes];
        
        //处理数据
        for (int i = 0; i < strlen(filech); i++)
            filech[i] = filech[i]-10;
        
        
        //写入数据
        fileData = [NSData dataWithBytes: filech   length:strlen(filech)];
        
        [fileData writeToFile:outPath atomically:YES];
        
    }
    
}


//获取需要转换的文件路径或路径数组
-(NSMutableArray*)getFilePaths:(NSString*)path{
    NSMutableArray* PathARR = [[NSMutableArray alloc] init] ;
    //检查路径
    NSFileManager * fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path] == NO) {
        [self log:@"路径错误或者文件不存在！"];
        return PathARR;
    }
    
    
    
    //判断是路径还是文件
    
    BOOL isDir;
    if ([fm fileExistsAtPath:path isDirectory:&isDir] && isDir)  {
        //路径
        //查看子文件
        NSArray * array = [fm contentsOfDirectoryAtPath:path error:nil];
        //检查是否有nosj
        for(NSString* str in array){
            //排除太短的和目录
            if (str.length <= 5)continue;
            if ([fm fileExistsAtPath:[path stringByAppendingPathComponent:str] isDirectory:&isDir] && isDir) continue;
            
            NSString* str1 = str;
            //str1 = [str lastPathComponent];//获取文件名
            
            str1 = [str1 substringFromIndex:str1.length - 5];
            if ( [str1 isEqualToString:@".nosj"]) {
                [PathARR addObject:[path stringByAppendingPathComponent:str]];
            }
        }
        [self log:@"nosj文件查找完毕"];
        //如果没有检查是否有json
        for(NSString* str in array){
            //排除太短的和目录
            if (str.length <= 5)continue;
            if ([fm fileExistsAtPath:[path stringByAppendingPathComponent:str] isDirectory:&isDir] && isDir) continue;
            
            NSString* str1 = str;
            str1 = [str lastPathComponent];//获取文件名
            str1 = [str substringFromIndex:str1.length - 5];
            if ( [str1 isEqualToString:@".json"]) {
                [PathARR addObject:[path stringByAppendingPathComponent:str]];
            }
        }
        [self log:@"json文件查找完毕"];
        if (PathARR.count==0){
            [self log:@"该目录下没有需要转的文件!"];
        }
        
    }else{
        //文件
        [PathARR addObject:path];
    }
    
    return PathARR;
}





//获取pathControl地址
-(NSString*)getPath:(NSPathControl*)pathControl{
    
    
    if (pathControl==nil || pathControl.pathItems.count == 0) {
        return @"";
    }
    
    NSString* path = [[pathControl.pathItems lastObject].URL absoluteString];//pathControl.pathItems[0].title;
    
    path = [path substringFromIndex:7];
    
    //    for(int i = 1;i < (pathControl.pathItems.count);i++){
    //        path = [path stringByAppendingPathComponent:pathControl.pathItems[i].title];
    //    }
    
    return path;
}







- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
    
}


@end
