//
//  HttpTestVC.m
//  SmallTools
//
//  Created by cxh on 17/12/14.
//  Copyright © 2017年 cxh. All rights reserved.
//

#import "HttpTestVC.h"

@interface HttpTestVC ()

@end

@implementation HttpTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.


    
}
- (IBAction)test1:(id)sender {
    // 1.设置请求路径
    NSURL *URL=[NSURL URLWithString:@"http://hbxjspx2017.e.px.teacher.com.cn/home/student/78667/course/updateLearnTime"];//不需要传递参数
    
    //    2.创建请求对象
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];//默认为get请求
    request.timeoutInterval=5.0;//设置请求超时为5秒
    request.HTTPMethod=@"POST";//设置请求方法
    
    //设置请求体
    NSString *param = @"id=50072885&&onceTime=10&inputvalcode=3256&drawerId=791219&validateType=true&token=1513242959494";
    //    NSString *param=[NSString stringWithFormat:@"username=%@&pwd=%@",self.username.text,self.pwd.text];
    //把拼接后的字符串转换为data，设置请求体
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                     completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          if (!error)
                                          {
                                              NSLog(@"回复: %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                              
                                          }
                                          
                                      }];
    // 使用resume方法启动任务
    [dataTask resume];
}

@end
