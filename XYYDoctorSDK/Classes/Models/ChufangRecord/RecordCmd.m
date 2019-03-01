//
//  RecordCmd.m
//  yaolianti
//
//  Created by zl on 2018/6/12.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "RecordCmd.h"
#import "BaseRespond.h"
#import "XYYSDK.h"
#import "ConfigUtil.h"
@implementation GetPrescriptionListByCmd
- (id)init {
    if (self = [super init]) {
        self.addr = @"doctor/prescription/list";
        self.token = [ConfigUtil stringWithKey:APP_TOKEN];
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

@implementation GetPrescriptionListWithDetailCmd
- (id)init {
    if (self = [super init]) {
        self.addr = @"doctor/prescription/detail";
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

@implementation PrescriptFreeMarkerCmd
- (id)init {
    if (self = [super init]) {
        self.addr = @"freemarker/appPrescriptFreeMarker";
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

@implementation GetHistroyPrescriptionListByCmd
- (id)init {
    if (self = [super init]) {
        self.addr = @"doctor/prescription/app/list";
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

