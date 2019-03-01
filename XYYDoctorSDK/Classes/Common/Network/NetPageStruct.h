//
//  NetPageStruct.h
//  Drugdisc
//
//  Created by 黄黎雯 on 2017/7/11.
//  Copyright © 2017年 Drugdisc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PageParams : NSObject
@property(nonatomic, strong) NSMutableArray* result;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) int num;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, assign) BOOL didLoaded;
@end
