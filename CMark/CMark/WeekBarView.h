//
//  WeekBarView.h
//  CMark
//
//  Created by Ivan on 15/1/7.
//  Copyright (c) 2015年 one. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeekBarView : UIView

-(void)dataArray:(NSArray *)mArray;

-(void)barPlot:(CGFloat )length majorIntervalLength:(NSString *)len;

@end
