//
//  DetailViewController.m
//  ColorMark
//
//  Created by Ivan on 14/12/12.
//  Copyright (c) 2014年 one. All rights reserved.
//

#import "DetailViewController.h"
#import "ListTableViewController.h"
#import "Item.h"
#import "CorePlot-CocoaTouch.h"
#import "BarView.h"
#import "ScrollV.h"
#import "WeekBarView.h"
#import "MonthBarView.h"
#import "YearBarView.h"
#import "PickViewVC.h"


@interface DetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{

    IBOutlet ScrollV *scrollView;
    
    __weak IBOutlet ScrollV *scrPlotView;
    
    __weak IBOutlet UITableView *detailTableView;
    
}


@end

@implementation DetailViewController
{
    UISegmentedControl *_segmentedControl;
    
    UIButton *leftButton;
    
    NSString *itemName;
    
    BarView *barView;
    
    WeekBarView *weekBV;
    
    MonthBarView *monthBV;
    
    YearBarView *yearBV;
    
    NSArray *detailArray;
}


-(void)awakeFromNib
{
//    NSLog(@"DetailVC awakeFromNib");
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
        
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:@500,@"dayValue",@1500,@"weekValue",@5000,@"monthValue",@50000,@"yearValue",nil];
    
    [userDefault registerDefaults:dict];
    
    itemName=self.title;
    
    scrPlotView.contentSize=CGSizeMake(self.view.bounds.size.width + 255 , 0);
    
    scrPlotView.contentOffset=CGPointMake(0, 0);
    
    scrollView.contentSize=CGSizeMake(0, self.view.bounds.size.height + 50);
    
//    scrollView.pagingEnabled=YES;
    
    scrollView.scrollEnabled=NO;
    
    //隐藏默认的navigationBar    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self customNavigationBar];
    
    [self removeAllBarView];
    
    [self weekBarPlot];
    
    detailTableView.dataSource=self;
    
    detailTableView.delegate=self;
    
    [detailTableView reloadData];
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [scrPlotView setScrollEnabled:NO];
    
    [scrPlotView setContentOffset:CGPointZero animated:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    detailArray = [[NSArray alloc]init];

    UISwipeGestureRecognizer *swipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self
                                                                             action:@selector(popVC:)];
    swipe.direction=UISwipeGestureRecognizerDirectionRight;
    
    [scrollView addGestureRecognizer:swipe];
    
    CABasicAnimation *opacity=[CABasicAnimation animationWithKeyPath:@"opacity"];
    
    opacity.duration=0.6;
    
    opacity.fromValue=[NSNumber numberWithFloat:0.0];
    
    [detailTableView.layer addAnimation:opacity forKey:nil];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0:
            
            detailArray=nil;
            
            if ([itemName isEqualToString:@"全部"]) {
                
                 detailArray= [DataObject dayData:[DataObject checkTime:@"MM"]];
                
            }else{
                
                detailArray=[NSMutableArray arrayWithArray: [DataObject dayDataItem:itemName]];
            }
            break;
            
        case 1:
            
            detailArray=nil;

            if ([itemName isEqualToString:@"全部"]) {
                
                detailArray=[DataObject weekData:[DataObject checkTime:@"dd"]];
                
            }else{
                
                detailArray=[DataObject weekDataItem:itemName];
            }
            break;
        
        case 2:
            
            detailArray=nil;

            if ([itemName isEqualToString:@"全部"]) {
                
                detailArray=[DataObject monthData];
                
            }else{
                
                detailArray=[DataObject monthDataItem:itemName];
            }
            break;
            
        case 3:
            
            detailArray=nil;
            
            if ([itemName isEqualToString:@"全部"]) {
                
                detailArray=[DataObject yearData];
                
            }else{
                
                detailArray=[DataObject yearDataItem:itemName];
            }
            break;
            
        default:
            break;
    }
    
//    NSLog(@"detailArray.count:%lu",(unsigned long)detailArray.count);
    return detailArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
    
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DetailCell"];
    }
    
    
    NSMutableArray *keysArray=[[NSMutableArray alloc]init];
    
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    
    for (NSDictionary *dict in detailArray) {
        
        NSEnumerator *key=[dict keyEnumerator];
        
        for (NSObject *object in key) {
            
            NSString *string=(NSString *)object;
            
            [keysArray addObject:string];
            
            [dictionary setValue:[dict valueForKey:string] forKey:string];
        }
    }
    
    NSString *name=nil;
    
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0:

            name=[NSString stringWithFormat:@"  今天%@时：",[keysArray objectAtIndex:indexPath.row]];
            
            cell.textLabel.text=name;
            break;
            
        case 1:
            name=[NSString stringWithFormat:@"      %@月%@日：",[DataObject checkTime:@"MM"],[keysArray objectAtIndex:indexPath.row]];
            
            cell.textLabel.text=name;
            break;
            
        case 2:
            cell.textLabel.text=[NSString stringWithFormat:@"       %@月份",[keysArray objectAtIndex:indexPath.row]];
            break;
            
        case 3:
            cell.textLabel.text=[NSString stringWithFormat:@"       %@年",[keysArray objectAtIndex:indexPath.row]];
            break;
            
        default:
            cell.textLabel.text=nil;
            break;
    }
    
    
    
    NSString *subTitle=[NSString stringWithFormat:@"             %@元",[dictionary valueForKey:[keysArray objectAtIndex:indexPath.row]]];
    
    cell.detailTextLabel.text=subTitle;
    
//    NSLog(@"%@",dictionary);
    
    
    
    return cell;
}




-(void)barPlot
{
    NSNumber *number=[[NSUserDefaults standardUserDefaults]valueForKey:@"dayValue"];
    
    NSString *str=[NSString stringWithFormat:@"%f",[number floatValue] /5.0];
    
    barView=[[BarView alloc]init];
    barView.frame=CGRectMake(0,0,scrPlotView.bounds.size.width,200);
    [barView initCPTXYPlotSpace:-1 xLength:24.9 yStart:0 yLength:[number floatValue]];
    [barView initCPTXYAxis:@"0" xMIL:@"3" yAxis:@"0" yMIL:str];
    
    if ([itemName isEqualToString:@"全部"]) {
        
        [barView dataArray:[DataObject dayData:[DataObject checkTime:@"MM"]]];
        
    }else{
     
        [barView dataArray:[DataObject dayDataItem:itemName]];
    }
    
    [scrPlotView addSubview:barView];
    
}

-(void)weekBarPlot
{
    weekBV=[[WeekBarView alloc ]init];
    
    if ([itemName isEqualToString:@"全部"]) {
        
        [weekBV dataArray: [DataObject weekData:[DataObject checkTime:@"dd"]]];
        
    }else{
        
        [weekBV dataArray:[DataObject weekDataItem:itemName]];
        
//        NSLog(@"Else:%@",[DataObject weekDataItem:itemName]);
    }
    
    NSNumber *number=[[NSUserDefaults standardUserDefaults]valueForKey:@"weekValue"];
    
    NSString *str=[NSString stringWithFormat:@"%f",[number floatValue] /5.0];
    
    [weekBV barPlot:[number floatValue] majorIntervalLength:str];

    [scrPlotView addSubview:weekBV ];
    
}

-(void)monthBarPlot
{
    monthBV=[[MonthBarView alloc]init];
    
    if ([itemName isEqualToString:@"全部"]) {
        
        [monthBV dataArray: [DataObject monthData]];
        
    }else{
        
        [monthBV dataArray:[DataObject monthDataItem:itemName]];
    }
    
    NSNumber *number =[[NSUserDefaults standardUserDefaults] objectForKey:@"monthValue"];
    
    NSString *str=[NSString stringWithFormat:@"%f",[number floatValue] /5.0];
    
    [monthBV barPlot:[number floatValue]  majorIntervalLength:str];
    
    [scrPlotView addSubview:monthBV];
}

-(void)yearBarPlot
{
    
    yearBV=[[YearBarView alloc]init];
    
    if ([itemName isEqualToString:@"全部"]) {
        
        [yearBV dataArray: [DataObject yearData]];
        
    }else{
        
        [yearBV dataArray:[DataObject yearDataItem:itemName]];
    }
    
    NSNumber *number=[[NSUserDefaults standardUserDefaults]valueForKey:@"yearValue"];
    
    NSString *str=[NSString stringWithFormat:@"%f",[number floatValue] /5.0];
    
    [yearBV barPlot:[number floatValue] majorIntervalLength:str];
    
    [scrPlotView addSubview:yearBV];

}


-(void)segmentedValueChanged:(UIControl *)control
{
    
//    NSString *string=[_segmentedControl titleForSegmentAtIndex:[_segmentedControl selectedSegmentIndex]];
    
//    NSLog(@"SegmentedControl: %@",string);
    
    if ( [_segmentedControl selectedSegmentIndex]==0 ) {
        
        [detailTableView reloadData];
        
        scrPlotView.contentOffset=CGPointMake(80, 0);

        [self removeAllBarView];
        
        scrPlotView.scrollEnabled=YES;
        
        [self barPlot];

        [scrPlotView setContentOffset:CGPointZero animated:YES];
    }
    
    if ( [_segmentedControl selectedSegmentIndex]==1 ) {
        
        [detailTableView reloadData];

        [self removeAllBarView];
        
        [self weekBarPlot];
        
        [scrPlotView setContentOffset:CGPointZero animated:YES];
        
        scrPlotView.scrollEnabled=NO;

    }
    
    if ( [_segmentedControl selectedSegmentIndex]==2 ) {
        
        [detailTableView reloadData];

        [self removeAllBarView];
        
        [self monthBarPlot];
        
        [scrPlotView setContentOffset:CGPointZero animated:YES];
        
        scrPlotView.scrollEnabled=NO;
    }
    
    if ( [_segmentedControl selectedSegmentIndex]==3 ) {
        
        [detailTableView reloadData];

        [self removeAllBarView];
        
        [self yearBarPlot];
        
        [scrPlotView setContentOffset:CGPointZero animated:YES];
        
        scrPlotView.scrollEnabled=NO;
    }
}


-(void)removeAllBarView
{
    [barView removeFromSuperview];
    
    [weekBV removeFromSuperview];
    
    [monthBV removeFromSuperview];
    
    [yearBV removeFromSuperview];
    
    barView=nil;
    
    weekBV=nil;
    
    monthBV=nil;
    
    yearBV=nil;
}


-(void)customNavigationBar
{
    
//创建自定义navigationBar
    UINavigationBar *navigationBar=[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 100)];
    
    [self.view addSubview:navigationBar];
    
//创建UIView , 放入navigationBar内
    UIView *viewInBar=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    
    viewInBar.backgroundColor=[UIColor colorWithRed:252.0/255 green:101.0/255 blue:101.0/255 alpha:1.0];
    
    [navigationBar addSubview:viewInBar];
    
//设置UISegmentedControl
    NSArray *items=[NSArray arrayWithObjects:@"日",@"周",@"月",@"年", nil];
    
    _segmentedControl=[[UISegmentedControl alloc]initWithItems:items];
    
    _segmentedControl.frame=CGRectMake(5, 70, viewInBar.bounds.size.width-10, 26);
    
    [_segmentedControl setSelectedSegmentIndex:1];
    
    _segmentedControl.tintColor=[UIColor colorWithRed:255.0/255 green:204.0/255 blue:110.0/255 alpha:1.0];
    
//    _segmentedControl.tintColor=[UIColor whiteColor];
    
    [_segmentedControl addTarget:self
                          action:@selector(segmentedValueChanged:)
                forControlEvents:UIControlEventValueChanged];
    
    [viewInBar addSubview:_segmentedControl];
    
//标题为:UILabel
    UILabel *title=[[UILabel alloc]init];
    
    title.frame=CGRectMake(viewInBar.bounds.size.width/2-60, 20, 120, 40);
    
    title.text=itemName;
    
    title.textAlignment=NSTextAlignmentCenter;
    
    title.textColor=[UIColor whiteColor];
    
    title.font=[UIFont systemFontOfSize:20.0];
    
    [viewInBar addSubview:title];
    
//初始化LeftButton in NavigationBar
    leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    leftButton.frame=CGRectMake(15, 20, 40, 40);
    
    //对齐:内容靠水平左侧
    leftButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    
    [leftButton setImage:[UIImage imageNamed:@"leftButtonWhite"] forState:UIControlStateNormal];
    
//    [leftButton setBackgroundColor:[UIColor whiteColor]];
    
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    leftButton.titleLabel.font=[UIFont systemFontOfSize:19];
    
    leftButton.titleLabel.textAlignment=NSTextAlignmentLeft;
    
    [leftButton addTarget:self
                   action:@selector(popVC:)
         forControlEvents:UIControlEventTouchUpInside];
    
    [viewInBar addSubview:leftButton];
    
    [leftButton.layer addAnimation:[self leftBtnAnimation] forKey:nil];
    
    
//RightButton
    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    rightButton.frame=CGRectMake(viewInBar.frame.size.width-45, 20, 40, 40);
    
    //对齐:内容靠水平左侧
    rightButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    
    [rightButton setImage:[UIImage imageNamed:@"detailValue"] forState:UIControlStateNormal];
    
//    [rightButton setTitle:@"范围" forState:UIControlStateNormal];
    
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [rightButton addTarget:self
                   action:@selector(valueVC:)
         forControlEvents:UIControlEventTouchUpInside];
    
    [viewInBar addSubview:rightButton];
}


-(void)popVC:(UIEvent *)event
{
    
//    [self.navigationController setNavigationBarHidden:NO];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)valueVC:(UIEvent *)event
{
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController *pkNV=[storyBoard instantiateViewControllerWithIdentifier:@"pickViewNV"];
    
    pkNV.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:pkNV animated:YES completion:^{
        
    }];
}


-(CAAnimationGroup *)leftBtnAnimation
{
    CABasicAnimation *moveAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
    
    moveAnimation.fromValue=[NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(self.view.bounds)/2.0, 40)];
    
    //    moveAnimation.duration=0.6;
    
    moveAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CABasicAnimation *opacityAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    
    opacityAnimation.fromValue=[NSNumber numberWithFloat:0.0];
    
    //    opacityAnimation.duration=1.0;
    
    opacityAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *group=[CAAnimationGroup animation];
    
    group.animations=[NSArray arrayWithObjects:moveAnimation,opacityAnimation, nil];
    
    group.duration=0.7;
    
    group.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    return group;
}


/*
-(CAAnimationGroup *)startWithAnimations:(NSNumber *)direction
{
    //1.横向移动
    CABasicAnimation *moveAnimation=[CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    
    //    moveAnimation.duration=1.0;
    
    moveAnimation.fromValue=direction;
    
    //    [detailBtn.layer addAnimation:moveAnimation forKey:@"Xmove"];
    
    //2.旋转
    CABasicAnimation *rotaionAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    //    rotaionAnimation.duration=1.0;
    
    rotaionAnimation.fromValue=[NSNumber numberWithFloat:3 * M_PI];
    
    //    [detailBtn.layer addAnimation:rotaionAnimation forKey:@"Rotation"];
    
    //3.CAAnimationGroup
    CAAnimationGroup *groupStart=[CAAnimationGroup animation];
    
    groupStart.duration=1.0;
    
    groupStart.animations=@[moveAnimation,rotaionAnimation];
    
    groupStart.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    return groupStart;

}


-(CAAnimationGroup *)BeginningAnimations
{
    //1.Opacity
    CABasicAnimation *moveAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    
    moveAnimation.fromValue=[NSNumber numberWithFloat:0.0];
    
    //2.Rotation
    CABasicAnimation *rotaionAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    
    rotaionAnimation.fromValue=[NSNumber numberWithFloat:2*M_PI];
    
    //3.CAAnimationGroup
    CAAnimationGroup *groupRotation=[CAAnimationGroup animation];
    
    groupRotation.duration=1.0;
    
    groupRotation.animations=@[moveAnimation,rotaionAnimation];
    
    groupRotation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    return groupRotation;

}
*/


-(void)viewWillDisaAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
