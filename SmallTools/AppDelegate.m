//
//  AppDelegate.m
//  SmallTools
//
//  Created by cxh on 16/3/29.
//  Copyright © 2016年 cxh. All rights reserved.
//

#import "AppDelegate.h"
#import "mainWindowController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
   
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    
}

//点击重新打开主窗口
- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication
                    hasVisibleWindows:(BOOL)flag{
    if (!flag){
        //主窗口显示
        [NSApp activateIgnoringOtherApps:NO];
        [[mainWindowController getMainWindow] makeKeyAndOrderFront:self];
    }
    return YES;
}


@end
