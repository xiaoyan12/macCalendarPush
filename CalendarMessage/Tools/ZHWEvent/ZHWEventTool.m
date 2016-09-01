//
//  ZHWEventTool.m
//  CalendarMessage
//
//  Created by 刘斌 on 16/8/26.
//  Copyright © 2016年 lb. All rights reserved.
//

#import "ZHWEventTool.h"
#import <EventKit/EventKit.h>
#import "ZHWDBHelper.h"

@interface ZHWEventTool ()

@property (strong,nonatomic) NSMutableArray *appleIDs;

@end

@implementation ZHWEventTool

static ZHWEventTool *defaultEvent = nil;

+ (instancetype)defaultEventTool{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (defaultEvent == nil) {
            defaultEvent = [[self alloc]init];
        }
    });
    return defaultEvent;
}

- (instancetype)init{
    if (self = [super init]) {
        if (!self.appleIDs) {
//            从本地读取缓存
            self.appleIDs = [NSMutableArray arrayWithArray:[ZHWDBHelper queryData:nil]];

        }
    }
    return self;
}


- (NSArray *)allEvents{
    //获取日历事件
    EKEventStore* eventStore = [[EKEventStore alloc] init];
    NSDate* ssdate = [NSDate dateWithTimeIntervalSinceNow:-3600*24*7];
    NSDate* ssend = [NSDate dateWithTimeIntervalSinceNow:3600*24*7];
    NSPredicate* predicate = [eventStore predicateForEventsWithStartDate:ssdate
                                                                 endDate:ssend
                                                               calendars:nil];
    NSArray* events = [eventStore eventsMatchingPredicate:predicate];
    return events;
}



- (NSArray *)getEventsFrom:(NSDate *)fromDate to:(NSDate *)endDate{
    //获取日历事件
    EKEventStore* eventStore = [[EKEventStore alloc] init];
    NSPredicate* predicate = [eventStore predicateForEventsWithStartDate:fromDate
                                                                 endDate:endDate
                                                               calendars:nil];
    NSArray* events = [eventStore eventsMatchingPredicate:predicate];
    return events;
}


- (BOOL)createEventWithContent:(NSString *)content local:(NSString *)location{
    if (!content.length) {
        return NO;
    }
    
    EKEventStore *eventStore = [[EKEventStore alloc]init];
    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
    
    //事件内容
    event.title = content;
    
    //地点
    if (location.length) {
        event.location = location;
    }
    
    //日期
    event.startDate = [NSDate dateWithTimeInterval:60 sinceDate:[NSDate date]];
    event.endDate   = [NSDate dateWithTimeIntervalSinceNow:3600*24];
    event.allDay = NO;
    
    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
    return [eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:nil];

}


- (void)getRealAppleIDs:(AppleIDResultBlock)resultBlock{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        NSArray *events = [self allEvents];
        for (EKEvent *event in events) {
            for (EKParticipant *participant in event.attendees) {
                if ([participant.name containsString:@"@"]) {
                    if ((participant.participantStatus != EKParticipantStatusUnknown) &&
                        (participant.participantStatus != EKParticipantStatusPending)) {
                        if (![_appleIDs containsObject:participant.name]) {
                            [_appleIDs addObject:participant.name];
                            [ZHWDBHelper insertAppleId:participant.name];
                        }
                    }
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            resultBlock(_appleIDs);
        });
    });
}



@end


