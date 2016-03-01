//
//  ViewController.h
//  ColorMark
//
//  Created by Ivan on 14/12/10.
//  Copyright (c) 2014年 one. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol dataDelegate <NSObject>

@optional

-(void)recentData:(NSArray *)recentDataArray;

@end

@interface ViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic,assign) id <dataDelegate> dataDelegate;

@end

