//
//  SelectTimeGyq.h
//  jiaMai
//
//  Created by 黄黎雯 on 2016/12/3.
//  Copyright © 2016年 cxz. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^onDoneDateBlock)(NSString *time);
@interface YPpickViewModel : NSObject
@property(nonatomic, strong) NSString* timeYone;
@property(nonatomic, strong) NSString* timeYtwo;
@property(nonatomic, strong) NSString* timeM;
@property(nonatomic, strong) NSString* timeD;
@end
@interface HLWSelectTimeGyq : UIView

-(void)setIndex:(NSString*)index;
-(void)setOnDoneBlock:(onDoneDateBlock)block;
-(void)show;
-(void)dissmis;
@end
