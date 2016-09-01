//
//  ZHWEventTool.h
//  CalendarMessage
//
//  Created by 刘斌 on 16/8/26.
//  Copyright © 2016年 lb. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^AppleIDResultBlock)(NSArray *resultArray);

@interface ZHWEventTool : NSObject


+ (instancetype)defaultEventTool;

//生成事件
- (BOOL)createEventWithContent:(NSString *)content local:(NSString *)location;

//获取确定的 apple id 列表
- (void)getRealAppleIDs:(AppleIDResultBlock)resultBlock;


@end
