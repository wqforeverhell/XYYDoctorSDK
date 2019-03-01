//
//  HuanzheCmd.m
//  yaolianti
//
//  Created by zl on 2018/6/12.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "HuanzheCmd.h"
#import "XYYDoctorSDKDef.h"
#import "ConfigUtil.h"
#import "BaseRespond.h"
@implementation GetDoctordoctorRefuseCmd
- (id) init {
    if (self = [super init]) {
        self.addr = @"doctor/refuse";
        self.hxLoginAccount=[ConfigUtil stringWithKey:LASTCHARTACCOUNT];
        self.respondType = [BaseRespond class];
        self.token = [ConfigUtil stringWithKey:APP_TOKEN];
    }
    return self;
}
@end

@implementation DoctorSponsoteCmd
- (id) init {
    if (self = [super init]) {
        self.addr = @"doctor/sponsote";
        self.token = [ConfigUtil  stringWithKey:APP_TOKEN];
    }
    return self;
}
@end

@implementation DoctorWorkToRestCmd
- (id)init {
    if (self = [super init]) {
        self.addr = @"doctor/rest";
        self.token = [ConfigUtil stringWithKey:APP_TOKEN];
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end
@implementation GetDoctordoctorCloseCmd
- (id)init {
    if (self = [super init]) {
        self.addr = @"doctor/close";
        self.token = [ConfigUtil stringWithKey:APP_TOKEN];
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end
@implementation DoctorRestToWorkCmd
- (id)init {
    if (self = [super init]) {
        self.addr = @"doctor/work";
        self.token = [ConfigUtil stringWithKey:APP_TOKEN];
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

@implementation DoctorTimeoutCmd
- (id)init {
    if (self = [super init]) {
        self.addr = @"doctor/timeout";
        self.token = [ConfigUtil stringWithKey:APP_TOKEN];
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end



@implementation GetYaoPinDetailListCmd
- (id)init {
    if (self = [super init]) {
        self.addr = @"doctor/storeBaseGoods/pageList";
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

@implementation GetListCmd
- (id)init {
    if (self = [super init]) {
        self.addr = @"hospDoctorTreatment/usageSelect";
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

@implementation SubmitChuFangCmd
- (id)init {
    if (self = [super init]) {
        self.addr = @"doctor/prescription/save";
        self.token = [ConfigUtil stringWithKey:APP_TOKEN];
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

@implementation submitPrescriptFreeMarkeCmd
- (id)init {
    if (self = [super init]) {
        self.addr = @"freemarker/submitPrescriptFreeMarker";
        self.token = [ConfigUtil stringWithKey:APP_TOKEN];
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end


@implementation MoBanCmd
- (id)init {
    if (self = [super init]) {
        self.addr = @"prescriptTemplate/templateList";
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

@implementation doctorRefreshCmd
- (id)init {
    if (self = [super init]) {
        self.addr = @"doctor/refresh";
        self.respondType = [BaseRespond class];
        self.token = [ConfigUtil stringWithKey:APP_TOKEN];
    }
    return self;
}
@end

@implementation GetPatientInfoCmd
- (id)init {
    if (self = [super init]) {
        self.addr = @"doctor/patientInfo";
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

@implementation GetStoreInfoByHxCmd
- (id)init {
    if (self = [super init]) {
        self.addr = @"doctor/storeInfo";
        self.respondType = [BaseRespond class];
        self.token = [ConfigUtil stringWithKey:APP_TOKEN];
    }
    return self;
}
@end

@implementation DiagnoseListCmd
- (id)init {
    if (self = [super init]) {
        self.addr = @"initialDiagnose/list";
        self.respondType = [BaseRespond class];
        self.token = [ConfigUtil stringWithKey:APP_TOKEN];
    }
    return self;
}
@end

@implementation SymptomCmd
- (id)init {
    if (self = [super init]) {
        self.addr = @"chiefComplaint/symptom";
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

@implementation HospDoctorPrescriptTemplateInsertCmd
- (id)init {
    if (self = [super init]) {
        self.addr = @"hospDoctorPrescriptTemplate/insert";
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

@implementation HospDoctorPrescriptTemplateListCmd
- (id)init {
    if (self = [super init]) {
        self.addr = @"hospDoctorPrescriptTemplate/list";
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

@implementation HospDoctorPrescriptTemplateDeleteCmd
- (id)init {
    if (self = [super init]) {
        self.addr = @"hospDoctorPrescriptTemplate/delete";
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

@implementation HospDoctorPrescriptTemplateUpdateCmd
- (id)init {
    if (self = [super init]) {
        self.addr = @"hospDoctorPrescriptTemplate/update";
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

@implementation AcceptVedioCmd
- (id)init {
    if (self = [super init]) {
        self.addr = @"doctor/acceptVedio";
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

@implementation PharmacistPrescriptionListCmd
- (id)init {
    if (self = [super init]) {
        self.addr = @"pharmacistPrescription/list";
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

@implementation PharmacistPrescriptionCheckCmd
- (id)init {
    if (self = [super init]) {
        self.addr = @"pharmacistPrescription/check";
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

