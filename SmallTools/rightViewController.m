//
//  rightViewController.m
//  SmallTools
//
//  Created by cxh on 16/3/29.
//  Copyright © 2016年 cxh. All rights reserved.
//
#import "smallToolsInfo.h"
#import "rightViewController.h"

@interface rightViewController ()

@end

@implementation rightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    //设置最大最小拖动
    NSSplitViewItem* item1 = self.splitViewItems[0];
    item1.minimumThickness = TopViewController_MinHight;
    item1.maximumThickness = TopViewController_MaxHight;
    
    //设置最大最小拖动
    NSSplitViewItem* item2 = self.splitViewItems[1];
    item2.minimumThickness = bottomViewController_MinHight;
    item2.maximumThickness = bottomViewController_MaxHight;
}

@end
