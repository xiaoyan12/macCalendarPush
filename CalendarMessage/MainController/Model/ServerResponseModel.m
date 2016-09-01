//
//  ServerResponseModel.m
//  CalendarMessage
//
//  Created by 刘斌 on 16/8/29.
//  Copyright © 2016年 lb. All rights reserved.
//

#import "ServerResponseModel.h"
#import "MJExtension.h"

@implementation ServerResponseModel

- (ServerResponseModel *)initWithServerResponse:(NSDictionary *)JSONObject ResultType :(ServerResponseResultType)type ModelClassName:(NSString *)className
{
    self = [super init];
    if (self) {
        NSDictionary *dic = (NSDictionary *)JSONObject;
        NSString *errorMsg = dic[@"errorMsg"];
        if (!errorMsg) {
            //网络可用
            NSInteger errorCode = [dic[@"errorCode"]integerValue];
            NSString *errorMessage = dic[@"errorMessage"];
            if (errorCode == 0) {
                //success
                
                //page
//                NSDictionary *pageDic = dic[@"page"];
//                if (pageDic) {
//                    self.page = [PageModel objectWithKeyValues:pageDic];
//                }else
//                {
//                    self.page = nil;
//                }
                
                //errorCode
//                self.errorCode = ErrorCode_Success;
                //result
                switch (type) {
                    case ServerResponseResultType_NSArray:
                    {
                        NSArray *array = JSONObject[@"result"];
                        NSMutableArray *models = [NSMutableArray array];
                        for ( id dic1 in array) {
                            if ([dic1 isKindOfClass:[NSDictionary class]]) {
                                //是字典
                                Class class = NSClassFromString(className);
                                id model1 = [class objectWithKeyValues:dic1];
                                [models addObject:model1];
                            }else
                            {
                                //不是字典
                                [models addObject:dic1];
                            }
                        }
                        self.result = [models copy];
                        break;
                    }
                    case ServerResponseResultType_NSObject:
                    {
                        NSDictionary *dic = JSONObject[@"result"];
                        if (![dic isKindOfClass:[NSNull class]] && dic) {
                            
                            Class class = NSClassFromString(className);
                            
                            id model = [class objectWithKeyValues:dic];
                            // NSDictionary *dic1 = @{className:model};
                            self.result = model;//dic1;
                        }else
                        {
                            self.result = nil;//@{};
                        }
                        break;
                    }
                    case ServerResponseResultType_NSNumber:
                    {
                        NSInteger value = [JSONObject[@"result"]integerValue];
                        NSNumber *valueNumber = [NSNumber numberWithInteger:value];
                        self.result = valueNumber;
                        
                        break;
                    }
                    case ServerResponseResultType_NSString:
                    {
                        NSString *string = JSONObject[@"result"];
                        self.result = string;
                        
                        break;
                    }
                    case ServerResponseResultType_NSDictionary:
                    {
                        //返回的是字典
                        self.result = JSONObject[@"result"];
                        break;
                    }
                    case ServerResponseResultType_BOOL:
                    {
                        //如果需要返回值是bool  这里封装成NSNumber @1：YES  @2：NO
                        self.result = @([JSONObject[@"result"] boolValue]);
                    }
                    default:
                        break;
                }
            }else
            {
                //failed
//                self.errorCode = ErrorCode_Failed;
                self.errorMessage = errorMessage;
            }
        }else
        {
            //网络不可用
//            self.errorCode = ErrorCode_Failed;
            self.errorMessage = errorMsg;
        }
        
    }
    return self;
}


@end
