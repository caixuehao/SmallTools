//
//  samllTools1ViewController.m
//  SmallTools
//
//  Created by cxh on 16/6/16.
//  Copyright © 2016年 cxh. All rights reserved.
//

#import "samllTools1ViewController.h"

@interface samllTools1ViewController (){
    BOOL isjson;
}

@end

@implementation samllTools1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    _tf1.stringValue = @" ";
    _tf2.stringValue = @",";
    isjson = NO;
    
    _ddv1 = [[DragDropView alloc] initWithFrame:NSMakeRect(140 , 60, 140, 140)];
    _ddv1.delegate = self;
    _ddv1.ddv_tag = 1;
    [_ddv1 setWantsLayer:YES];
    [_ddv1.layer setBackgroundColor:[[NSColor yellowColor] CGColor]];
    _btn1 = [[NSButton alloc] initWithFrame:NSMakeRect(10, 10, 120, 120)];
    [[_btn1 cell] setImageScaling:NSImageScaleAxesIndependently];//图片按照大小伸缩。
    [_btn1 setTitle:@"拖文档进来"];
    [_ddv1 addSubview:_btn1];
    
    [self.view addSubview:_ddv1];
    
}

- (IBAction)关键字替换:(id)sender {
    _tv1.string =  [_tv1.string stringByReplacingOccurrencesOfString:_tf1.stringValue withString:_tf2.stringValue];

}

- (IBAction)文档转格式:(id)sender {
    NSData* data = [NSData dataWithContentsOfFile:_path_str];
    NSLog(@"%lu",data.length);
    
    if(isjson){
     NSMutableDictionary* jsonData_dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
     [[NSJSONSerialization dataWithJSONObject:jsonData_dic options:NSJSONWritingPrettyPrinted error:nil] writeToFile:_path_str atomically:YES];
     return;
    }
    
    NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString*  content = [[NSString alloc] initWithData:data encoding:enc];
    //写入
    NSError* error = nil;
    [content writeToFile:_path_str atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if(error) NSLog(@"%@",error);
}


#pragma DragDropViewDelegate---
//获取的所有文件地址
-(void)dragDropViewFileList:(NSArray *)fileList sender:(DragDropView*)sender{
    //如果数组不存在或为空直接返回不做处理（这种方法应该被广泛的使用，在进行数据处理前应该现判断是否为空。）
    if(!fileList || [fileList count] <= 0)return;

    if(fileList.count == 1){
        NSString* houZui = [fileList[0] lastPathComponent];
        houZui = [houZui substringFromIndex:houZui.length-4];
        if ([houZui isEqualToString:@".txt"]) {
            _path_str = fileList[0];
            [_btn1 setTitle:[_path_str lastPathComponent]];
            [_ddv1.layer setBackgroundColor:[[NSColor greenColor] CGColor]];
            isjson = NO;
        }else if ([houZui isEqualToString:@"json"]){
            _path_str = fileList[0];
            [_btn1 setTitle:[_path_str lastPathComponent]];
            [_ddv1.layer setBackgroundColor:[[NSColor greenColor] CGColor]];
            isjson = YES;
        }
    }
}

@end
