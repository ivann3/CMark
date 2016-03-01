//
//  DataObject.h
//  CMark
//
//  Created by Ivan on 14/12/22.
//  Copyright (c) 2014年 one. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

@interface DataObject : NSObject

+(float)totalCost;

+(NSNumber *)checkTime:(NSString *)string;

+(NSArray *)itemDay:(NSArray *)days;

+(NSArray *)dayData:(NSNumber *)month;
//用于设定“日”柱状图的总数据

+(NSArray *)dayDataItem:(NSString *)name;

+(NSArray *)weekData:(NSNumber *)today;
//“周”柱状图总的数据

+(NSArray *)weekDataItem:(NSString *)name;
//“周”柱状图单项数据

+(NSArray *)monthData;
//”月“柱状图总数据

+(NSArray *)monthDataItem:(NSString *)name;
//”月“柱状图的单项数据

+(NSArray *)yearData;
//”年“柱状图总数据

+(NSArray *)yearDataItem:(NSString *)name;
//”年“柱状图的单项数据


@end
