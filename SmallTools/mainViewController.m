//
//  ViewController.m
//  SmallTools
//
//  Created by cxh on 16/3/29.
//  Copyright © 2016年 cxh. All rights reserved.
//
#import "smallToolsInfo.h"
#import "mainViewController.h"

@implementation mainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    //设置最大最小拖动
    NSSplitViewItem* item1 = self.splitViewItems[0];
    item1.minimumThickness = leftTableViewController_MinWidth;
    item1.maximumThickness = leftTableViewController_MaxWidth;
    
    //设置最大最小拖动
    NSSplitViewItem* item2 = self.splitViewItems[1];
    item2.minimumThickness = rightViewController_MinWidth;
    item2.maximumThickness = rightViewController_MaxWidth;
//    mainVC = self;
//     [[NSApp dockTile] setBadgeLabel:@"test"];
//    
//      [NSApp setApplicationIconImage:[NSImage imageNamed:@"zhijie1"]];
  
//    NSButton* btn = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 200, 30)];
//    btn.stringValue = @"123";
    

}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}
-(void)dealloc{
    NSLog(@"mainVC dealloc");
}

@end
