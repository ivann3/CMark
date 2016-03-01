//
//  PickViewVC.m
//  CMark
//
//  Created by Ivan on 15/1/26.
//  Copyright (c) 2015年 one. All rights reserved.
//

#import "PickViewVC.h"

@interface PickViewVC ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pkView;

@property (weak, nonatomic) IBOutlet UIPickerView *pkView2;

- (IBAction)leftButton:(id)sender;

- (IBAction)rightBtn:(UIBarButtonItem *)sender;

@end

@implementation PickViewVC
{
    NSArray *_day;
    
    NSArray *_week;
    
    NSArray *_month;
    
    NSArray *_year;
    
    NSUserDefaults *userDefault;

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UILabel *label=[[UILabel alloc]init];
    
    label.frame=CGRectMake(0, 0, 60, 40);
    
    label.textColor=[UIColor whiteColor];
    
    label.textAlignment=NSTextAlignmentCenter;
    
    label.text=@"范围";
    
    self.navigationItem.titleView=label;
    
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:60.0/255 green:130.0/255 blue:160.0/255 alpha:1.0];
    
    [_pkView selectRow:[self indexInArray:_day name:@"dayValue"] inComponent:0 animated:NO  ];
    
    [_pkView selectRow:[self indexInArray:_week name:@"weekValue"] inComponent:1 animated:NO  ];
    
    [_pkView2 selectRow:[self indexInArray:_month name:@"monthValue"] inComponent:0 animated:NO  ];
    
    [_pkView2 selectRow:[self indexInArray:_year name:@"yearValue"] inComponent:1 animated:NO  ];



}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    userDefault=[NSUserDefaults standardUserDefaults];

    self.pkView.delegate=self;
    
    self.pkView.dataSource=self;
    
    self.pkView2.delegate=self;
    
    self.pkView2.dataSource=self;
    
    _day=[NSArray arrayWithObjects:@"100",@"250",@"500",@"1000",@"1500",@"2000",@"2500",@"3000",@"3500",@"4000",@"4500",@"5000",@"5500",@"6000", nil];
    
    _week=[NSArray arrayWithObjects:@"500",@"1000",@"1500",@"2500",@"3500",@"5500",@"6500",@"7500", nil];

    _month=[NSArray arrayWithObjects:@"1500",@"2500",@"3500",@"5000",@"7500",@"10000",nil];

    _year=[NSArray arrayWithObjects:@"30000",@"50000",@"100000",@"150000",@"250000",@"350000",@"6000000", @"1000000",nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger i = 0;
    
    if ([pickerView isEqual:_pkView]) {
    
        switch (component) {
            case 0:
    
                i=_day.count;
                break;
            case 1:
            
                i=_week.count;
                break;
    
            default:
                i=0;
                break;
        }
    }else{
        
        switch (component) {
            case 0:
                
                i=_month.count;
                break;
            case 1:
                
                i=_year.count;
                break;
                
            default:
                i=0;
                break;
        }
    }

    return i;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *name;
    
    if ([pickerView isEqual:_pkView]) {
        
        switch (component) {
            case 0:
                name=nil;
                name=[_day objectAtIndex:row];
                break;
            
            case 1:
                name=nil;
                name=[_week objectAtIndex:row];
                break;
            
            default:
                name=0;
                break;
        }
    }else{
        
        switch (component) {
            case 0:
                name=nil;
                name=[_month objectAtIndex:row];
                break;
                
            case 1:
                name=nil;
                name=[_year objectAtIndex:row];
                break;
                
            default:
                name=0;
                break;
        }
    
    }
    return [NSString stringWithFormat:@"%@元",name];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if ([pickerView isEqual:_pkView]) {
        switch (component) {
                
            case 0:
                [userDefault setValue:[_day objectAtIndex:row] forKey:@"dayValue"];
                
//                NSLog(@"%@",[userDefault valueForKey:@"dayValue"]);

                break;
                
            case 1:
                [userDefault setValue:[_week objectAtIndex:row] forKey:@"weekValue"];
                
//                NSLog(@"%@",[userDefault valueForKey:@"weekValue"]);

                break;
                
            default:
                break;
        }
    }else{
        switch (component) {
                
            case 0:
                [userDefault setValue:[_month objectAtIndex:row] forKey:@"monthValue"];
                
//                NSLog(@"%@",[userDefault valueForKey:@"monthValue"]);
                break;
                
            case 1:
                [userDefault setValue:[_year objectAtIndex:row] forKey:@"yearValue"];
                
//                NSLog(@"%@",[userDefault valueForKey:@"yearValue"]);

                break;
                
            default:
                break;
        }
    }

}

-(NSInteger)indexInArray:(NSArray *)array name:(NSString *)name
{
    NSInteger index=0;
    
    NSNumber *value=[userDefault valueForKey:name];
    
    for (int i=0; i<array.count; i++) {
        
        if ([value isEqual:array[i]]) {
            
            index=i;
            break;
        }
    }
    
    return index;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (IBAction)leftButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)rightBtn:(UIBarButtonItem *)sender {
    
    [userDefault synchronize];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
