//
//  BarView.m
//  plot
//
//  Created by Ivan on 14/12/17.
//  Copyright (c) 2014年 one. All rights reserved.
//

#import "BarView.h"
#import "CorePlot-CocoaTouch.h"

@interface BarView ()<CPTPlotDataSource>

@end

@implementation BarView

{
    CPTXYGraph *xyGraph;

    //获取DataPlot
    NSArray *dataArray;
}


-(instancetype)init{
    self=[super init];
    if (self) {
        
        dataArray=[[NSArray alloc]init];
        
        [self barPlot];
    }
    return self;
}


-(void)barPlot
{
    
    //1.初始化CGPXYGraph
    xyGraph=[[CPTXYGraph alloc]initWithFrame:self.bounds];
    
    CPTTheme *theme=[CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [xyGraph applyTheme:theme];
    
    xyGraph.paddingLeft=10;
    xyGraph.paddingRight=10;
    xyGraph.paddingTop=10;
    xyGraph.paddingBottom=10;
    
    //CPTXYGraph.plotAreaFrame
    xyGraph.plotAreaFrame.paddingLeft   = 10.0;
    xyGraph.plotAreaFrame.paddingTop    = 5.0;
    xyGraph.plotAreaFrame.paddingRight  = 10.0;
    xyGraph.plotAreaFrame.paddingBottom = 5.0;
    
    xyGraph.plotAreaFrame.borderLineStyle=nil;
    xyGraph.plotAreaFrame.cornerRadius=5.0;
    xyGraph.plotAreaFrame.masksToBorder=NO;
    
    //初始化CPTGraphHostingView，并加载CPTXYGraph
    CPTGraphHostingView *hostingView=[[CPTGraphHostingView alloc]initWithFrame:CGRectMake(55, 0,500,220)];
    hostingView.collapsesLayers=NO;
    hostingView.hostedGraph=xyGraph;
    [self addSubview:hostingView];
    
    
    CPTMutableLineStyle *lineStyle=[CPTMutableLineStyle lineStyle];
    lineStyle.lineWidth=1.0;
    lineStyle.lineColor=[CPTColor colorWithComponentRed:0.7 green:0.5 blue:0.9 alpha:1.0];
    
    //setup ScatterPlot
    CPTBarPlot *barPlot=[CPTBarPlot tubularBarPlotWithColor:
                            [CPTColor colorWithComponentRed:0.9 green:0.6 blue:0.8 alpha:0.9]      horizontalBars:NO];
    barPlot.identifier=@"BarPlot";

    barPlot.baseValue=CPTDecimalFromDouble(0.0);
    
//    barPlot.barOffset=CPTDecimalFromFloat(0.5);
    
    CPTColor *color1=[CPTColor colorWithComponentRed:1.0 green:0.55 blue:0.0 alpha:1.0];
    CPTColor *color2=[CPTColor colorWithComponentRed:1.0 green:0.20 blue:0.3 alpha:1.0];
    CPTGradient *gradient=[CPTGradient gradientWithBeginningColor:color1 endingColor:color2 beginningPosition:0.3 endingPosition:1.0];
    gradient.angle=90.0;
    barPlot.fill=[CPTFill fillWithGradient:gradient];
    
    barPlot.dataSource=self;
    
    
    //添加渐变
//    CPTColor *color1=[CPTColor colorWithComponentRed:0.5 green:0.5 blue:0.9 alpha:1.0];
//    CPTColor *color2=[CPTColor whiteColor];
//    CPTGradient *gradient=[CPTGradient gradientWithBeginningColor:color1 endingColor:color2];
//    gradient.angle=-90.0;
//    scatterPlot.areaFill=[CPTFill fillWithGradient:gradient];
//    scatterPlot.areaBaseValue=[[NSDecimalNumber numberWithFloat:0.0 ]decimalValue];
    
    // Add plot symbols: 表示数值的符号的形状
    CPTPlotSymbol *plotSymbol=[CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill=[CPTFill fillWithColor: [CPTColor whiteColor]];
    plotSymbol.size=CGSizeMake(4, 4);
    
//    scatterPlot.plotSymbol=plotSymbol;
    
    [xyGraph addPlot:barPlot];
}


-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return dataArray.count;
}


-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx{
    
    NSDecimalNumber *num=nil;
    
    if ([plot isKindOfClass:[CPTBarPlot class]]) {
        switch (fieldEnum) {
            case CPTBarPlotFieldBarLocation:
                num=(NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInteger:idx];
                break;
            case CPTBarPlotFieldBarTip:
                num=(NSDecimalNumber *)[NSDecimalNumber numberWithFloat:[self valueKey:dataArray index:idx]];
//                NSLog(@"num%lu: %@",(unsigned long)idx,num);
                break;
        }
    }
    return num;
}

-(void)initCPTXYPlotSpace:(float)xstart xLength:(float)xlenght yStart:(float)ystart yLength:(float)ylenght
{
    //初始化PlotSpace
    CPTXYPlotSpace *plotSpace=(CPTXYPlotSpace *)xyGraph.defaultPlotSpace;
    plotSpace.xRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromCGFloat(xstart) length:CPTDecimalFromCGFloat(xlenght) ];
    plotSpace.yRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromCGFloat(ystart) length:CPTDecimalFromCGFloat(ylenght)];
    
    CPTMutableLineStyle *axisLineStyle=[CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth=1.0;
    axisLineStyle.miterLimit=0.5;
    axisLineStyle.lineColor=[CPTColor redColor];
    

}

-(void)initCPTXYAxis:(NSString *)xOC xMIL:(NSString *)xMajorIL yAxis:(NSString *)yOC yMIL:(NSString *)yMajorIL
{
    // Axes: 设置x,y轴属性，如原点，量度间隔，标签，刻度，颜色等
    CPTXYAxisSet *axisSet=(CPTXYAxisSet *)xyGraph.axisSet;
    //x轴
    CPTXYAxis *xAxis=axisSet.xAxis;
    xAxis.orthogonalCoordinateDecimal=CPTDecimalFromString(xOC);
    xAxis.majorIntervalLength=CPTDecimalFromString(xMajorIL);
    xAxis.minorTicksPerInterval=0;
    xAxis.axisLineStyle=nil;
    xAxis.majorTickLineStyle=nil;
    xAxis.minorTickLineStyle=nil;
    
    //自定义数据标签
    xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    NSArray *customTickLocations = [NSArray arrayWithObjects: [NSDecimalNumber numberWithInt:6], [NSDecimalNumber numberWithInt:12], [NSDecimalNumber numberWithInt:18],[NSDecimalNumber numberWithInt:23], nil];
    NSArray *xAxisLabels         = [NSArray arrayWithObjects: @"6h", @"12h", @"18h",@"23h" ,nil];
    NSUInteger labelLocation     = 0;
    NSMutableSet *customLabels   = [NSMutableSet setWithCapacity:[xAxisLabels count]];
    for ( NSNumber *tickLocation in customTickLocations ) {
        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:[xAxisLabels objectAtIndex:labelLocation++] textStyle:xAxis.labelTextStyle];
        newLabel.tickLocation = [tickLocation decimalValue];
        newLabel.offset       = xAxis.labelOffset + xAxis.majorTickLength;
//        newLabel.rotation     = M_PI_4;
        [customLabels addObject:newLabel];
    }
    xAxis.axisLabels = customLabels;

    //y轴
    CPTXYAxis *yAxis=axisSet.yAxis;
    //    yAxis.title=@"yAxis";
    //    yAxis.titleOffset                 = -50;
    //    yAxis.titleLocation               = CPTDecimalFromFloat(300.0f);
    yAxis.orthogonalCoordinateDecimal=CPTDecimalFromString(yOC);
    yAxis.majorIntervalLength=CPTDecimalFromString(yMajorIL);
    yAxis.minorTicksPerInterval=200;
    yAxis.axisLineStyle=nil;
    yAxis.majorTickLineStyle=nil;
    yAxis.minorTickLineStyle=nil;
    //自定义显示刻度
//    yAxis.labelingPolicy=CPTAxisLabelingPolicyNone;
}

-(void)dataArray:(NSArray *)mArray
{
    dataArray=mArray;
//    NSLog(@"dataArry: %@",dataArray);
}


-(float)valueKey:(NSArray *)array index:(NSUInteger)idx
{
    NSDictionary *dict=[array objectAtIndex:idx];
//    NSLog(@"dict :%@",dict);
    
    float money;
    
    NSString *idxStr=[NSString stringWithFormat:@"%lu",(unsigned long)idx];
//    NSLog(@"idxStr :%@",idxStr);
    
    money=[[dict objectForKey:idxStr] floatValue];
//    NSLog(@"money :%f",money);
    
    return money;
}


@end
