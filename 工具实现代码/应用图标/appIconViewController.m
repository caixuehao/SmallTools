
//1.先会使用拖文件的那个控件。实在不行，可以用手动的或者其他的。
//2.获取图片大小。
//3.分析app icon的文件，进行写入。


#import "appIconViewController.h"

@interface appIconViewController ()

@end

@implementation appIconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    
    _ddv1 = [[DragDropView alloc] initWithFrame:NSMakeRect(40 , 220, 140, 140)];
    _ddv1.delegate = self;
    _ddv1.ddv_tag = 1;
    [_ddv1 setWantsLayer:YES];
    [_ddv1.layer setBackgroundColor:[[NSColor yellowColor] CGColor]];
    _btn1 = [[NSButton alloc] initWithFrame:NSMakeRect(10, 10, 120, 120)];
    [[_btn1 cell] setImageScaling:NSImageScaleAxesIndependently];//图片按照大小伸缩。
    [_btn1 setTitle:@"拖图标进来"];
    [_ddv1 addSubview:_btn1];

    [self.view addSubview:_ddv1];
    
    
    
    _ddv2 = [[DragDropView alloc] initWithFrame:NSMakeRect(220 , 220, 140, 140)];
    _ddv2.delegate = self;
    _ddv2.ddv_tag = 2;
    [_ddv2 setWantsLayer:YES];
    [_ddv2.layer setBackgroundColor:[[NSColor blueColor] CGColor]];
    _btn2 = [[NSButton alloc] initWithFrame:NSMakeRect(10, 10, 120, 120)];
    [[_btn2 cell] setImageScaling:NSImageScaleAxesIndependently];//图片按照大小伸缩。
    [_btn2 setTitle:@"拖.xcassets进来"];
    [_ddv2 addSubview:_btn2];
    [self.view addSubview:_ddv2];
    
    
    
    
}
- (IBAction)确定:(id)sender {

  

    
    if(_icon_arr.count > 0&& _xcassets_path != NULL){
        //先创建文件夹
        NSString* main_path = [self xcassets_path_chuli];
        if(main_path.length == 0)return;
        
        NSString* jsontext;
        if(_popUpbtn.indexOfSelectedItem == 0){
          jsontext = @"iphone模版Contents";
        }else if(_popUpbtn.indexOfSelectedItem == 1){
            jsontext = @"iphone(xcode8)模版Contents";
        }else if(_popUpbtn.indexOfSelectedItem == 2){
          jsontext = @"mac模版Contents";
        }
      
        
        //模版json（因为oc数据是“假循环”所以搞两个字典）
        NSString* path = [[NSBundle mainBundle] pathForResource:jsontext ofType:@"json"];
        NSMutableDictionary* Template_json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableContainers error:nil];
    
        NSMutableArray* images = [[NSMutableArray alloc] init];
        NSMutableDictionary* Contents_json = [[NSMutableDictionary alloc] initWithDictionary:@{@"images":images,
                                                                                            @"info":@{@"version": @1,@"author" : @"xcode"}}];
        
        
        
        for(NSDictionary* dic in [Template_json objectForKey:@"images"]){
            NSMutableDictionary* new_dic = [[NSMutableDictionary alloc] initWithDictionary:dic];
            
            //获取需要的图片大小
            float size = [self getIconSize:dic];
            //查看是否有该图片
            NSString* icon_path = [self getIconPath_For_size:size];
            NSString* new_icon_path = @"";//复制的名字是 尺寸.png 生成的是 _尺寸.png
            
            
            if(icon_path.length > 0){
                //如果有，复制图片。
                new_icon_path = [main_path stringByAppendingPathComponent:[NSString stringWithFormat:@"%0.0f.png",size]];
                [new_dic setValue:[new_icon_path lastPathComponent] forKey:@"filename"];
                [[NSFileManager defaultManager]copyItemAtPath:icon_path  toPath:new_icon_path error:nil];
                
            }else{
                //如果没有，合成图片。
                if( _btn1.image.size.height > size){//判断是否可以合成
                    new_icon_path = [main_path stringByAppendingPathComponent:[NSString stringWithFormat:@"_%0.0f.png",size]];
                    [new_dic setValue:[new_icon_path lastPathComponent] forKey:@"filename"];
                    NSImage* image = [[NSImage alloc] initWithContentsOfFile:_maxSize_icon];//拷贝一下
                    [image setSize:NSMakeSize(size, size)];
                    [self saveImage:image path:new_icon_path];
                }
            }
            
            [images addObject:new_dic];
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Contents_json
                                                               options:NSJSONWritingPrettyPrinted
                                                                 error:nil];
            [jsonData writeToFile:[main_path stringByAppendingPathComponent:@"Contents.json"] atomically:YES];
        }
        
    }
}



#pragma 最后合成的逻辑代码
//根据传进来的字典获取，要合成的图片大小
-(float)getIconSize:(NSDictionary*)dic{
    if (dic) {
        NSString * size = [dic objectForKey:@"size"];
        NSString * scale  = [dic objectForKey:@"scale"];
        if (size&&scale) {
            //读取size scale
            float size_f = [[size substringToIndex:size.length/2] floatValue];
            float scale_f = [[scale substringToIndex:scale.length -1] floatValue];
//            NSLog(@"%f,%f",size_f,scale_f);
            return size_f*scale_f;
        }
    }
    return 0;
}


//合成文件夹名，生成文件夹
-(NSString*)xcassets_path_chuli{
    //获取子文件
    NSFileManager * fm = [NSFileManager defaultManager];
    NSArray * array = [fm contentsOfDirectoryAtPath:_xcassets_path  error:nil];
    
    
    for (int i = 0; i < array.count+1; i++) {
        //合成文件夹名
        NSString* path = @"";
        if (i == 0) {
             path = @"AppIcon.appiconset";
        }else{
            path = [NSString stringWithFormat:@"AppIcon-%d.appiconset",i];
        }
       
        //查看是否重复
        BOOL bl = YES;
        for (NSString* str in array) {
            if ([path isEqualToString:str]) {
                bl = NO;
            }
        }
        //创建文件夹
        if (bl == YES) {
            path = [_xcassets_path stringByAppendingPathComponent:path];
            BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
            if (bo==NO) {
               [self log:@"创建文件夹失败"];
                return @"";
            }
            return path;
        }
        
    }
    
    return @"";
}

//查看又没对应尺寸的图片
- (NSString*)getIconPath_For_size:(float)f{
    for (NSDictionary* dic in _icon_arr) {
        if ([[dic objectForKey:@"size"] floatValue] == f){
            return  [dic objectForKey:@"path"];
        }
    }
    return @"";
}
//储存图片
- (void)saveImage:(NSImage *)image path:(NSString*)path
{
    [image lockFocus];
    //先设置 下面一个实例
    NSBitmapImageRep *bits = [[NSBitmapImageRep alloc]initWithFocusedViewRect:NSMakeRect(0, 0, image.size.width, image.size.height)];
    [image unlockFocus];

    //再设置后面要用到得props属性
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:@YES forKey:NSImageInterlaced];
    
    //之后 转化为NSData 以便存到文件中
    NSData *imageData = [bits representationUsingType:NSPNGFileType properties:imageProps];
    
    //设定好文件路径后进行存储就ok了
    [imageData writeToFile:path atomically:YES];
    
}
#pragma  end


//添加打印
-(void)log:(NSString*)str{
    NSLog(@"%@",str);
    _logTV.string =  [NSString stringWithFormat:@"%@%@\n", _logTV.string,str];
}

#pragma DragDropViewDelegate---
//获取的所有文件地址
-(void)dragDropViewFileList:(NSArray *)fileList sender:(DragDropView*)sender{
    //如果数组不存在或为空直接返回不做处理（这种方法应该被广泛的使用，在进行数据处理前应该现判断是否为空。）
    if(!fileList || [fileList count] <= 0)return;
    
    if (sender.ddv_tag == 1) {
        _icon_arr = [[NSMutableArray alloc] init];
        
     //图标文件
         NSFileManager * fm = [NSFileManager defaultManager];
        if(fileList.count == 1){
            
            
            
            //如果等于1，判断是图标文件夹，还是单个图标。
            BOOL isDir;
            
            if ([fm fileExistsAtPath:fileList[0] isDirectory:&isDir] && isDir) {
                //文件夹获取子文件筛选出合格的图片
                NSArray * array = [fm contentsOfDirectoryAtPath:fileList[0]  error:nil];
                for (NSString* str in array) {
                    NSString* path = [fileList[0]  stringByAppendingPathComponent:str];
                    float f = [self censorIcon:path];
                    if (f) {
                        [_icon_arr addObject:@{@"path":path,@"size":@(f)}];
                    }
                }
                if (_icon_arr.count == 0)return;
                    
                
                //选出最大的图片当按钮图
                float f = 0;
                NSString* btn_image_path = @"";
                for (NSDictionary* dic in _icon_arr) {
                    if ([[dic objectForKey:@"size"] floatValue] > f){
                        f = [[dic objectForKey:@"size"] floatValue];
                        btn_image_path = [dic objectForKey:@"path"];
                    }
                }
                _maxSize_icon = btn_image_path;
                [_btn1 setImage:[[NSImage alloc ] initWithContentsOfFile:btn_image_path]];
                
                NSInteger minIconSize = 180;
                if(_popUpbtn.indexOfSelectedItem == 0){
                    minIconSize = 180;
                }else if(_popUpbtn.indexOfSelectedItem == 1){
                     minIconSize = 180;
                }else if(_popUpbtn.indexOfSelectedItem == 2){
                    minIconSize = 1024;
                }
                if(f<minIconSize){
                    [_btn1 setTitle:[NSString stringWithFormat:@"至少得有个%lu的图标吧",minIconSize]];
                    [self log:[NSString stringWithFormat:@"至少得有个%lu的图标吧,要不无法合成一些尺寸的图标",minIconSize]];
                    [_ddv1.layer setBackgroundColor:[[NSColor orangeColor] CGColor]];
                }else{
                    [_btn1 setTitle:@""];
                    [_ddv1.layer setBackgroundColor:[[NSColor greenColor] CGColor]];
                }
                
            }else{
                //单个文件
                //先判断和不和法
                float f = [self censorIcon:fileList[0]];
                if (f) {
                    [_icon_arr addObject:@{@"path":fileList[0],@"size":@(f)}];
                    
                    NSImage* image= [[NSImage alloc] initWithContentsOfFile:fileList[0]];
                    [_btn1 setImage:image];
                    _maxSize_icon = fileList[0];
                    NSInteger minIconSize = 180;
                    if(_popUpbtn.indexOfSelectedItem == 0){
                        minIconSize = 180;
                    }else if(_popUpbtn.indexOfSelectedItem == 1){
                        minIconSize = 1024;
                    }
                    if(f<minIconSize){
                        [_btn1 setTitle:[NSString stringWithFormat:@"至少得有个%lu的图标吧",minIconSize]];
                        [self log:[NSString stringWithFormat:@"至少得有个%lu的图标吧,要不无法合成一些尺寸的图标",minIconSize]];
                        [_ddv1.layer setBackgroundColor:[[NSColor orangeColor] CGColor]];
                    }else{
                        [_btn1 setTitle:@""];
                        [_ddv1.layer setBackgroundColor:[[NSColor greenColor] CGColor]];
                    }
                }
            
            }
            
            
        }else{
            //多个文件（和文件夹处理的差不多，代码直接复制上面的）
            for (NSString* str in fileList) {
                float f = [self censorIcon:str];
                if (f) {
                    [_icon_arr addObject:@{@"path":str,@"size":@(f)}];
                }
            }
            if (_icon_arr.count == 0)return;
            
            
            //选出最大的图片当按钮图
            float f = 0;
            NSString* btn_image_path = @"";
            for (NSDictionary* dic in _icon_arr) {
                if ([[dic objectForKey:@"size"] floatValue] > f){
                    f = [[dic objectForKey:@"size"] floatValue];
                    btn_image_path = [dic objectForKey:@"path"];
                }
            }
            _maxSize_icon = btn_image_path;
            [_btn1 setImage:[[NSImage alloc ] initWithContentsOfFile:btn_image_path]];
            
            if(f<180){
                [_btn1 setTitle:@"至少得有个180的图标吧"];
                [self log:@"至少得有个180的图标吧,要不无法合成一些尺寸的图标"];
                NSAlert *alert = [NSAlert alertWithMessageText:@"图片太小" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"至少得有个180的图标吧,要不无法合成一些尺寸的图标"];
                [alert runModal];
                [_ddv1.layer setBackgroundColor:[[NSColor orangeColor] CGColor]];
            }else{
                [_btn1 setTitle:@""];
                [_ddv1.layer setBackgroundColor:[[NSColor greenColor] CGColor]];
            }
        
        
        }
        
        
        
    }else if(sender.ddv_tag == 2){
        //.xcassets工程文件
        if(fileList.count == 1){
            NSString* houZui = [fileList[0] lastPathComponent];
            houZui = [houZui substringFromIndex:houZui.length-9];
            if ([houZui isEqualToString:@".xcassets"]) {
                _xcassets_path = fileList[0];
                [_btn2 setTitle:[_xcassets_path lastPathComponent]];
                [_ddv2.layer setBackgroundColor:[[NSColor greenColor] CGColor]];
            }
        }
    }
    
}
#pragma 检查图片是否合格
-(float)censorIcon:(NSString*)path{
    //默认检查过是否是文件夹了，就不检查了
    //文件比较小，先不考虑效率了
    //先检查后缀名
    NSString* houZui = [path lastPathComponent];
    houZui = [houZui substringFromIndex:houZui.length-4];
    //||[houZui isEqualToString:@".jpg"
    if ([houZui isEqualToString:@".png"]) {
        NSImage* image= [[NSImage alloc] initWithData:[NSData dataWithContentsOfFile:path]];
        if (image) {
            //判断长宽是否相等
            if(image.size.height == image.size.width){
                //判断是否符合大小
                if (image.size.height>=29) {
                    NSLog(@"%f",image.size.height);
                    return image.size.height;
                }
            }
        }
        
    }
    return 0;
}

@end
