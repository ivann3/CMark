//
//  DairyTVC.h
//  CMark
//
//  Created by Ivan on 14/12/24.
//  Copyright (c) 2014年 one. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@class Item;

@protocol EditDelegate <NSObject>

@optional

-(void)editItem:(Item *)item;

@end

@interface DairyTVC : UITableViewController

@property(nonatomic,weak) id <EditDelegate> delegate;

@end
