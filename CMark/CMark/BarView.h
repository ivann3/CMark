//
//  BarView.h
//  plot
//
//  Created by Ivan on 14/12/17.
//  Copyright (c) 2014年 one. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "DetailViewController.h"

@interface BarView : UIView

-(void)dataArray:(NSArray *)array;

-(void)initCPTXYPlotSpace:(float)xstart xLength:(float)xlenght yStart:(float)ystart yLength:(float)ylenght;

-(void)initCPTXYAxis:(NSString *)xOC xMIL:(NSString *)xMajorIL yAxis:(NSString *)yOC yMIL:(NSString *)yMajorIL;

-(void)barPlot;

@end
