//
//  ListTableViewController.m
//  ColorMark
//
//  Created by Ivan on 14/12/11.
//  Copyright (c) 2014年 one. All rights reserved.
//

#import "ListTableViewController.h"
#import "ListTableViewCell.h"


@interface ListTableViewController ()

@property (strong,nonatomic)NSArray *imageViewName;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingLeftBtn;

@end

@implementation ListTableViewController



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
    
    [self.navigationController setNavigationBarHidden:NO];
    
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:252.0/255 green:101.0/255 blue:101.0/255 alpha:1.0];
    
    self.navigationController.navigationBar.titleTextAttributes =[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:19.0],NSFontAttributeName ,nil];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    NSLog (@"ViewDidAppear");
    
    [self titleAnimation:0.4];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageViewName=[[NSArray alloc]init];
    
    [self setupImageViews];
    
//    NSLog(@"%lu",(unsigned long)[self.imageViewName count]);
    
    
}


-(void)setupImageViews{
    //1.图片名放入数组
    _imageViewName=[NSArray arrayWithObjects:@"全部",@"衣服鞋袜",@"美食",@"住宿",@"出行", @"电影",@"KTV",
                    @"饮品",@"书籍",@"日常购物",@"加油",@"维护",@"药品",@"运动",@"快递",@"网购",@"其它费用",nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];

}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_imageViewName count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell"
                                                            forIndexPath:indexPath];
    if (!cell) {
        cell=[[ListTableViewCell alloc ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"listCell"];
    }
    // Configure the cell...
    cell.iconImage.image=[UIImage imageNamed:[_imageViewName objectAtIndex:indexPath.row]];
    
    cell.describeLabel.text=[_imageViewName objectAtIndex:indexPath.row];
    
    cell.rightImage.image=[UIImage imageNamed:@"Next"];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}


//点击Cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *detailVC=[storyBoard instantiateViewControllerWithIdentifier:@"detailVC"];
    
    detailVC.title=[_imageViewName objectAtIndex:indexPath.row];
    
//    self.navigationController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    
    [self.navigationController pushViewController:detailVC animated:YES];

}


-(void)titleAnimation:(float)duration
{
    UILabel *titleLabel=[[UILabel alloc]init];
    
    titleLabel.frame=CGRectMake(0, 0, 80, 40);
    
    titleLabel.text=@"详细账单";
    
    titleLabel.font=[UIFont systemFontOfSize:19];
    
    titleLabel.textColor=[UIColor whiteColor];
    
    self.navigationItem.titleView=titleLabel;
    
    CABasicAnimation *opacityAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    
    opacityAnimation.fromValue=[NSNumber numberWithFloat:0.1];
    
    opacityAnimation.duration=duration;
    
    opacityAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [titleLabel.layer addAnimation:opacityAnimation forKey:@"titleLabel"];
    
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    
}










@end
