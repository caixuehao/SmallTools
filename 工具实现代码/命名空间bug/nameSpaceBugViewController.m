//
//  nameSpaceBug.m
//  SmallTools
//
//  Created by cxh on 16/3/30.
//  Copyright © 2016年 cxh. All rights reserved.
//

#import "nameSpaceBugViewController.h"
#import "BianLiFileList.h"
@interface nameSpaceBugViewController ()

@end

@implementation nameSpaceBugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
}
- (IBAction)btn:(id)sender {
    [self start_google_namespace:_tf1.stringValue];
}

- (IBAction)btn2:(id)sender {
    [self start_cocos_namespace:_tf2.stringValue];
}








//google替换成google_publice逻辑代码
-(void)start_google_namespace:(NSString*)path{
    //读取文件路径
    
    NSMutableArray* arr = [BianLiFileList BianLiPathList:path FileNamePanDuan:^BOOL(NSString *str) {
        NSString* str1 = [str substringFromIndex:str.length-2];
        NSString* str2 = [str substringFromIndex:str.length-3];
        if ([str1 isEqualToString:@".h"]||[str2 isEqualToString:@".cc"]) {
            return YES;
        }
        return NO;
    }];
    
    NSLog(@"共%lu个文件",(unsigned long)arr.count);
    [self log:[NSString stringWithFormat:@"共%lu个文件",(unsigned long)arr.count]];
    
    //开始处理
    for (NSString* str in arr) {
        NSError*error =nil;
        NSString* content = [NSString stringWithContentsOfFile:str encoding:NSASCIIStringEncoding  error:&error];
        if(error) NSLog(@"%ld,%@",content.length, [error localizedDescription]);
        
        content = [content stringByReplacingOccurrencesOfString:@"::google::" withString:@"::google_public::"];
        
        content = [content stringByReplacingOccurrencesOfString:@"namespace google" withString:@"namespace google_public"];
        if(error)NSLog(@"%ld",content.length);
        
        [content writeToFile:str atomically:NO encoding:NSASCIIStringEncoding error:&error];
        if(error) NSLog(@"%@",error);
    }
    [self log:@"处理完毕！"];
    NSLog(@"处理完毕！");
}







//冲突控件前加cocos::
-(void)start_cocos_namespace:(NSString*)path{
    
    //获取文件路径数组
    NSMutableArray* arr = [BianLiFileList BianLiPathList:path FileNamePanDuan:^BOOL(NSString *str) {
        
        NSString* str1 = [str substringFromIndex:str.length-2];
        NSString* str2 = [str substringFromIndex:str.length-4];
        
        if ([str1 isEqualToString:@".h"]||[str2 isEqualToString:@".cpp"]) {
            return YES;
        }
        
        return NO;
        
    }];
    
    
    
    //    NSLog(@"%@",arr);
    NSLog(@"共%lu个文件",(unsigned long)arr.count);
    [self log:[NSString stringWithFormat:@"共%lu个文件",(unsigned long)arr.count]];
    
    
    
    for(NSString *str in arr){
        
        
        //读取文件！
        //gbk转utf8//参考http://www.cnblogs.com/langtianya/p/3889012.html
        NSData* data = [NSData dataWithContentsOfFile:str];
        NSLog(@"%lu",data.length);
        NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString*  content = [[NSString alloc] initWithData:data encoding:enc];
        
        
        
        //逻辑
        content = [content stringByReplacingOccurrencesOfString:@"cocos2d::ui::UIButton" withString:@"UIButton"];
        content = [content stringByReplacingOccurrencesOfString:@"cocos2d::ui::UIImageView" withString:@"UIImageView"];
        content = [content stringByReplacingOccurrencesOfString:@"cocos2d::ui::UILabel" withString:@"UILabel"];
        content = [content stringByReplacingOccurrencesOfString:@"cocos2d::ui::UIScrollView" withString:@"UIScrollView"];
        content = [content stringByReplacingOccurrencesOfString:@"cocos2d::ui::UITextField" withString:@"UITextField"];
        
        
        
        content = [content stringByReplacingOccurrencesOfString:@"UIButton" withString:@"cocos2d::ui::UIButton"];
        content = [content stringByReplacingOccurrencesOfString:@"UIImageView" withString:@"cocos2d::ui::UIImageView"];
        content = [content stringByReplacingOccurrencesOfString:@"UILabel" withString:@"cocos2d::ui::UILabel"];
        content = [content stringByReplacingOccurrencesOfString:@"UIScrollView" withString:@"cocos2d::ui::UIScrollView"];
        content = [content stringByReplacingOccurrencesOfString:@"UITextField" withString:@"cocos2d::ui::UITextField"];
        
        
        
        //写入
        NSError* error = nil;
        [content writeToFile:str atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if(error) NSLog(@"%@",error);
        
        
    }
    
    [self log:@"处理完毕！"];
    NSLog(@"处理完毕！");
}









//添加打印
-(void)log:(NSString*)str{
    NSLog(@"%@",str);
    _textview.string =  [NSString stringWithFormat:@"%@%@\n",_textview.string,str];
    //    QAQ这里让他置底，可惜不正确
    //    [_logScrollView scrollPoint:NSMakePoint(0,_logScrollView.contentSize.height - _logScrollView.frame.size.height)];
}


@end
