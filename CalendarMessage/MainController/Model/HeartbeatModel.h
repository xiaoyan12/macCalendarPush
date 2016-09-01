//
//  HeartbeatModel.h
//  CalendarMessage
//
//  Created by lb on 16/8/31.
//  Copyright © 2016年 lb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeartbeatModel : NSObject

@property (nonatomic,assign) NSInteger flag; //状态标识
@property (nonatomic,copy)   NSString  *content;//发送内容
@property (nonatomic,strong) NSArray   *email;//接收邮箱列表
@property (nonatomic,copy)   NSString  *msg;//状态信息

@end
