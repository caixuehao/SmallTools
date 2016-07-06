//
//  FileMergeVC.h
//  SmallTools
//
//  Created by cxh on 16/7/6.
//  Copyright © 2016年 cxh. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FileMergeVC : NSViewController
@property (weak) IBOutlet NSTextField *tf1;
@property (weak) IBOutlet NSTextField *tf2;

@property (unsafe_unretained) IBOutlet NSTextView *tv;
@property (weak) IBOutlet NSButton *btn;

@end
