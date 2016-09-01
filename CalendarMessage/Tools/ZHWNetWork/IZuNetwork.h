//
//  IZuNetwork.h
//  CalendarMessage
//
//  Created by 刘斌 on 16/8/29.
//  Copyright © 2016年 lb. All rights reserved.
//
//  接口列表

#import <Foundation/Foundation.h>

@protocol IZuNetwork <NSObject>

- (void)keepRequestLoopWithCompletion:(void(^)(id JSONObject))completion;

@end
