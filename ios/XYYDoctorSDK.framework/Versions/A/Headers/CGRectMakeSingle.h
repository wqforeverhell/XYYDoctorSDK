//
//  CGRectMakeSingle.h
//  aide
//
//  Created by zl on 2018/6/6.
//  Copyright © 2018年 xym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGRectMakeSingle : NSObject
@property float autoSizeScaleX;

@property float autoSizeScaleY;

@property float autoSizeX;

@property float autoSizeY;

+ (CGRectMakeSingle *)share;

- (void)getXY;

+ (CGRect)CGRectMakeCustoms:(CGRect)rect;

@end
