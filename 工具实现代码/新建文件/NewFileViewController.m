//
//  NewFileViewController.m
//  SmallTools
//
//  Created by cxh on 17/4/10.
//  Copyright © 2017年 cxh. All rights reserved.
//

#import "NewFileViewController.h"

@interface NewFileViewController ()
@property (weak) IBOutlet NSTextField *fileNameTF;
@property (weak) IBOutlet NSTextField *fileTypeTF;

@end

@implementation NewFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (IBAction)startNewFile:(id)sender {
    [[NSFileManager defaultManager] createFileAtPath:[self getFilePath] contents:nil attributes:nil];
}
/**
 *  返回文件路径
 *
 *  @return 文件路径
 */
-(NSString*)getFilePath{
    
    NSString* desktopPath = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES)[0];
    NSArray<NSString *>* desktopFileArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:desktopPath  error:nil];
    
    
    for (int i = 0; i<desktopFileArr.count; i++) {
        NSString* fileName = @"";
        NSString* fileNameTFStr = _fileNameTF.stringValue.length?_fileNameTF.stringValue:_fileNameTF.placeholderString;
        NSString* fileTypeTFStr = _fileTypeTF.stringValue.length?_fileTypeTF.stringValue:_fileTypeTF.placeholderString;
        if (i == 0) {
            fileName = [NSString stringWithFormat:@"%@.%@",fileNameTFStr,fileTypeTFStr];
        }else{
            fileName = [NSString stringWithFormat:@"%@(%d).%@",fileNameTFStr,i,fileTypeTFStr];
        }
        
        BOOL isRepetition = NO;
        for (NSString* str in desktopFileArr) {
            if ([fileName isEqualToString:str]) {
                isRepetition = YES;break;
            }
        }
        
        if (isRepetition == NO) {
            return [desktopPath stringByAppendingPathComponent:fileName];
        }
        
    }
    return @"";
}

@end
