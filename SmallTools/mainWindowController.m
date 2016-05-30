//
//  mainWindowController.m
//  SmallTools
//
//  Created by cxh on 16/5/30.
//  Copyright © 2016年 cxh. All rights reserved.
//

#import "mainWindowController.h"

NSWindow* m_window;
@interface mainWindowController ()

@end

@implementation mainWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    m_window = _mainWindow;
}

+(NSWindow*)getMainWindow{
    return m_window;
}
@end
