//
//  CGRectMakeSingle.m
//  aide
//
//  Created by zl on 2018/6/6.
//  Copyright © 2018年 xym. All rights reserved.
//

#import "CGRectMakeSingle.h"
#import "XYYDoctorSDK.h"
@implementation CGRectMakeSingle
static CGRectMakeSingle *single = nil;


+ (CGRectMakeSingle *)share {
    if (single == nil) {
        
        single = [[CGRectMakeSingle alloc] init];
    }
    return single;
}

- (void)getXY {
    self.autoSizeX = SCREEN_WIDTH/375;
    
    self.autoSizeY = SCREEN_HEIGHT/667;
}
+ (CGRect)CGRectMakeCustoms:(CGRect)rect {
    
    CGRect Rect;
    
    Rect.origin.x = rect.origin.x * [CGRectMakeSingle share].self.autoSizeX;
    
    Rect.origin.y = rect.origin.y * [CGRectMakeSingle share].self.autoSizeY;
    
    Rect.size.width = rect.size.width * [CGRectMakeSingle share].self.autoSizeX;
    
    Rect.size.height = rect.size.height * [CGRectMakeSingle share].self.autoSizeY;
    
    return Rect;
}

@end
