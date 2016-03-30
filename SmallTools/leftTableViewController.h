//
//  leftTableViewController.h
//  SmallTools
//
//  Created by cxh on 16/3/29.
//  Copyright © 2016年 cxh. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface leftTableViewController : NSViewController<NSTableViewDataSource,NSTableViewDelegate>{
    NSArray* tools_arr;
    NSArray* tools_buff_arr;
}

@end
