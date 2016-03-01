//
//  DataObject.m
//  CMark
//
//  Created by Ivan on 14/12/22.
//  Copyright (c) 2014年 one. All rights reserved.
//

#import "DataObject.h"
#import "Item.h"

@implementation DataObject

-(instancetype)init
{
    self=[super init];
    if (self) {
        
    }
    return self;
}


+(NSNumber *)checkTime:(NSString *)string
{
    NSDate *date=[NSDate date];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:string];
    NSString *dateStr =[dateFormatter stringFromDate:date];
    
    NSNumber *number=[NSNumber numberWithFloat:[dateStr floatValue]  ];
    //    NSLog(@"checkDay: %@",number);
    
    return number;
}


//返回参数为year的数据
+(NSArray *)yearItems:(NSNumber *)year
{
    NSArray *array=[Item MR_findAll];
    
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    
    for (Item *item in array) {
        
        if ([item.year isEqualToNumber:year]) {
            
            [arr addObject:item];
        }
    }
    return arr;
}


//返回参数为month的数据
+(NSArray *)monthItems:(NSNumber *)month
{
    NSArray *array=[self yearItems:[self checkTime:@"yyyy"]];
    
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    
    for (Item *item in array) {
        
        if ([item.month isEqualToNumber:month]) {
            
            [arr addObject:item];
        }
    }
    return arr;
}


#pragma Mark 用于设定“日”祝状态的全部数据

+(NSArray *)dayData:(NSNumber *)month
{
    //如:取回属性为day的条目
    NSArray *items=[self monthItems:month];

    NSMutableArray *array=[[NSMutableArray alloc]init];
    
    for (Item *item in items) {
        
        if ([item.day isEqualToNumber:[self checkTime:@"dd"]]) {
            
            [array addObject:item];
        }
    }
    
//    NSLog(@"array:%@",array);
    
    return [self itemDay:array];
}


+(NSArray *)itemDay:(NSArray *)days
{
    //1.初始化数组
    NSMutableArray *dayArray=[[NSMutableArray alloc]init];
    
    for (Item *item in days) {
        //定义Key
        NSNumber *hourStr=item.hour;
        NSString *key=[NSString stringWithFormat:@"%@",hourStr];
        //定义value
        NSNumber *value=item.money;
        //添加到字典
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        
        [dict setValue:value forKey:key];
        
        [dayArray addObject:dict];
    }
//        NSLog(@"array:%@",dayArray);
    
    //2.初始化字典
    NSMutableArray *hourArray=[[NSMutableArray alloc]init];
    
    for (int i=0; i<24; i++) {
        NSString *key=[NSString stringWithFormat:@"%i",i];
        
        NSMutableDictionary *d=[NSMutableDictionary dictionaryWithCapacity:1];
        
        [d setValue:@0 forKey:key];
        
        [hourArray addObject:d];
    }
//        NSLog(@"hourArray: %@",hourArray);
    
    //3.设置字典并添加到数组
    for (int i=0; i<24; i++) {
        //把i转换为(NSString *)key
        NSString *key=[NSString stringWithFormat:@"%i",i];
        float money=0;
        //for in 循环字典：查找键值为i的值;
        for (NSDictionary *d in dayArray) {
            for (NSString *str in d) {
                //                NSLog(@"str: %@",str);
                if ([str isEqual: key]) {
                    money+=[[d valueForKey:str] floatValue];
                    //                    NSLog(@"money: %f",money);
                }
            }
            [hourArray[i] setValue:[NSNumber numberWithFloat:money] forKey:key];
        }
    }
//        NSLog(@"hourArray: %@",hourArray);
    return hourArray;
}


#pragma Mark”日“柱状图的单项数据

+(NSArray *)dayDataItem:(NSString *)name
{
    NSArray *array=[self monthItems:[self checkTime:@"MM"]];
//    NSLog(@"Array:%@",array);
    
    NSMutableArray *namesArray=[[NSMutableArray array]init];
    
//    NSLog(@"name:%@",name);
    for (Item *item in array) {
//        NSLog(@"item.name:%@",item.name);

        if ([item.name isEqualToString:name]) {
            
            [namesArray addObject:item];
        }
    }
    
//    NSLog(@"namesArray:%@",namesArray);
    
    NSMutableArray *dayItems=[[NSMutableArray alloc]init];
    
    for (Item *item in namesArray) {
        
        if ([item.day isEqual:[self checkTime:@"dd"]]) {
            
            [dayItems addObject:item];
        }
        
//         NSLog(@"dayItems :%@",dayItems);
    }
    return  [self itemDay:dayItems];
}


#pragma Mark”周“柱状图的总数据

+(NSArray *)weekData:(NSNumber *)today
{
    //1.获得今年当月的数据
    NSArray *array=[self monthItems:[self checkTime:@"MM"]];
    
    NSMutableArray *weekArray=[NSMutableArray arrayWithCapacity:7];
    
    for (int i=0 ; i<7; i++) {
        
        float money=0;

        int m=[today intValue]-i;
        
        NSNumber *number=[NSNumber numberWithInt:m];
        
    //2.首先获取当天的数据，依次递减
        NSMutableArray *arr=[[NSMutableArray alloc]init];
        
        for (Item *item in array) {
            
            if ([item.day isEqualToNumber:[self checkTime:[number stringValue]]]) {
                
                [arr addObject:item];
            }
        }
        
    //3.获取key和value 存入数组
        for (Item *item in arr) {
                
            money=[item.money floatValue]+money;
        }
        
        NSDictionary *dict=[NSDictionary dictionaryWithObject:
                                    [NSNumber numberWithFloat: money] forKey:[number stringValue] ];
        if (weekArray.count == 0) {
            
            [weekArray addObject:dict];
            
        }else{
            
            [weekArray insertObject:dict atIndex:0];
        }
    }
    
//    NSLog(@"weekArray:%@",weekArray);
    
    return weekArray;
}


#pragma Mark”周“柱状图的单项数据

+(NSArray *)weekDataItem:(NSString *)name;
{
    NSMutableArray *arrWeek=[NSMutableArray arrayWithCapacity:7];
    
    //初始化7天的数据(数组内包含字典)
    for (int i=0; i<7; i++) {
        
        int m=[[DataObject checkTime:@"dd"] intValue]-i;
        
        NSString *key=[NSString stringWithFormat:@"%d",m];
        
        NSMutableDictionary *mDict=[NSMutableDictionary dictionaryWithCapacity:1] ;
        
        [mDict setValue:@"0" forKey:key];
        
        if(arrWeek.count==0){
            
            [arrWeek addObject:mDict];
            
        }else{
            
            [arrWeek insertObject:mDict atIndex:0];
        }
    }
    
//    NSLog(@"%@",arrWeek);
    
    //2.首先获取当天的数据，依次递减6次
    for (int i=0; i<7; i++) {
        
        int m=[[DataObject checkTime:@"dd"] intValue]-i;
        
        NSArray *array=[self monthItems:[self checkTime:@"MM"] ];
        
//        NSLog(@"array:%@",array);
        
        
        //筛选月里的传入参数name
        NSMutableArray *namesArray=[[NSMutableArray alloc]init];
        
        for (Item *item in array) {
            
            if ([item.name isEqual:name]) {
                
                [namesArray addObject:item];
//                NSLog(@"%@",item);
            }
        }
        
        //从name数据中筛选day

        NSMutableArray *itemsArray=[[NSMutableArray alloc]init];
        
        for (Item *item in namesArray) {
            
            if ([item.day isEqual:[NSNumber numberWithInt:m]]) {
                
                [itemsArray addObject:item];
            }
        }
        
//        NSLog(@"itemsArray:%@",itemsArray);

        
        //获取money,day(NSString*)
        float money=0;
        
        NSString *n=nil;;
        
        for (Item *item in itemsArray) {

            money=[item.money floatValue]+money;
            
            n=[item.day stringValue];
        }
        
        //将money存入7天的数组里
        for (NSMutableDictionary *dict in arrWeek) {
            
            NSEnumerator *enumerator=[dict keyEnumerator];
            
            for (NSObject *object in enumerator) {
                
                NSString *str=(NSString *)object;
                
                if ([str isEqualToString:n] ) {
                    
                    [dict setValue:[NSNumber numberWithFloat: money] forKey:n];
                }
           }
        }
        
    }
//    NSLog(@"arrWeek%@",arrWeek);

    return arrWeek;
}


#pragma Mark”月“柱状图的总数据

+(NSArray *)monthData
{
    NSMutableArray *arrayMonth=[NSMutableArray arrayWithCapacity:12];
    
    for (int i=1; i<=12; i++) {
        
        NSArray *arr=[self monthItems:[NSNumber numberWithInt:i]];
        
        //获取key和value 存入数组
        float money=0;
        
        for (Item *item in arr) {
            
            money=[item.money floatValue]+money;
        }
        
        [arrayMonth addObject:@{[NSString stringWithFormat:@"%d",i]:[NSNumber numberWithFloat:money]}];
    }
    
    return arrayMonth;
}


#pragma Mark”月“柱状图的单项数据

+(NSArray *)monthDataItem:(NSString *)name
{
    //初始化数组，元素为字典。如(1:0)、(2:0)、(12:0)
    NSMutableArray *mArray=[NSMutableArray  arrayWithCapacity:12];
    
    for (int i=1; i<=12; i++) {
        
        NSString *key=[NSString stringWithFormat:@"%d",i];
        
        NSMutableDictionary *mDict=[NSMutableDictionary dictionaryWithCapacity:1] ;
        
        [mDict setValue:@"0" forKey:key];
        
        [mArray addObject:mDict];
    }
    
//    NSLog(@"mArray:%@",mArray);
    
    //获取array 元素为获取参数为name的item
    NSArray *array=[self yearItems:[self checkTime:@"yyyy"]];

    NSMutableArray *itemArray=[[NSMutableArray alloc]init];
    
    for (Item *item in array) {
        
        if ([item.name isEqualToString:name]) {
            
            [itemArray addObject:item];
        }
    }
//    NSLog(@"itemArray:%@",itemArray);
    
    //计算并赋值
    for (int i=0; i<itemArray.count; i++) {
        
        float money=0;
        
        for (Item *item in itemArray) {
            
            if ([item.month isEqualToNumber:[NSNumber numberWithInt:i+1]]) {
                
                money=[item.money floatValue] + money;
            }
        }
        
        [mArray[i] setValue:[NSNumber numberWithInt:money] forKey:[NSString stringWithFormat:@"%d",i+1]];
    }
    
//    NSLog(@"mArray:%@",mArray);
    
    return mArray;
}



+(NSArray *)yearData{
    
    NSMutableArray *yearArr=[NSMutableArray arrayWithCapacity:2];
    
    NSNumber *year=[self checkTime:@"yyyy"];
    
    for (int i=0;i<2;i++) {
        
        year = [NSNumber numberWithInt:([year intValue]-i)] ;
        
        NSArray *array=[self yearItems:year];
        
        float money=0;
        
        for (Item *item in array) {
            
            money = money + [item.money floatValue];
        }
        
        NSDictionary *dict=[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:money]
                                                       forKey:[year stringValue]];
        yearArr.count>0 ? [yearArr insertObject:dict atIndex:0] : [yearArr addObject:dict];
        
    }
    
//    NSLog(@"yearArr:%@",yearArr);

    return yearArr;
    
}

+(NSArray *)yearDataItem:(NSString *)name
{

    NSMutableArray *yearArr=[NSMutableArray arrayWithCapacity:2];
    
    NSNumber *year=[self checkTime:@"yyyy"];
    
    for (int i=0;i<2;i++) {
        
        year = [NSNumber numberWithInt:([year intValue]-i)] ;
        
        NSArray *array=[self yearItems:year];
        
        NSMutableArray *arrItems=[[NSMutableArray alloc]init];
        
        for (Item *item in array) {
            
            if ([item.name isEqualToString:name]) {
                
                [arrItems addObject:item];
            }
        }
        
//        NSLog(@"arrItems:%@",arrItems);
        
        float money=0;
        
        for (Item *item in arrItems) {
            
            money = money + [item.money floatValue];
        }
        
        NSDictionary *dict=[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:money]
                                                       forKey:[year stringValue]];
        yearArr.count>0 ? [yearArr insertObject:dict atIndex:0] : [yearArr addObject:dict];
        
    }
    
//        NSLog(@"yearArr:%@",yearArr);
    
    return yearArr;

    
    
}
    




+(float)totalCost
{
    NSArray *totalArray=[Item MR_findAll];
    float totalCost=0;
    for(Item *item in totalArray)
    {
        totalCost=[item.money floatValue] +totalCost;
    }
    return totalCost;
}

@end
