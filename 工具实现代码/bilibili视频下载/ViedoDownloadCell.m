//
//  ViedoDownloadCell.m
//  SmallTools
//
//  Created by cxh on 16/7/4.
//  Copyright © 2016年 cxh. All rights reserved.
//

#import "ViedoDownloadCell.h"

@implementation ViedoDownloadCell{
    BOOL isDownload;
    NSTextField* tf;
}
-(id)init{
    self = [super init];
    if (self) {
        self.title = @"";
        self.backgroundColor = [NSColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        //tf = [[NSTextField alloc] initWithFrame:NSMakeRect(10, 25, self.cellSize.width-20, 25)];
        self.font = [NSFont systemFontOfSize:11];
        self.image = [NSImage imageNamed:@"100-100.jpg"];
    }
    return self;
}


-(void)setData:(NSMutableDictionary*)data{
    self.title = [data objectForKey:@"title"];
    NSInteger mode = [[data objectForKey:@"mode"] intValue];
    //NSLog(@"%lu",mode);
    if (mode == 0) {//下载
      self.backgroundColor = [NSColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    } else if(mode == -1){//不下载
        self.backgroundColor = [NSColor grayColor];
    } else if(mode == 1){//下载完成的
         self.backgroundColor = [NSColor yellowColor];
    } else if(mode == 2){
         self.backgroundColor = [NSColor colorWithSRGBRed:0.1 green:0.93 blue:0.13 alpha:1];
    }
}
@end
