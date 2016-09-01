//
//  ZHWDBHelper.h
//  CalendarMessage
//
//  Created by 刘斌 on 16/8/27.
//  Copyright © 2016年 lb. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZHWDBModel;
@class FMDatabaseQueue;

@interface ZHWDBHelper : NSObject{
    FMDatabaseQueue *_queue;
}

// 插入模型数据
+ (BOOL)insertAppleId:(NSString *)appleID;

/** 查询数据,如果 传空 默认会查询表中所有数据 */
+ (NSArray *)queryData:(NSString *)querySql;

/** 删除数据,如果 传空 默认会删除表中所有数据 */
+ (BOOL)deleteData:(NSString *)deleteSql;

/** 修改数据 */
+ (BOOL)modifyData:(NSString *)modifySql;

@end
