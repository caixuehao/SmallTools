//
//  PlanbookViewController.m
//  SmallTools
//
//  Created by cxh on 16/4/16.
//  Copyright © 2016年 cxh. All rights reserved.
//

#import "PlanbookViewController.h"
//10 以及完成的
//20 正在做的
//30 还没开始的
//40 放弃的


@interface PlanbookViewController ()

@end

@implementation PlanbookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    for(int i = 0; i < 4 ;i++){
        //建立tabelview
        NSScrollView * tableContainer = [[NSScrollView alloc] initWithFrame:NSMakeRect(100*i, 0,100,300 )];
        NSTableView * tableView = [[NSTableView alloc] initWithFrame:NSMakeRect(0, 0, tableContainer.frame.size.width , tableContainer.frame.size.height)];
        tableView.rowHeight = 30;//列高
    
        //初始化一行
        NSTableColumn * column1 = [[NSTableColumn alloc] initWithIdentifier:@"col1"];
    
        [column1 setWidth:tableContainer.frame.size.width-20];//行宽
        column1.headerCell.title = [NSString stringWithFormat:@"%d",i];//行头名称
        [column1 setDataCell:[[NSButtonCell alloc] init]];//设置cell类型
    
        [tableView addTableColumn:column1];
        [tableView setDelegate:self];
        [tableView setDataSource:self];
        [tableView reloadData];
        [tableView setBackgroundColor:[NSColor colorWithSRGBRed:0.1 green:0.93 blue:0.13 alpha:1]];
        [tableContainer setDocumentView:tableView];
    
    
        [tableContainer setHasVerticalScroller:YES];
    
        [self.view addSubview:tableContainer];
    }
}
#pragma NSTableViewDataSource,NSTableViewDelegate---
//返回有几列（必须实现）
- ( NSInteger )numberOfRowsInTableView:( NSTableView *)tableView
{
    return 17;
}


//初始化每行数据（必须实现）
-  ( id )tableView:( NSTableView *)tableView objectValueForTableColumn:( NSTableColumn *)tableColumn row:( NSInteger )row
{
    NSButtonCell* cell =  [tableColumn dataCellForRow:row];
    //    cell.imagePosition = 1;
    //     cell.image = [NSImage imageNamed:@"ftbzui_fazhen"];
    
    NSString* title = @"test";
    //颜色
//    NSInteger buff = [tools_buff_arr[row] intValue];
//    switch (buff) {
//        case 0:
//            [cell setBackgroundColor:[NSColor grayColor]];
//            title = [title stringByAppendingString:@"(不可用)"];
//            break;
//        case 1:
//            [cell setBackgroundColor:[NSColor colorWithSRGBRed:0.1 green:0.93 blue:0.13 alpha:1]];
//            title = [title stringByAppendingString:@"(可用)"];
//            break;
//        case 2:
//            [cell setBackgroundColor:[NSColor yellowColor]];
//            title = [title stringByAppendingString:@"(正在修改)"];
//            break;
//        default:
//            break;
//    }
//    
    [cell setTitle:title];
    return cell;
}

@end
