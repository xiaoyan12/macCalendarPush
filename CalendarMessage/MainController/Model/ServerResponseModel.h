//
//  ServerResponseModel.h
//  CalendarMessage
//
//  Created by 刘斌 on 16/8/29.
//  Copyright © 2016年 lb. All rights reserved.
//
//  后台返回json解析后的数据模型

#import <Foundation/Foundation.h>

/**
 *  服务器返回的字典中result类型：数组、字典、整形
 */
typedef NS_ENUM(NSUInteger, ServerResponseResultType){
    //数组
    ServerResponseResultType_NSArray,
    
    //字典
    ServerResponseResultType_NSDictionary,
    
    //数字
    ServerResponseResultType_NSNumber,
    
    //字符串
    ServerResponseResultType_NSString,
    
    //对象
    ServerResponseResultType_NSObject,
    
    //bool值 如果需要返回值是bool  这里封装成NSNumber @1：YES  @2：NO
    ServerResponseResultType_BOOL
};


@interface ServerResponseModel : NSObject

//@property (nonatomic, assign) ErrorCode errorCode;//0:表示网络请求成功，直接去result中取值  非0：表示失败，直接显示errorMessage提示信息
@property (nonatomic, copy) NSString * errorMessage;//网络请求返回信息
@property (nonatomic, strong) id result;//后台返回的result数据，可能是数组、model对象、nsnumber、nsstring
//@property (nonatomic, strong)PageModel *page;//分页（如果没有用到，则该值为nil）

- (ServerResponseModel *)initWithServerResponse:(NSDictionary *)JSONObject ResultType :(ServerResponseResultType)type ModelClassName:(NSString *)className;

@end



