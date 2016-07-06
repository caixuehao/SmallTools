//
//  ViedoDownloadCell.h
//  SmallTools
//
//  Created by cxh on 16/7/4.
//  Copyright © 2016年 cxh. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViedoDownloadCell : NSButtonCell
//不会重写NSCell
-(void)setData:(NSMutableDictionary*)data;
@end
