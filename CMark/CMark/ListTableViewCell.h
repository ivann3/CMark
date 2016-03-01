//
//  ListTableViewCell.h
//  ColorMark
//
//  Created by Ivan on 14/12/12.
//  Copyright (c) 2014年 one. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *iconImage;

@property (strong, nonatomic) IBOutlet UILabel *describeLabel;

@property (strong, nonatomic) IBOutlet UIImageView *rightImage;

@end
