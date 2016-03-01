//
//  ViewController.m
//  ColorMark
//
//  Created by Ivan on 14/12/10.
//  Copyright (c) 2014年 one. All rights reserved.
//
#import "ViewController.h"
#import "Item.h"
#import "ScrollV.h"
#import "DairyTVC.h"



@interface ViewController ()<UIActionSheetDelegate,UIScrollViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftButton;

- (IBAction)back:(UIBarButtonItem *)sender;

- (IBAction)save:(UIBarButtonItem *)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *largeScr;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIView *viewTime;

@property (weak, nonatomic) IBOutlet UILabel *anmimationLabel;

@property (weak, nonatomic) IBOutlet UILabel *hourLabel;

@property (weak, nonatomic) IBOutlet UIPickerView *timePickerView;

@property (weak, nonatomic) IBOutlet UILabel *minsLabel;

@property (weak, nonatomic) IBOutlet UIView *viewFirst;

@property (weak, nonatomic) IBOutlet UILabel *iconLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UITextField *textFieldPay;

@property (weak, nonatomic) IBOutlet UIImageView *ivClothes;
@property (weak, nonatomic) IBOutlet UIImageView *ivFood;
@property (weak, nonatomic) IBOutlet UIImageView *ivBed;
@property (weak, nonatomic) IBOutlet UIImageView *ivRiding;
@property (weak, nonatomic) IBOutlet UIImageView *ivMovie;
@property (weak, nonatomic) IBOutlet UIImageView *ivMusic;
@property (weak, nonatomic) IBOutlet UIImageView *ivDrink;
@property (weak, nonatomic) IBOutlet UIImageView *ivBook;
@property (weak, nonatomic) IBOutlet UIImageView *ivShopping;
@property (weak, nonatomic) IBOutlet UIImageView *ivGas;
@property (weak, nonatomic) IBOutlet UIImageView *ivRepair;
@property (weak, nonatomic) IBOutlet UIImageView *ivCross;
@property (weak, nonatomic) IBOutlet UIImageView *ivSport;
@property (weak, nonatomic) IBOutlet UIImageView *ivExpress;
@property (weak, nonatomic) IBOutlet UIImageView *ivTao;
@property (weak, nonatomic) IBOutlet UIImageView *ivElse;

@property (weak, nonatomic) IBOutlet UILabel *totalCostLabel;

@property (weak,nonatomic)  NSString *itemName;

@property(nonatomic)float money;

@property (strong,nonatomic) NSArray *imageViews;

@property (strong,nonatomic) NSMutableArray *hours;

@property (strong,nonatomic) NSMutableArray *mins;


//- (IBAction)hideKeyBoard:(UIButton *)sender;

//- (IBAction)longPressGesture:(UILongPressGestureRecognizer *)sender;



@end


@implementation ViewController



-(instancetype)init
{
    self=[super init];
    if (self) {

    }
    return self;
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _largeScr.contentSize=CGSizeMake(1200, 0);
    
    _largeScr.pagingEnabled=YES;
    
    _largeScr.showsHorizontalScrollIndicator=NO;
    
    _largeScr.delegate=self;
    
    _timePickerView.hidden=YES;
    
//    NSLog(@"%@",NSStringFromCGRect(_largeScr.frame));
    
//    [self totalCost];
    
    self.title=@"新条目";
    
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:60.0/255 green:130.0/255 blue:160.0/255 alpha:1.0];
    
    self.navigationController.navigationBar.titleTextAttributes =[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:19.0],NSFontAttributeName ,nil];
    
    NSString *hour=[[DataObject checkTime:@"HH"] stringValue];
    
    NSString *minute=[[DataObject checkTime:@"mm"] stringValue];
    
    if ([hour intValue]>10) {
        
        _hourLabel.text=hour;
    }else{
        
        _hourLabel.text=[NSString stringWithFormat:@"0%@",hour];
    }

    if ([minute intValue]>10) {
        
        _minsLabel.text=minute;
    }else{
        
        _minsLabel.text=[NSString stringWithFormat:@"0%@",minute];
    }
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UITapGestureRecognizer *tapTF=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTFMethod:)];
    
    [_viewFirst addGestureRecognizer:tapTF];
    
    UITapGestureRecognizer *tapViewTime=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViewTimeMethod:)];
    
    [_viewTime addGestureRecognizer:tapViewTime];
    
    CABasicAnimation *flash=[CABasicAnimation animationWithKeyPath:@"opacity"];
    
    flash.duration=1.0;
    
    flash.fromValue=[NSNumber numberWithFloat:0];
    
    flash.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    flash.repeatCount=1000;
    
//    flash.repeatDuration=0.5;
    
    [_anmimationLabel.layer addAnimation:flash forKey:@"Flash"];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.textFieldPay.delegate=self;
    
    self.timePickerView.delegate=self;
    
    self.timePickerView.dataSource=self;
    
    _hours=[NSMutableArray arrayWithCapacity:24];
    
    for (int i=0; i<24; i++) {
        
        if (i<10) {
            
            [_hours addObject:[NSString stringWithFormat:@"0%d",i]];

        }else
            
            [_hours addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    _mins=[NSMutableArray arrayWithCapacity:60];
    
    for (int i=0; i<60; i++) {
        
        if (i<10) {
            
            [_mins addObject:[NSString stringWithFormat:@"0%d",i]];
            
        }else
            
            [_mins addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    _imageViews=[NSArray arrayWithObjects:_ivClothes,_ivFood,_ivBed,_ivRiding,_ivMovie,_ivMusic,_ivDrink,_ivBook,_ivShopping,_ivGas,_ivRepair,_ivCross,_ivSport,_ivExpress,_ivTao,_ivElse,nil];
    
     _itemName=nil;
    
    [self initializeTap];
    
    //scrollView开场动画
    CABasicAnimation *scrAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
    
    scrAnimation.duration=0.6;
    
    CGPoint startPoint=CGPointMake(360, CGRectGetMaxY(self.view.bounds));
    
    scrAnimation.fromValue=[NSValue valueWithCGPoint:startPoint];
    
    scrAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [_largeScr.layer addAnimation:scrAnimation forKey:@"Up"];
    
}


-(void)totalCost
{
    self.totalCostLabel.text=[NSString stringWithFormat:@"%.2f元",[DataObject totalCost]];

}


-(void)initializeTap{
//1.选择消费图标手势
    for (int i=0; i<self.imageViews.count; i++) {
        //初始化Tap手势识别
        UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc]initWithTarget
                                               :self action
                                               :@selector(tapIcon:)];
        tapRecognizer.numberOfTapsRequired=1;
        //iv迭代imageViews
        UIImageView *iv=self.imageViews[i];
//        NSLog(@"tag: %li",iv.tag);
        //开启UIImageView用户交互功能
        iv.userInteractionEnabled=YES;
        //iv 添加Tap手势识别
        [iv addGestureRecognizer:tapRecognizer];
    }
}


-(void)tapIcon:(UIGestureRecognizer *)gestureRecognizer
{
    UIImageView *imageV=(UIImageView *)[gestureRecognizer view];
    
    //全部图标关闭高亮；
    for (UIImageView *ivHL in _imageViews) {
        [ivHL setHighlighted:NO];
    }
    
    //循环查找－被触摸的图标高亮
    for (int i=0; i<self.imageViews.count; i++) {
        
        UIImageView *iv=_imageViews[i];
        
        if (imageV.restorationIdentifier==iv.restorationIdentifier) {
            
            self.iconLabel.text=imageV.restorationIdentifier;
            
            self.itemName=imageV.restorationIdentifier;
            
            _iconImage.image=[UIImage imageNamed:
                              [NSString stringWithFormat:@"%@d",imageV.restorationIdentifier]];
//            NSLog(@"%@",self.itemName);
            [imageV setHighlighted:YES];
            
            CABasicAnimation *opacityAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
            
            opacityAnimation.fromValue=[NSNumber numberWithFloat:0.0];
            
            opacityAnimation.duration=0.8;
            
            opacityAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            
            [self.iconLabel.layer addAnimation:opacityAnimation forKey:@"LabelFadeIn"];
        }
    }
}


-(void)tapViewTimeMethod:(UIGestureRecognizer *)gestureRecognizer
{
    [_textFieldPay resignFirstResponder];
    
    [_timePickerView selectRow:[[DataObject checkTime:@"HH"]integerValue] inComponent:0 animated:NO];
    
    [_timePickerView selectRow:[[DataObject checkTime:@"mm"]integerValue] inComponent:1 animated:NO];

    [UIView animateWithDuration:0.06 animations:^{
        
        _viewTime.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
        
    } completion:^(BOOL finished) {
        
        _viewTime.backgroundColor=[UIColor whiteColor];
        
    }];
    
//    if (_largeScr.hidden==NO) {
    
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            CABasicAnimation *opacityAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
            
            opacityAnimation.fromValue=[NSNumber numberWithFloat:0.0];
            
            opacityAnimation.toValue=[NSNumber numberWithFloat:1.0];
            
            opacityAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            
            [_timePickerView.layer addAnimation:opacityAnimation forKey:@"LabelFadeIn"];
            
        } completion:^(BOOL finished) {
            
            _largeScr.hidden=YES;
            
            _largeScr.opaque=1;
            
            [UIView animateWithDuration:0.3 animations:^{
                
                _timePickerView.opaque=1.0;
                
            } completion:^(BOOL finished) {
                
                _timePickerView.hidden=NO;
            }];
            
        }];
//    }
}


-(void)tapTFMethod:(UIGestureRecognizer *)gestureRecognizer
{
    [_textFieldPay resignFirstResponder];
    
    [_timePickerView setHidden:YES];
    
    [UIView animateWithDuration:0.06 animations:^{
        
        _viewFirst.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
        
    } completion:^(BOOL finished) {
        
        _viewFirst.backgroundColor=[UIColor whiteColor];
        
    }];
    
    if (_largeScr.hidden==YES) {
    
       [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
           
           CABasicAnimation *opacityAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
           
           opacityAnimation.fromValue=[NSNumber numberWithFloat:0.0];
           
           opacityAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
           
           [_largeScr.layer addAnimation:opacityAnimation forKey:@"LabelFadeIn"];
 
//        _largeScr.opaque=1.0;
           
       } completion:^(BOOL finished) {
           
           _largeScr.hidden=NO;
           
       }];
    }
}

/*
- (IBAction)hideKeyBoard:(UIButton *)sender {
//    NSLog(@"hide");
    [self.textFieldPay resignFirstResponder];
}
*/

/*
- (IBAction)longPressGesture:(UILongPressGestureRecognizer *)sender {
    [self.textFieldPay resignFirstResponder];
    if ([sender isKindOfClass:[UILongPressGestureRecognizer class]]) {
        if(sender.state==UIGestureRecognizerStateBegan)
        {
            UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            
            UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            
            visualEffectView.tag=20;
            
            visualEffectView.frame = self.view.frame;
            
            [self.view addSubview:visualEffectView];
            
            UIActionSheet *actionSheet=[[UIActionSheet alloc ]initWithTitle:@"删除全部数据？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
            actionSheet.actionSheetStyle=UIActionSheetStyleAutomatic;
            [actionSheet showInView:self.view];
            NSLog(@"long Press");
        }
    }
}
*/

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    NSLog(@"Index: %ld",(long)buttonIndex);
    UIVisualEffectView *visualView=(UIVisualEffectView *)[self.view viewWithTag:20];
    
    if (buttonIndex==0) {
        
        [Item MR_truncateAll];
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        
        [visualView removeFromSuperview];
        
        [self totalCost];
    }
    else{
        
        [visualView removeFromSuperview];
    }
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChanged:)
                                                 name:UITextFieldTextDidChangeNotification object:nil];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _largeScr.alpha=0;
        
    } completion:^(BOOL finished) {
        
        _largeScr.hidden=YES;
        
        _timePickerView.hidden=YES;

        _timePickerView.opaque=1;
        
        _largeScr.alpha=1;
        
    }];
}


-(void)textFieldDidChanged:(NSNotification *)notification
{
    NSLog(@"TextFielf-Notification: %@",self.textFieldPay.text);
    
    _money=[self.textFieldPay.text floatValue];
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    _money= [textField.text floatValue];
    
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_largeScr.contentOffset.x >= self.view.bounds.size.width/2.0) {
        
        _pageControl.currentPage=1;
        
    }else{
        
        _pageControl.currentPage=0;
        
    }
}


- (IBAction)back:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (IBAction)save:(UIBarButtonItem *)sender {
    if (!self.itemName) {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Tips" message:@"请选择消费类型" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        if (self.money>0) {
            Item *item=[Item MR_createEntity];
            item.name=self.itemName;
            item.money=[NSNumber numberWithFloat:self.money];
            
            NSString *hour=_hourLabel.text;
            item.hour=[NSNumber numberWithInt:[hour intValue]];
            
            item.day=[DataObject checkTime:@"dd"];
            item.month=[DataObject checkTime:@"MM"];
            item.year=[DataObject checkTime:@"yyyy"];
            NSLog(@"year:%@",item.year);
            
            NSString *min=_minsLabel.text;
            item.minute=[NSNumber numberWithInt:[min intValue]];
            
            item.tag=[Item MR_numberOfEntities];
            NSLog(@"VC-Total: %@",item.tag);
            //            NSLog(@"VC-%@-%@ %@:%@",item.month ,item.day,item.hour,item.minute);
            [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"dataChanged" object:self];
            
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:self.itemName  message:[NSString stringWithFormat:@"%.2f",self.money]  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            self.textFieldPay.text=nil;
            [self totalCost];
            [self.textFieldPay resignFirstResponder];
        }else{
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:self.itemName  message:@"金额不能为空"  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
}


-(void)background
{
    CAGradientLayer *gLayer=[CAGradientLayer layer];
    
    gLayer.locations=@[@0.6];
    
    gLayer.colors=[NSArray arrayWithObjects:(id)[[UIColor colorWithRed:255/255.0 green:130/255.0 blue:110/255.0 alpha:1.0] CGColor],(id)[[UIColor whiteColor] CGColor], nil];
    
    gLayer.frame=self.view.bounds;
    
    gLayer.startPoint=CGPointMake(0.5,0 );
    
    gLayer.endPoint=CGPointMake(0.5, 1);
    
    [self.view.layer insertSublayer:gLayer atIndex:0];
    
    [_iconLabel setTextColor:[UIColor whiteColor]];

}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{

    return 3;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    if (component==0) {
        
        return _hours.count;
        
    }else{
    
        return _mins.count;
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component==0) {
        
        return [_hours objectAtIndex:row];
        
    }else{
        
        return [_mins objectAtIndex:row];
    }
}



-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
            
        _hourLabel.text=[_hours objectAtIndex:row];
    }else{
    
        _minsLabel.text=[_mins objectAtIndex:row];
    }
}


-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.textFieldPay.text=nil;
    
    [_textFieldPay resignFirstResponder];
    
    [_anmimationLabel.layer removeAllAnimations];
    
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
