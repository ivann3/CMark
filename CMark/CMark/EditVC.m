//
//  EditVC.m
//  CMark
//
//  Created by Ivan on 14/12/31.
//  Copyright (c) 2014年 one. All rights reserved.
//

#import "EditVC.h"
#import "ScrollV.h"
#import "Item.h"
#import "LabelEdit.h"

@interface EditVC ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet ScrollV *scrollView;

- (IBAction)back:(UIBarButtonItem *)sender;

- (IBAction)saveBarButtonItem:(UIBarButtonItem *)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBarButtonItem;

- (IBAction)keyBoardHideBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIPickerView *pkerView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end


@implementation EditVC
{
    NSMutableArray *array;
    
    CGPoint oldOffest;
    
    NSNumber *_tag;
    
    NSString *_name;
    
    NSNumber *_money;

}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [self.saveBarButtonItem setEnabled:NO];
        
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:60.0/255 green:130.0/255 blue:160.0/255 alpha:1.0];
    
    self.navigationController.navigationBar.titleTextAttributes =[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:20.0],NSFontAttributeName ,nil];
    
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    self.title=@"修改";
    
    self.scrollView.contentSize =CGSizeMake(0, CGRectGetHeight(self.view.bounds)+200);
    
    self.scrollView.scrollEnabled=NO;
    
    NSString *imageName=[NSString stringWithFormat:@"%@d",array[0]];
    
    _imageView.image=[UIImage imageNamed:imageName];
    
}


-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyBoardShow:)
                                                name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyBoardHide:)
                                                name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChanged:)
                                                 name:UITextFieldTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(infoChanged:)
                                                name:@"InfoChanged" object:nil];
    
}

-(void)keyBoardShow:(NSNotification *)notification
{
    oldOffest=self.scrollView.contentOffset;
    
    NSDictionary *dict=[notification userInfo];
//    NSLog(@"userInfo:%@",dict);
    
    CGRect rect=[[dict objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    NSLog(@"Rect: %@",NSStringFromCGRect(rect));
    
    rect=[self.scrollView convertRect:rect fromView:nil];
    
    CGRect f=self.view.bounds;
    
    CGFloat y=CGRectGetMaxY(f) + rect.size.height - self.scrollView.bounds.size.height ;
    
    if (rect.origin.y < CGRectGetMaxY(f)) {
        [self.scrollView setContentOffset:CGPointMake(0, y) animated:YES];
    }
}

-(void)keyBoardHide:(NSNotification *)notification
{
    [self.scrollView setContentOffset:oldOffest animated:YES];
}

-(void)editItem:(Item *)item
{
    //自定义notification 里携带userInfo信息
    NSNotification *n=[NSNotification notificationWithName:@"InfoChanged"
                                                    object:self
                                                  userInfo:@{@"name":item.name,@"money":item.money,@"tag":item.tag}];
    
    [[NSNotificationCenter defaultCenter]postNotification:n];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    array=[NSMutableArray arrayWithCapacity:16];
    
    array=[NSMutableArray arrayWithObjects:@"出行",@"电影",@"加油",@"快递",@"美食",@"其它费用",@"日常购物",@"书籍",@"网购",@"维护",@"药品",@"衣服鞋袜",@"饮品",@"运动",@"住宿",@"KTV", nil];

    _pkerView.delegate=self;
    
    _pkerView.dataSource=self;
    
    _pkerView.showsSelectionIndicator=YES;
    
    _textField.delegate=self;
    
}

- (IBAction)keyBoardHideBtn:(UIButton *)sender {
    
    [self.textField resignFirstResponder];
    
}

-(void)textFieldDidChanged:(NSNotification *)notification
{
//    NSLog(@"%@",_textField.text);
    [_saveBarButtonItem setEnabled:YES];
    
    float moneyFloat=[_textField.text floatValue];
    
    _money=[NSNumber numberWithFloat:moneyFloat];
    
    NSLog(@"_money:%@",_money);
    
}

-(void)infoChanged:(NSNotification *)notification
{
    
//    NSLog(@"%@",[notification userInfo]);
    
    NSString *string=[[notification userInfo]objectForKey:@"name"];
    
    NSInteger interger=0;
    for (int i=0; i<array.count; i++) {
        if ([string isEqualToString:array[i]]) {
            interger=i;
//            NSLog(@"%li",(long)interger);
        }
    }
    
    [self.pkerView selectRow:interger inComponent:0 animated:YES];
    
    self.imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@d",string]];
    
    self.textField.text=[[[notification userInfo]objectForKey:@"money"] stringValue];
    
    _tag=[[notification userInfo]objectForKey:@"tag"];
    
    _name=[[notification userInfo]objectForKey:@"name"];
    
    _money=[[notification userInfo]objectForKey:@"money"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.textField resignFirstResponder];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"%@",_money);
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    float moneyFloat=[_textField.text floatValue];
    
    _money=[NSNumber numberWithFloat:moneyFloat];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [array count];
}

/*
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [array objectAtIndex:row];
}
*/

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component;
{
    return 44;
}


-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel *label=(UILabel *)view;
    
    if (!label) {
        
        label=[[UILabel alloc]init];
        
        label.frame=CGRectMake(label.superview.frame.size.width/2.0, 0, 0, 50);
        
        label.text=[array objectAtIndex:row];
        
        label.textAlignment=NSTextAlignmentCenter;
        
        label.textColor=[UIColor whiteColor];
        
        label.font=[UIFont systemFontOfSize:20.0 ];
        
        label.backgroundColor=[UIColor colorWithRed:1.0 green:0.4 blue:0.0 alpha:0.7];
        
//        UIImageView *imageView=[[UIImageView alloc]init];
//        
//        imageView.frame=CGRectMake(0, 5, 290, 40);
//        
//        imageView.tintColor=[UIColor whiteColor];
//                
//        imageView.image=[UIImage imageNamed:@"frame"];
//        
//        [label addSubview:imageView];
    }
    
    return label;
    
//    LabelEdit *label=(LabelEdit *)view;
//    
//    if (!label) {
//        
//        label=[[LabelEdit alloc]init];
//        
//        label.frame=CGRectMake(label.superview.frame.size.width/2.0, 0, 0, 50);
//        
//        label.text=[array objectAtIndex:row];
//        
//        label.textAlignment=NSTextAlignmentCenter;
//        
//        label.textColor=[UIColor redColor];
//        
//        label.font=[UIFont systemFontOfSize:20.0 ];
//        
////        label.backgroundColor=[UIColor colorWithRed:1.0 green:0.4 blue:0.0 alpha:0.7];
//    }
//    
//    return label;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *imageName=[NSString stringWithFormat:@"%@d",[array objectAtIndex:row]];
    
    _name=[array objectAtIndex:row];
    
    _imageView.image=[UIImage imageNamed:imageName];
    
    [_saveBarButtonItem setEnabled:YES];
    
    NSLog(@"_name:%@",_name);
}

- (IBAction)back:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)saveBarButtonItem:(UIBarButtonItem *)sender
{
    if (_saveBarButtonItem.enabled==YES) {
        
        NSArray *tagArray=[Item MR_findByAttribute:@"tag" withValue:_tag];
        
        Item *item = [tagArray firstObject];
        
        item.name=_name;
        
        item.money=_money;
        
        [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

@end
