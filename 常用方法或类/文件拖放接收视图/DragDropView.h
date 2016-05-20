//
//  DragDropView.h
//  DragAndDrop
//
//  Created by chenghxc on 13-2-25.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//
//http://download.csdn.net/detail/chenghxc/5085837
#import <Cocoa/Cocoa.h>
@protocol DragDropViewDelegate;

@interface DragDropView : NSView
@property (assign,nonatomic) id<DragDropViewDelegate> delegate;
@property (assign,nonatomic) NSInteger ddv_tag;
@end

@protocol DragDropViewDelegate <NSObject>
-(void)dragDropViewFileList:(NSArray*)fileList sender:(DragDropView*)sender;


@end