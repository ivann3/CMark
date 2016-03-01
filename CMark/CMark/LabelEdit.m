//
//  LabelEdit.m
//  CMark
//
//  Created by Ivan on 15/1/19.
//  Copyright (c) 2015年 one. All rights reserved.
//

#import "LabelEdit.h"

@implementation LabelEdit

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)init
{

    self=[super init];
    
    if (self) {
        
        UIImageView *imageView=[[UIImageView alloc]init];
        
        imageView.frame=CGRectMake(0, 5, 290, 40);
        
        imageView.tintColor=[UIColor blueColor];
        
        imageView.image=[UIImage imageNamed:@"frame"];
        
        [self addSubview:imageView];
        
    }
    
    return self;
}



@end
