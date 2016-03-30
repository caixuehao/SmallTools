//
//  nameSpaceBug.h
//  SmallTools
//
//  Created by cxh on 16/3/30.
//  Copyright © 2016年 cxh. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface nameSpaceBugViewController : NSViewController

@property (weak) IBOutlet NSTextField *tf1;

@property (weak) IBOutlet NSTextField *tf2;

@property (unsafe_unretained) IBOutlet NSTextView *textview;


@end
