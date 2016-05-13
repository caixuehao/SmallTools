//
//  TopViewController.m
//  SmallTools
//
//  Created by cxh on 16/3/29.
//  Copyright © 2016年 cxh. All rights reserved.
//

#import "TopViewController.h"
#import "smallToolsInfo.h"
#import "DataReadWrite.h"

@interface TopViewController ()

@end

@implementation TopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    tools_ps_arr = TOOLS_PS_ARR;
    [_toolPsTextView setEditable:NO];
    [_toolPsTextView setString:tools_ps_arr[0]];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTool:) name:@"changeTool" object:nil];
    
    if ([DataReadWrite objectForKey:@"leftTableVC_row"]) {
        int row = [[DataReadWrite objectForKey:@"leftTableVC_row"] intValue];
        _toolPsTextView.string = tools_ps_arr[row];
        
    }
}

- (void)changeTool:(NSNotification *)text{
    int row =  [[text.userInfo objectForKey:@"row"] intValue];
    _toolPsTextView.string = tools_ps_arr[row];
}

@end
