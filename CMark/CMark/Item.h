//
//  Item.h
//  CMark
//
//  Created by Ivan on 14/12/16.
//  Copyright (c) 2014年 one. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Item : NSManagedObject

@property (nonatomic, retain) NSNumber * money;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * hour;
@property (nonatomic, retain) NSNumber * day;
@property (nonatomic, retain) NSNumber * month;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSNumber * minute;
@property (nonatomic, retain) NSNumber * tag;


@end
