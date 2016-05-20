//
//  appIconViewController.h
//  SmallTools
//
//  Created by cxh on 16/5/18.
//  Copyright © 2016年 cxh. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DragDropView.h"

@interface appIconViewController : NSViewController<DragDropViewDelegate>


@property(nonatomic,strong)NSMutableArray* icon_arr;//图标地址数组

@property(nonatomic,strong)NSString* xcassets_path;//xcassetsd地址

@property(nonatomic,strong)NSString* maxSize_icon;//最大的图标，用来合成其它图片

@property (unsafe_unretained) IBOutlet NSTextView *logTV;

@property(nonatomic,strong)NSButton* btn1;

@property(nonatomic,strong)NSButton* btn2;

@property(nonatomic,strong)DragDropView* ddv1;

@property(nonatomic,strong)DragDropView* ddv2;
@end
