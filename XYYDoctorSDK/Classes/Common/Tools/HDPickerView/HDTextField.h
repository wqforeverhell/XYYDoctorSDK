//
//  HDTextField.h
//  InputTableViewDemo
//
//  Created by Hou on 17/6/19.
//  Copyright © 2017年 HoHoDoDo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDTextField : UITextField
@property (nonatomic, strong)UIColor *placeHolderColor;
@end

/******************************* UIResponder (Category) **********************************/

@interface UIResponder (HDCategory)
+ (id)currentFirstResponder;
@end
