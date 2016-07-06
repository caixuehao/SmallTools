//
//  samllTools2ViewController.m
//  SmallTools
//
//  Created by cxh on 16/6/17.
//  Copyright © 2016年 cxh. All rights reserved.
//

#import "samllTools2ViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface samllTools2ViewController ()

@end

@implementation samllTools2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}
- (IBAction)btn:(id)sender {
    _tf.stringValue = [self md5:_tv.string];
}


//md5加密
- (NSString *)md5:(NSString *)str
{
    const char *original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}


@end
