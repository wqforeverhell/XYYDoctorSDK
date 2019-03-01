//
//  ChaxunViewController.h
//  yaolianti
//
//  Created by qxg on 2018/9/13.
//  Copyright © 2018年 hlw. All rights reserved.
//
typedef NS_ENUM(NSInteger,XYYSXListType){
    XYYSXListCF = 1 ,
    XYYSXListJZ = 2 ,
    XYYSXListWZ = 3,
    XYYSXListHZ = 4
};
#import "BaseViewController.h"

@class ChaxunViewController;
@protocol chaXunMessageDetegate <NSObject>
- (void)getChaxunMessageWithName:(NSString*)name phoneNum:(NSString*)phoneNum beginTime:(NSString*)beginTime endTime:(NSString*)endTime;
@end
@interface ChaxunViewController : BaseViewController
@property (nonatomic,assign) id<chaXunMessageDetegate>delegate;
@property (nonatomic,assign) XYYSXListType type;
@end
