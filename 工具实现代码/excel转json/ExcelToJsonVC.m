//
//  ExcelToJsonVC.m
//  SmallTools
//
//  Created by cxh on 17/4/11.
//  Copyright © 2017年 cxh. All rights reserved.
//

#import "ExcelToJsonVC.h"
//#import <Objective-Zip.h>
@interface ExcelToJsonVC (){
    NSString* ImagePath;
    NSMutableArray<NSString *>* bgUrlArr;
    NSMutableArray<NSString *>* roleUrlArr;
    NSMutableArray<NSString *>* cgUrlArr;
}
@property (weak) IBOutlet NSTextField *filePathTF;

//@property(nonatomic,strong)OZZipFile* excelZip;

@end

@implementation ExcelToJsonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}
- (IBAction)start:(id)sender {
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        [self excelToJson];
    }];
}

- (void)excelToJson{
//    _excelZip  = [[OZZipFile alloc] initWithFileName:_filePathTF.stringValue mode:OZZipFileModeUnzip];
//    NSString* str = [NSString stringWithContentsOfFile:_filePathTF.stringValue encoding:4 error:nil];
    
    
    //下载背景人物图
    NSData* data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bilibili" ofType:@"js"]];
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    ImagePath = @"http://activity.hdslb.com/zzjs/20160801qixi/img/";
    bgUrlArr = [[NSMutableArray alloc] init];
    roleUrlArr = [[NSMutableArray alloc] init];
    cgUrlArr = [[NSMutableArray alloc] init];
    [self downloadImage:dic];
    
    NSLog(@"%lu:%@",cgUrlArr.count,cgUrlArr);
    //转bilibili七夕galgame数据临时代码
//    NSData* data = [NSData dataWithContentsOfFile:_filePathTF.stringValue];
//    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//    
//    NSMutableDictionary* outdic = [self jsontest:dic];
//    NSData* outstr = [NSJSONSerialization dataWithJSONObject:outdic options:NSJSONWritingPrettyPrinted error:nil];
//    [outstr writeToFile:@"/Users/cxh/Desktop/Bilibili七夕之约 - 哔哩哔哩弹幕视频网 - ( ゜- ゜)つロ 乾杯_ - bilibili_files/st_bilibili.json" atomically:YES];
}

-(void)downloadImage:(NSDictionary*)dic{
   
    for (NSString *key in dic) {
        if ([key isEqualToString:@"choose"]) {
            NSDictionary * choose = [dic objectForKey:key][0];
            for (NSString* key in choose) {
                [self downloadImage:[choose objectForKey:key]];
            }
        }else if([key isEqualToString:@"background"]){
            NSArray<NSString *>*bg = [dic objectForKey:key];
            for (int i = 0; i< bg.count; i++) {
                [self addBgUrl:[ImagePath stringByAppendingString:bg[i]]];
            }
        }else if([key isEqualToString:@"role"]){
            NSArray<NSString *>*role = [dic objectForKey:key];
            for (int i = 0; i< role.count; i++) {
                [self addRoleUrl:[ImagePath stringByAppendingString:role[i]]];
            }
        }else if([key isEqualToString:@"end"]){
            [self addCGUrl:[ImagePath stringByAppendingString:[[dic objectForKey:key] objectForKey:@"CG"]]];
        }
        
    }

    
}

-(void)addBgUrl:(NSString*)bgurl{
    BOOL bl = YES;
    for (int i = 0; i < bgUrlArr.count; i++) {
        if ([bgurl isEqualToString:bgUrlArr[i]]) {
            bl = NO;
        }
    }
    if (bl) {
       [bgUrlArr addObject:bgurl];
    }
    
}


-(void)addRoleUrl:(NSString*)roleUrl{
    BOOL bl = YES;
    for (int i = 0; i < roleUrlArr.count; i++) {
        if ([roleUrl isEqualToString:roleUrlArr[i]]) {
            bl = NO;
        }
    }
    if (bl) {
        [roleUrlArr addObject:roleUrl];
    }
}

-(void)addCGUrl:(NSString*)CGUrl{
    BOOL bl = YES;
    for (int i = 0; i < cgUrlArr.count; i++) {
        if ([CGUrl isEqualToString:cgUrlArr[i]]) {
            bl = NO;
        }
    }
    if (bl) {
        [cgUrlArr addObject:CGUrl];
    }
}


-(NSMutableDictionary*)jsontest:(NSDictionary*)dic{
    NSMutableDictionary* outDic = [[NSMutableDictionary alloc] init];
    for (NSString *key in dic) {
        if ([key isEqualToString:@"choose"]) {
            
            NSDictionary * choose = [dic objectForKey:key][0];
            NSMutableArray* chooseOut = [[NSMutableArray alloc] init];
            for (NSString* key in choose) {
                NSMutableDictionary* chooseDic = [[NSMutableDictionary alloc] init];
                [chooseDic setObject:key forKey:@"text"];
                [chooseDic setObject:[self jsontest:[choose objectForKey:key]] forKey:@"gameEvent"];
                [chooseOut addObject:chooseDic];
            }
            [outDic setObject:chooseOut forKey:key];
            
            
        }else{
            [outDic setObject:dic[key] forKey:key];
        }
        
    }
    return outDic;
}




//解析xl下的workbook.xml文件查询到底有几个sheet文件
- (void)read_workbook{

}
@end
