//
//  MainViewController.m
//  CalendarMessage
//
//  Created by lb on 16/8/29.
//  Copyright © 2016年 lb. All rights reserved.
//

#import "MainViewController.h"
#import "ZHWNetwork.h"

@interface MainViewController ()
@property (weak) IBOutlet NSTextField *label;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    //开始监听请求
    [[ZHWNetwork shareInstance]startRequestLoop];

}

@end
