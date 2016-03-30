//
//  json_nosjViewController.h
//  SmallTools
//
//  Created by cxh on 16/3/30.
//  Copyright © 2016年 cxh. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface json_nosjViewController : NSViewController

@property (weak) IBOutlet NSPathControl *inPathControl;

@property (weak) IBOutlet NSPathControl *outPathControl;

@property (weak) IBOutlet NSTextField *outTextField;

@property (unsafe_unretained) IBOutlet NSTextView *logTextView;

@property (weak) IBOutlet NSScrollView *logScrollView;

@end
