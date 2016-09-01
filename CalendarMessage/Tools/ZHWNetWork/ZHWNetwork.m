//
//  ZHWNetwork.m
//  CalendarMessage
//
//  Created by 刘斌 on 16/8/29.
//  Copyright © 2016年 lb. All rights reserved.
//

#import "ZHWNetwork.h"
#import "AFNetworking.h"
#import "ServerResponseModel.h"
#import "ZHWEventTool.h"
#import "HeartbeatModel.h"


static NSInteger const kRequestTimeIntervalSecond = 40;//循环请求间隔
static NSInteger const kRequestTimeOutSecond      = 15;//超时
static AFHTTPSessionManager *manager = nil;


@implementation ZHWNetwork{
    NSString *statusString;
}

+ (instancetype)shareInstance{
    __strong static ZHWNetwork *netWork = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netWork = [[ZHWNetwork alloc] init];
    });
    return netWork;
}

- (instancetype)init{
    if (self = [super init]) {
        manager = [[AFHTTPSessionManager alloc]init];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = kRequestTimeOutSecond;
    }
    return self;
}

- (void)requestData:(NSString *)path params:(NSDictionary *)params completion:(void (^)(id JSONObject))completion {
    if (_isGetRequest) {
        [manager GET:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (task.response.expectedContentLength) {
                NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
                id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if (completion) {
                    completion(result);
                }
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (completion) {
                completion(@{@"errorMsg":error.localizedDescription});
            }
        }];
    }
    else{
        [manager POST:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (task.response.expectedContentLength) {
                NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
                id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if (completion) {
                    completion(result);
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (completion) {
                completion(@{@"errorMsg":error.localizedDescription});
            }
        }];
    }
    
}

//复制
- (void)_pasteString:(NSString *)string{
    NSPasteboard *paste = [NSPasteboard generalPasteboard];
    [paste clearContents];
    [paste declareTypes:[NSArray arrayWithObject:NSStringPboardType]owner:self];
    [paste setString:string forType:@"NSStringPboardType"];
}

//设置applescript脚本
-(void)setUpTheAppleScript:(NSString *)scriptName{
    NSTask *task = nil;
    
    NSString *scriptPath = [[NSBundle mainBundle]pathForResource:scriptName ofType:@"scpt"];
    if (scriptPath)
    {
        NSArray *a = [NSArray arrayWithObjects:scriptPath,  nil];
        task = [NSTask launchedTaskWithLaunchPath:@"/usr/bin/osascript" arguments:a];
    }
}


- (ServerResponseModel *)serverResponseHandle:(NSDictionary *)JSONObject ResultType:(ServerResponseResultType)type ModelClass:(NSString *)className{
    return [[ServerResponseModel alloc]initWithServerResponse:JSONObject ResultType:type ModelClassName:className];
}

//开始循环请求
- (NSString *)startRequestLoop{
    [NSTimer scheduledTimerWithTimeInterval:kRequestTimeIntervalSecond target:self selector:@selector(_RequestLoop) userInfo:nil repeats:YES];
    return statusString;
}


- (void)_RequestLoop{
    [self keepRequestLoop];
}

- (void)upLoadAppleIDs{
    //上传结果
    __weak typeof(self )weakSelf = self;
    [[ZHWEventTool defaultEventTool]getRealAppleIDs:^(NSArray *resultArray) {
        NSLog(@"%@",resultArray);
            // upload
        [weakSelf requestData:@"http://www.zuhaowan.com/ClientApi/IOS/getResult" params:@{@"appleId":resultArray} completion:^(id JSONObject) {
            
        }];
    }];

}

//粘贴板 邮箱处理
- (NSString *)_getPasteString:(NSArray *)array{
    NSMutableString *pasteStr = [NSMutableString string];
    for (int i = 0; i < array.count; i++) {
        [pasteStr appendString:[NSString stringWithFormat:@",%@",array[i]]];
    }
    if ([pasteStr hasPrefix:@","]) {
        NSString *relust = [pasteStr substringFromIndex:1];
        return relust;
    }
    return pasteStr;
}


#pragma mark - 接口解析
//保持长连接接口
- (void)keepRequestLoop{
    [self requestData:@"http://www.zuhaowan.com/ClientApi/IOS/keeplived" params:nil completion:^(id JSONObject) {
        HeartbeatModel *result = [HeartbeatModel objectWithKeyValues:JSONObject];
        NSLog(@"当前状态: %@ ---",JSONObject);
        switch (result.flag) {
            case 0:
            {
                //waiting...
                [self setUpTheAppleScript:@"quit"];
            }
                break;
            case 1:
            {
                //sending...                    
                NSLog(@"脚本开始运行...");
                [[ZHWEventTool defaultEventTool]createEventWithContent:result.content local:nil];
                [self _pasteString:[self _getPasteString:result.email]];
                [self setUpTheAppleScript:@"AppleScript脚本"];
            }
                break;
            case 2:
            {
                //uploading...
                [self upLoadAppleIDs];
            }
                break;
                
            default:
                break;
        }
    }];
}

@end
