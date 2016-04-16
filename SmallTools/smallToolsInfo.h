//
//  smallToolsInfo.h
//  SmallTools
//
//  Created by cxh on 16/3/29.
//  Copyright © 2016年 cxh. All rights reserved.
//

#ifndef smallToolsInfo_h
#define smallToolsInfo_h
//解决窗口拉伸问题后再设置可变吧
#define leftTableViewController_MinWidth 200
#define leftTableViewController_MaxWidth 200

#define rightViewController_MinWidth 400
#define rightViewController_MaxWidth 400

#define TopViewController_MinHight 150
#define TopViewController_MaxHight 150

#define bottomViewController_MinHight 400
#define bottomViewController_MaxHight 400


//工具名称
#define TOOLS_ARR @[@"json,nosj转换",\
                    @"命名空间批量处理",\
                    @"计划本",\
                    @"记事本",\
                    @"整合"\
                    ]

//工具附言
#define TOOLS_PS_ARR @[@"json和nosj格式转换",\
                       @"命名空间批量处理，svn更新下来小精灵classes的bug。",\
                       @"记录计划",\
                       @"记事本（有标签也懒得用，我觉得做出来了，我也不会用。）",\
                       @"就是这个程序框架"\
                      ]

//工具开发状态(0还没做（或者懒得做了），1完成可用，2正在做)
#define TOOLS_BUFF_ARR @[@1,\
                         @1,\
                         @2,\
                         @0,\
                         @1\
                            ]

//工具类名(先多写点备用)［添加的时候替换类名，然后加头文件就行了］
//如果不够记得改一下bottomviewcontroller.m下的代码
#import "defaultViewController.h"//默认视图

#import "json_nosjViewController.h"
#define TOOL_CLASSES_NAME_0 json_nosjViewController

#import "nameSpaceBugViewController.h"
#define TOOL_CLASSES_NAME_1 nameSpaceBugViewController

#import "PlanbookViewController.h"
#define TOOL_CLASSES_NAME_2 PlanbookViewController

#define TOOL_CLASSES_NAME_3 defaultViewController

#define TOOL_CLASSES_NAME_4 defaultViewController

#define TOOL_CLASSES_NAME_5 defaultViewController

#define TOOL_CLASSES_NAME_6 defaultViewController

#define TOOL_CLASSES_NAME_7 defaultViewController

#define TOOL_CLASSES_NAME_8 defaultViewController

#define TOOL_CLASSES_NAME_9 defaultViewController

#define TOOL_CLASSES_NAME_10 defaultViewController

#define TOOL_CLASSES_NAME_11 defaultViewController


#endif /* smallToolsInfo_h */
