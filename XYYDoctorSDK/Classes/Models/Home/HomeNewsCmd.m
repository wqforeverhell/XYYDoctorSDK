//
//  HomeNewsCmd.m
//  yaolianti
//
//  Created by qxg on 2018/12/15.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "HomeNewsCmd.h"
#import "StringUtil.h"
#import "ConfigUtil.h"
#import "BaseRespond.h"
#import "XYYSDK.h"
@implementation NewCollectionbriefListCmd
- (id) init {
    if (self = [super init]) {
        self.addr = @"newCollection/briefList";
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end
