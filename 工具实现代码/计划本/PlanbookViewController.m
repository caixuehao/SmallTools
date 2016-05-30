//
//  PlanbookViewController.m
//  SmallTools
//
//  Created by cxh on 16/4/16.
//  Copyright © 2016年 cxh. All rights reserved.
//

#import "PlanbookViewController.h"
#import "smallToolsInfo.h"
//10 以及完成的
//20 正在做的
//30 还没开始的
//40 放弃的
#define planbook_data_path @"Planbook.plist"

@interface PlanbookViewController ()

@end

@implementation PlanbookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataInit];
    
    _now_arr = 0;
    _point.x = -1;
    [_popUpButtonCell selectItemAtIndex:0];//设置下拉按钮的选项
//    _popUpButtonCell.indexOfSelectedItem;//按钮选的哪一个
    
    
    //建立tabelview
        NSScrollView * tableContainer = [[NSScrollView alloc] initWithFrame:NSMakeRect(10, 0,380,250 )];
        NSTableView * tableView = [[NSTableView alloc] initWithFrame:NSMakeRect(0, 0, tableContainer.frame.size.width , tableContainer.frame.size.height)];
        tableView.rowHeight = 30;//列高
    
    //初始化一行
        NSTableColumn * column1 = [[NSTableColumn alloc] initWithIdentifier:@"col1"];
    
        [column1 setWidth:tableContainer.frame.size.width-20];//行宽
        column1.headerCell.title = @"";//行头名称
        [column1.headerCell setAccessibilityHidden:NO];
        [column1 setDataCell:[[NSButtonCell alloc] init]];//设置cell类型
        
        [tableView addTableColumn:column1];
        [tableView setDelegate:self];
        [tableView setDataSource:self];
        [tableView reloadData];
//        [tableView setBackgroundColor:[NSColor colorWithSRGBRed:0.1 green:0.93 blue:0.13 alpha:1]];
        [tableContainer setDocumentView:tableView];
        [tableContainer setHasVerticalScroller:YES];
        [self.view addSubview:tableContainer];
    
        _tableView = tableView;
    
    
 
}









- (IBAction)修改:(id)sender {
    if(_point.x == -1)return;//判断是否选择过元素
    //删除原来的
    NSMutableArray* arr = [_main_dic objectForKey:[NSString stringWithFormat:@"%lu",_point.x]];
    [arr removeObjectAtIndex:_point.y];
    //创建新的
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[_titleTF stringValue] forKey:@"title"];
    [dic setObject:[_desTV string] forKey:@"des"];
    //添加
    arr = [_main_dic objectForKey:[NSString stringWithFormat:@"%lu",_popUpButtonCell.indexOfSelectedItem]];
    if(arr == nil)arr = [[NSMutableArray alloc] init];
    //刷新选择元素的数据
    _point.x = _popUpButtonCell.indexOfSelectedItem;
    _point.y = [arr count];
     [arr insertObject:dic atIndex:0];
    [_main_dic setObject:arr forKey:[NSString stringWithFormat:@"%lu",_popUpButtonCell.indexOfSelectedItem]];
    
    //刷新保存
    [_tableView reloadData];
    [self dataWrite];
    [self dataInit];
    
}

- (IBAction)清空输入:(id)sender {
    _point.x = -1;
    _titleTF.stringValue = @"";
    _desTV.string = @"";
    [_popUpButtonCell selectItemAtIndex:0];
}



- (IBAction)添加:(id)sender {
    if([_titleTF stringValue].length == 0)return;//判断是否添加过元素
    
    
    NSMutableArray* arr = [_main_dic objectForKey:[NSString stringWithFormat:@"%lu",_popUpButtonCell.indexOfSelectedItem]];
    if (arr == nil) {
        arr = [[NSMutableArray alloc] init];
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:@{@"title":[_titleTF stringValue],@"des":[_desTV string]}];
    //刷新选择元素的数据
    _point.x = _popUpButtonCell.indexOfSelectedItem;
    _point.y = [arr count];
    
    [arr insertObject:dic atIndex:0];
    [_main_dic setObject:arr forKey:[NSString stringWithFormat:@"%lu",_popUpButtonCell.indexOfSelectedItem]];
    //刷新保存
    [_tableView reloadData];
    [self dataWrite];
    [self dataInit];
}


- (IBAction)删除:(id)sender {
    if(_point.x == -1)return;//判断是否选择过元素
    if(_point.x != _now_arr)return;//防止误删
    
    //删除
    NSMutableArray* arr = [_main_dic objectForKey:[NSString stringWithFormat:@"%lu",_point.x]];
    [arr removeObjectAtIndex:_point.y];
    [_main_dic setObject:arr forKey:[NSString stringWithFormat:@"%lu",_point.x]];
    //刷新保存
    [_tableView reloadData];
    [self dataWrite];
    [self dataInit];
    //刷新选择元素的数据
    _point.x = -1;
    _titleTF.stringValue = @"";
    _desTV.string = @"";
}

//切换列表
- (IBAction)test:(id)sender {
    if (_now_arr == _segmentedCell.selectedSegment) return;
   
    _now_arr = _segmentedCell.selectedSegment;
    
    [_tableView reloadData];
}

#pragma 数据读写处理－－
//数据写入
- (void)dataWrite{
    NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:Main_Path];
    NSString* BundleName = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleName"];
    path =[path stringByAppendingPathComponent: BundleName];
    path = [path stringByAppendingPathComponent:planbook_data_path];
    [_main_dic writeToFile:path atomically:YES];
}
//初始化数据
- (void)dataInit{
    
    NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:Main_Path];
    NSString* BundleName = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleName"];
    path =[path stringByAppendingPathComponent: BundleName];
    
    //检查 创建 文件夹
    BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    if (bo==NO) {
        NSLog(@"创建目录失败");
    }
    //end
    path = [path stringByAppendingPathComponent:planbook_data_path];
    
    _main_dic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    if (_main_dic == nil) {
        _main_dic = [[NSMutableDictionary alloc] init];
    }
    
}



#pragma NSTableViewDataSource,NSTableViewDelegate---
//返回有几列（必须实现）
- ( NSInteger )numberOfRowsInTableView:( NSTableView *)tableView
{
    NSMutableArray* arr = [_main_dic objectForKey:[NSString stringWithFormat:@"%lu",_now_arr]];
    if (arr == nil) {
        arr = [[NSMutableArray alloc] init];
    }
    return arr.count;
}


//初始化每行数据（必须实现）
-  ( id )tableView:( NSTableView *)tableView objectValueForTableColumn:( NSTableColumn *)tableColumn row:( NSInteger )row
{
     NSMutableArray* arr = [_main_dic objectForKey:[NSString stringWithFormat:@"%lu",_now_arr]];
    NSMutableDictionary* dic = arr[row];
    
    NSButtonCell* cell =  [tableColumn dataCellForRow:row];
    NSString* title = [dic objectForKey:@"title"];
    switch (_now_arr) {
        case 0:
            [cell setBackgroundColor:[NSColor redColor]];;
            break;
        case 1:
             [cell setBackgroundColor:[NSColor yellowColor]];
            break;
        case 2:
            [cell setBackgroundColor:[NSColor colorWithSRGBRed:0.1 green:0.93 blue:0.13 alpha:1]];
            break;
        case 3:
            [cell setBackgroundColor:[NSColor grayColor]];;
            break;
        default:
            break;
    }
    
    [cell setTitle:title];
    return cell;
}
//操作cell调用
-( void )tableView:( NSTableView *)tableView setObjectValue:( id )object forTableColumn:( NSTableColumn *)tableColumn row:( NSInteger )row
{
        _point.x = _now_arr;
        _point.y =  row;
        NSMutableArray* arr = [_main_dic objectForKey:[NSString stringWithFormat:@"%lu",_now_arr]];
        NSMutableDictionary* dic = arr[row];
        _titleTF.stringValue = [dic objectForKey:@"title"];
        _desTV.string = [dic objectForKey:@"des"];
        [_popUpButtonCell selectItemAtIndex:_now_arr];//设置下拉按钮的选项
}
@end
