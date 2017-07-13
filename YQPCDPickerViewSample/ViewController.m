//
//  ViewController.m
//  YQPCDPickerViewSample
//
//  Created by OSX on 17/7/13.
//  Copyright © 2017年 OSX. All rights reserved.
//

#import "ViewController.h"
#import "YQPCDView.h"

//界面宽高
#define YQScreenHeight [UIScreen mainScreen].bounds.size.height
#define YQScreenWidth [UIScreen mainScreen].bounds.size.width
//界面宽高比例（参数以UI效果图来修改）
#define YQSH YQScreenHeight / 667
#define YQSW YQScreenWidth / 375

@interface ViewController ()<YQPCDViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"展开" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, YQSW * 100, YQSH * 35);
    button.center = CGPointMake(YQScreenWidth / 2, YQScreenHeight / 3);
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
}

- (void)click {
    [[YQPCDView sharedInstance]createPCDViewAddTo:self.view];
    [YQPCDView sharedInstance].delegate = self;
}

#pragma nark - YQPCDViewDelegate
- (void)doneBackForProvince:(NSString *)province city:(NSString *)city district:(NSString *)district {
    NSLog(@"%@---%@---%@",province,city,district);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
