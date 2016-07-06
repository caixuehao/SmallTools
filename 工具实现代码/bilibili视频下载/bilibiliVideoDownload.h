//
//  bilibiliVideoDownload.h
//  SmallTools
//
//  Created by cxh on 16/7/4.
//  Copyright © 2016年 cxh. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface bilibiliVideoDownload : NSViewController<NSTableViewDataSource,NSTableViewDelegate>

@property (weak) IBOutlet NSTokenField *AvID_tf;

@property (weak) IBOutlet NSTextField *message_label;

@property (weak) IBOutlet NSButton *startDownload_btn;

@property (weak) IBOutlet NSButton *clearDownloadList_btn;

@end

