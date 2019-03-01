//
//  NetPageStruct.m
//  Drugdisc
//
//  Created by 黄黎雯 on 2017/7/11.
//  Copyright © 2017年 Drugdisc. All rights reserved.
//

#import "NetPageStruct.h"

@implementation PageParams
- (id)init {
    self = [super init];
    _num = 10;
    _page = 0;
    _hasMore = YES;
    _result = [NSMutableArray array];
    _didLoaded = NO;
    return self;
}

@end
