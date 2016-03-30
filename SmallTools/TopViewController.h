//
//  TopViewController.h
//  SmallTools
//
//  Created by cxh on 16/3/29.
//  Copyright © 2016年 cxh. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TopViewController : NSViewController{
    NSArray* tools_ps_arr;
}
@property (unsafe_unretained) IBOutlet NSTextView *toolPsTextView;


@end
