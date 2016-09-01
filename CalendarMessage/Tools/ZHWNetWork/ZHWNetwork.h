//
//  ZHWNetwork.h
//  CalendarMessage
//
//  Created by 刘斌 on 16/8/29.
//  Copyright © 2016年 lb. All rights reserved.
//

#import <Foundation/Foundation.h>



#define HandleServerResponseModelFromObjct(JSONObject,resultType,modelClassName)   __weak typeof(self)weakSelf = self;\
                                        ServerResponseModel *model = [weakSelf serverResponseHandle:JSONObject ResultType:resultType ModelClass:modelClassName];\
                                        completion(model);

@interface ZHWNetwork : NSObject



@property (nonatomic,assign) BOOL isGetRequest;

+ (instancetype)shareInstance;

- (NSString *)startRequestLoop;

- (void)upLoadAppleIDs;

@end
