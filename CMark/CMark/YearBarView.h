//
//  YearBarView.h
//  CMark
//
//  Created by Ivan on 15/1/12.
//  Copyright (c) 2015年 one. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YearBarView : UIView

-(void)barPlot:(CGFloat )length majorIntervalLength:(NSString *)len;

-(void)dataArray:(NSArray *)mArray;

@end
