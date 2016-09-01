//
//  ZHWDBHelper.m
//  CalendarMessage
//
//  Created by 刘斌 on 16/8/27.
//  Copyright © 2016年 lb. All rights reserved.
//

#import "ZHWDBHelper.h"
#import "FMDB.h"

#define kSQLITE_NAME @"appleIDs.sqlite"
#define kTABLE_NAME  @"t_appleIDs"

@implementation ZHWDBHelper

static FMDatabase *_fmdb;

+ (void)initialize {
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:kSQLITE_NAME];
    
    _fmdb = [FMDatabase databaseWithPath:filePath];
    
    [_fmdb open];
    
    [_fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS t_appleIDs(id INTEGER PRIMARY KEY, appleID TEXT NOT NULL);"];

}

+ (BOOL)insertAppleId:(NSString *)appleID {
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@(appleID) VALUES ('%@');",kTABLE_NAME, appleID];
    return [_fmdb executeUpdate:insertSql];
}

+ (NSArray *)queryData:(NSString *)querySql {
    
    if (querySql == nil) {
        querySql = [NSString stringWithFormat:@"SELECT * FROM %@",kTABLE_NAME];
    }
    
    NSMutableArray *arrM = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *appleID = [set stringForColumn:@"appleID"];
        
        [arrM addObject:appleID];
    }
    return arrM;
}

+ (BOOL)deleteData:(NSString *)deleteSql {
    
    if (deleteSql == nil) {
        deleteSql = [NSString stringWithFormat:@"DELETE FROM %@",kTABLE_NAME];
    }
    
    return [_fmdb executeUpdate:deleteSql];
    
}


+ (BOOL)modifyData:(NSString *)modifySql{
    
    return YES;
}

@end
