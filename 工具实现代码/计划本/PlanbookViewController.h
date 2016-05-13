//
//  PlanbookViewController.h
//  SmallTools
//
//  Created by cxh on 16/4/16.
//  Copyright © 2016年 cxh. All rights reserved.
//

#import <Cocoa/Cocoa.h>
struct H{
    NSInteger x;
    NSInteger y;
};

@interface PlanbookViewController : NSViewController<NSTableViewDataSource,NSTableViewDelegate>

@property (weak) IBOutlet NSTextField *titleTF;

@property (unsafe_unretained) IBOutlet NSTextView *desTV;

@property (weak) IBOutlet NSPopUpButtonCell *popUpButtonCell;

@property (weak) IBOutlet NSSegmentedCell *segmentedCell;

@property(nonatomic,strong)NSTableView * tableView;//显示数据的列表

@property(nonatomic,strong) NSMutableDictionary* main_dic;//主数据

@property(nonatomic,assign)NSInteger now_arr;//当前显示的列表数据

@property(nonatomic,assign)struct H point;//当前选择的元素（实在不知道起什么名字乱起一个）

@end
