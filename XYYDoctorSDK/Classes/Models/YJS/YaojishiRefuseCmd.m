//
//  YaojishiRefuseCmd.m
//  yaolianti
//
//  Created by qxg on 2018/12/15.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "YaojishiRefuseCmd.h"
#import "BaseRespond.h"
#import "XYYSDK.h"
@implementation DiseaseTypeselectCmd
- (id) init {
    if (self = [super init]) {
        self.addr = @"pharmacist/diseaseType/select";
        self.respondType = [BaseRespond class];
    }
    return self;
}

@end

@implementation PharmacistrefuseReasoninsertCmd
- (id) init {
    if (self = [super init]) {
        self.addr = @"pharmacist/refuseReason/insert";
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

@implementation PharmacistrefuseReasongroupselectCmd
- (id) init {
    if (self = [super init]) {
        self.addr = @"pharmacist/refuseReason/group/select";
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

@implementation DoctorprescriptiontraceCmd
- (id) init {
    if (self = [super init]) {
        self.addr = @"doctor/prescription/trace";
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end
