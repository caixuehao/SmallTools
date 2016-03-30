//
//  bottomViewController.m
//  SmallTools
//
//  Created by cxh on 16/3/29.
//  Copyright © 2016年 cxh. All rights reserved.
//

#import "bottomViewController.h"
#import "smallToolsInfo.h"

@interface bottomViewController ()

@end

@implementation bottomViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    NSArray* tools_name = TOOLS_ARR;
    VC_arr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < tools_name.count; i++) {
       
        //初始化工具的界面
        NSViewController* vc ;
        switch (i) {
            case 0:
                vc = [[TOOL_CLASSES_NAME_0 alloc] init];
                break;
            case 1:
                vc = [[TOOL_CLASSES_NAME_1 alloc] init];
                break;
            case 2:
                vc = [[TOOL_CLASSES_NAME_2 alloc] init];
                break;
            case 3:
                vc = [[TOOL_CLASSES_NAME_3 alloc] init];
                break;
            case 4:
                vc = [[TOOL_CLASSES_NAME_4 alloc] init];
                break;
            case 5:
                vc = [[TOOL_CLASSES_NAME_5 alloc] init];
                break;
            case 6:
                vc = [[TOOL_CLASSES_NAME_6 alloc] init];
                break;
            case 7:
                vc = [[TOOL_CLASSES_NAME_7 alloc] init];
                break;
            case 8:
                vc = [[TOOL_CLASSES_NAME_8 alloc] init];
                break;
            case 9:
                vc = [[TOOL_CLASSES_NAME_9 alloc] init];
                break;
            case 10:
                vc = [[TOOL_CLASSES_NAME_10 alloc] init];
                break;
            case 11:
                vc = [[TOOL_CLASSES_NAME_11 alloc] init];
                break;
            default:
                break;
        }
        //加入数组用来切换
        [VC_arr addObject:vc];
        //添加进管理列表
        [self addChildViewController:vc];
    
    }

    
    
    
    
    oldVC = VC_arr[0];
    [self.view addSubview:oldVC.view];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTool:) name:@"changeTool" object:nil];
}

- (void)changeTool:(NSNotification *)text{
    int row =  [[text.userInfo objectForKey:@"row"] intValue];
    NSLog(@"%d",row);
   
    NSViewController* newVC = VC_arr[row];
//    [self presentViewControllerAsSheet:jj];//从上向下弹出
//    [self presentViewControllerAsModalWindow:jj];//模态弹出
//切换视图
    [self transitionFromViewController:oldVC toViewController:newVC options:NSViewControllerTransitionNone completionHandler:^{
    }];
    oldVC = newVC;
}


@end
