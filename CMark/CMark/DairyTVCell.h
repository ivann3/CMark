//
//  DairyTVCell.h
//  CMark
//
//  Created by Ivan on 14/12/24.
//  Copyright (c) 2014年 one. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollV.h"

@interface DairyTVCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;


@end
