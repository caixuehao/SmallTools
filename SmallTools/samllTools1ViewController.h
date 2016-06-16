//
//  samllTools1ViewController.h
//  SmallTools
//
//  Created by cxh on 16/6/16.
//  Copyright © 2016年 cxh. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DragDropView.h"

@interface samllTools1ViewController : NSViewController<DragDropViewDelegate>

@property (weak) IBOutlet NSTextField *tf1;

@property (weak) IBOutlet NSTextField *tf2;

@property (unsafe_unretained) IBOutlet NSTextView *tv1;

@property(nonatomic,strong)NSButton* btn1;

@property(nonatomic,strong)DragDropView* ddv1;

@property(nonatomic,strong)NSString* path_str;

@end
