//
//  leftTableViewController.m
//  SmallTools
//
//  Created by cxh on 16/3/29.
//  Copyright © 2016年 cxh. All rights reserved.
//

#import "leftTableViewController.h"
#import "smallToolsInfo.h"

@interface leftTableViewController ()

@end

@implementation leftTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tools_arr = TOOLS_ARR;
    tools_buff_arr = TOOLS_BUFF_ARR;
    
    //建立tabelview
    NSScrollView * tableContainer = [[NSScrollView alloc] initWithFrame:NSMakeRect(10, 10, leftTableViewController_MaxWidth-20, TopViewController_MaxHight+bottomViewController_MaxHight-20)];
    NSTableView * tableView = [[NSTableView alloc] initWithFrame:NSMakeRect(0, 0, tableContainer.frame.size.width , tableContainer.frame.size.height)];
    tableView.rowHeight = 50;//列高
    
    //初始化一行
    NSTableColumn * column1 = [[NSTableColumn alloc] initWithIdentifier:@"col1"];
    
    [column1 setWidth:tableContainer.frame.size.width-20];//行宽
    column1.headerCell.title = @"工具名称";//行头名称
    [column1 setDataCell:[[NSButtonCell alloc] init]];//设置cell类型
    
    [tableView addTableColumn:column1];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView reloadData];
    
    [tableContainer setDocumentView:tableView];
    
    
    [tableContainer setHasVerticalScroller:YES];
    
    [self.view addSubview:tableContainer];
}


#pragma NSTableViewDataSource,NSTableViewDelegate---
//返回有几列（必须实现）
- ( NSInteger )numberOfRowsInTableView:( NSTableView *)tableView
{
    return tools_arr.count;
}


//初始化每行数据（必须实现）
-  ( id )tableView:( NSTableView *)tableView objectValueForTableColumn:( NSTableColumn *)tableColumn row:( NSInteger )row
{
    NSButtonCell* cell =  [tableColumn dataCellForRow:row];
//    cell.imagePosition = 1;
//     cell.image = [NSImage imageNamed:@"ftbzui_fazhen"];
    
    NSString* title = tools_arr[row];
    //颜色
    NSInteger buff = [tools_buff_arr[row] intValue];
    switch (buff) {
        case 0:
            [cell setBackgroundColor:[NSColor grayColor]];
            title = [title stringByAppendingString:@"(不可用)"];
            break;
        case 1:
            [cell setBackgroundColor:[NSColor colorWithSRGBRed:0.1 green:0.93 blue:0.13 alpha:1]];
            title = [title stringByAppendingString:@"(可用)"];
            break;
        case 2:
            [cell setBackgroundColor:[NSColor yellowColor]];
            title = [title stringByAppendingString:@"(正在修改)"];
            break;
        default:
            break;
    }
    
    [cell setTitle:title];
    return cell;
}

//显示数据(如果用这个来设置数据，上面那个可以返回nil)
- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
//    NSButtonCell* btncell = cell;
//    [btncell setTitle:tools_arr[row]];
}


//操作cell调用
-( void )tableView:( NSTableView *)tableView setObjectValue:( id )object forTableColumn:( NSTableColumn *)tableColumn row:( NSInteger )row
{
    NSLog(@"%@",tools_arr[row]);
    //创建通知并发送
    NSDictionary* dic = @{@"row":@(row)};
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"changeTool" object:nil userInfo:dic];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
   
}

@end
