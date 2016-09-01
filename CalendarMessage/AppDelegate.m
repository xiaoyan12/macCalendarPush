//
//  AppDelegate.m
//  CalendarMessage
//
//  Created by lb on 16/8/25.
//  Copyright © 2016年 lb. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"


@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    MainViewController *mainVC = [[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
    mainVC.view.frame = self.window.contentView.frame;
    [self.window.contentView addSubview:mainVC.view];
    
}



- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
