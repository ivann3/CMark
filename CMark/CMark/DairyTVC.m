//
//  DairyTVC.m
//  CMark
//
//  Created by Ivan on 14/12/24.
//  Copyright (c) 2014年 one. All rights reserved.
//

#import "DairyTVC.h"
#import "DairyTVCell.h"
#import "EditVC.h"
#import "Item.h"
#import "navigationC.h"


@interface DairyTVC ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addBtn;

- (IBAction)add:(UIBarButtonItem *)sender;

@property(nonatomic,strong)NSMutableArray *data;

@end

@implementation DairyTVC
{
    NSString *month;
    NSString *day;
    NSString *hour;
    NSString *minute;
    NSNumber *today;
    
    UIRefreshControl *refresh;
}


-(void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChanged:) name:@"dataChanged" object:nil];
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.tintColor=[UIColor colorWithRed:1.0 green:0.4 blue:00 alpha:0.8];
    
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:252.0/255 green:101.0/255 blue:101.0/255 alpha:1.0];
    
    self.navigationController.navigationBar.titleTextAttributes =[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:19.0],NSFontAttributeName ,nil];
    
    //根据tableview的数据更新，同步更新tableView表格的显示
    
    today=[DataObject checkTime:@"dd"];

    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
        
    [self titleAnimation:0.4];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _data=[NSMutableArray arrayWithCapacity:20];
    
    int count =[[NSString stringWithFormat: @"%@",[Item MR_numberOfEntities]] intValue];
    NSLog(@"DairyTVC-int count: %i",count);
    
        for (int i=1; i<=count; i++) {
            [_data addObject:([Item MR_findAll][count-i])];
//                        NSLog(@"_data:%@",_data);
            if (i==20) break;
        }
    
    refresh=[[UIRefreshControl alloc]init];
    
    refresh.frame=CGRectMake(self.view.frame.size.width/2.0, 50, 0, 0);
    
    refresh.tintColor=[UIColor clearColor];
    
    refresh.attributedTitle=[[NSAttributedString alloc]initWithString:@"Tips"];
    
    [refresh addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:refresh];
    
}

-(void)refresh:(UIEvent *)event
{
    NSLog(@"Refresh");
    
    [refresh endRefreshing];
}


-(void)dataChanged:(NSNotification *)notification
{
    int count =[[NSString stringWithFormat: @"%@",[Item MR_numberOfEntities]] intValue];
    
    NSLog(@"_data.count:%lu",(unsigned long)_data.count);
    if (_data.count>1) {
        if (_data.count>20) {
            [_data removeLastObject];
            [_data insertObject:([Item MR_findAll][count-1]) atIndex:0];
        }
        [_data insertObject:([Item MR_findAll][count-1]) atIndex:0];
    }
    else{
        
        [_data addObject:([Item MR_findAll][count-1])];
    }
//    self.navigationController.tabBarItem.badgeValue=@"1";

    NSLog(@"Recieved notification");
}


-(void)viewWillDisappear:(BOOL)animatedd
{
    [super viewWillDisappear:animatedd];
//    if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]) {
//        NSLog(@"willDisappear");
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_data count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DairyTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dairyCell" forIndexPath:indexPath];
    
    if (!cell) {
        cell=[[DairyTVCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dairyCell"];
    }
    
    if (_data) {
        Item *item=_data[indexPath.row];
        
        if([item.month intValue]<10)
            month=[NSString stringWithFormat:@"0%@",item.month];
        else
            month=[NSString stringWithFormat:@"%@",item.month];
        
        if([item.day intValue]<10)
            day=[NSString stringWithFormat:@"0%@",item.day];
        else
            day=[NSString stringWithFormat:@"%@",item.day];
        
        if ([item.day isEqualToNumber:today]) {
//            cell.dayLabel.textColor=[UIColor colorWithRed:1.0f green:0.4f blue:0.0f alpha:1.0f];
//            cell.timeLabel.textColor=[UIColor colorWithRed:1.0f green:0.4f blue:0.0f alpha:1.0f];
        }
        cell.dayLabel.text=[NSString stringWithFormat:@"%@月%@日",month,day];
        
        if([item.hour intValue]<10)
            hour=[NSString stringWithFormat:@"0%@",item.hour];
        else
            hour=[NSString stringWithFormat:@"%@",item.hour];
        if([item.minute intValue]<10)
            minute=[NSString stringWithFormat:@"0%@",item.minute];
        else
            minute=[NSString stringWithFormat:@"%@",item.minute];
        
        cell.timeLabel.text=[NSString stringWithFormat:@"%@:%@",hour,minute];
        
        cell.moneyLabel.text=[NSString stringWithFormat:@"%@：%@元",item.name,item.money];
        
        NSString *imageStr=[NSString stringWithFormat:@"%@d",item.name];
        
        cell.iconImageView.image=[UIImage imageNamed:imageStr];
        
        //    NSLog(@"cell");
    }
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *button1=[UITableViewRowAction  rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        //获取该cell的indexPath号
        Item *item =_data[indexPath.row];
        NSArray *array=[Item MR_findByAttribute:@"tag" withValue:item.tag];
        
        //1.删除数据库中的制定条目
        [array [0] MR_deleteEntity];
//        NSLog(@"array:%@",array);
        //保存数据
        [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
        
        //2.删除tableView 数组中对应的数据库条目
        [_data removeObjectAtIndex:indexPath.row];
        
        //3.更新tableView显示
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

        NSLog(@"After Delete Total:%@",[Item MR_numberOfEntities]);
    }];
    
    UITableViewRowAction *button2=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"修改" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        NSLog(@"Button2");
        
        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        navigationC *editNC=[storyBoard instantiateViewControllerWithIdentifier:@"editNC"];
        
        editNC.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
        
        EditVC *editVC=[storyBoard instantiateViewControllerWithIdentifier:@"editVC"];
        
        [self presentViewController:editNC animated:YES completion:^{

        //进入模态视图后，才设置delegate
        self.delegate=editVC;
            
        //发送代理方法
        [self.delegate editItem:[_data objectAtIndex:indexPath.row]];
        
        
        }];
        

    }];
    
    button2.backgroundColor=[UIColor colorWithRed:0.9 green:0.6 blue:0.9 alpha:1.0];

    
    return @[button1,button2];
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSLog(@"log");
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UILabel *label=[[UILabel alloc]init];
//    
//    label.frame=CGRectMake(5, 0, 50, 2);
//    
////    label.text=@"Header";
//    
//    label.backgroundColor=[UIColor yellowColor];
//    
//    label.textAlignment=NSTextAlignmentLeft;
//    
//    return label;
//}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


-(void)titleAnimation:(float)duration
{
    UILabel *titleLabel=[[UILabel alloc]init];
    
    titleLabel.frame=CGRectMake(0, 0, 80, 40);
    
    titleLabel.text=@"最近消费";
    
    titleLabel.font=[UIFont systemFontOfSize:19];
    
    titleLabel.textColor=[UIColor whiteColor];
    
    self.navigationItem.titleView=titleLabel;
    
    CABasicAnimation *opacityAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    
    opacityAnimation.fromValue=[NSNumber numberWithFloat:0.1];
    
    opacityAnimation.duration=duration;
    
    opacityAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [titleLabel.layer addAnimation:opacityAnimation forKey:@"titleLabel"];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prepareForSegue");
}


- (IBAction)add:(UIBarButtonItem *)sender {
    
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
     navigationC *addNC=[storyBoard instantiateViewControllerWithIdentifier:@"addNC"];
    
    addNC.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:addNC animated:YES completion:^{
        
    }];
    
}
@end
