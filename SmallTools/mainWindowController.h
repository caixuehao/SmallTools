//
//  mainWindowController.h
//  SmallTools
//
//  Created by cxh on 16/5/30.
//  Copyright © 2016年 cxh. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface mainWindowController : NSWindowController

@property (weak) IBOutlet NSWindow *mainWindow;

+(NSWindow*)getMainWindow;
@end
