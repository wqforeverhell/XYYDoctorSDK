//
//  UserCmd.m
//  yaolianti
//
//  Created by zl on 2018/6/11.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "UserCmd.h"
#import "StringUtil.h"
#import "ConfigUtil.h"
#import "BaseRespond.h"
#import "XYYSDK.h"
@implementation AppLoginCmd
- (id) init {
    if (self = [super init]) {
        self.addr = @"doctorWebLoginAccount/doctorLogin/app";
        self.deviceName = [StringUtil iphoneType];
        self.appId = @"yaolianti";
        self.deviceVersion = [UIDevice currentDevice].systemVersion;
        self.deviceType = 1;
//        self.loginAccount = @"张三";
//        self.pwd = @"D06DFB926364FC22A875D47CD32936EC";
        self.deviceToken = [ConfigUtil stringWithKey:DEVICETOKEN];
        
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

@implementation GetDoctorCurrentStatusCmd
- (id) init {
    if (self = [super init]) {
        self.addr = @"doctor/initData";
        self.token = [ConfigUtil stringWithKey:APP_TOKEN];
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

@implementation GetUserDetailCmd
- (id) init {
    if (self = [super init]) {
        self.addr = @"doctor/currentAccountInfo";
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

@implementation uploadSignatureCmd
- (id) init {
    if (self = [super init]) {
        self.addr = @"fileUpload/uploadSignature";
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end


@implementation DoctorWtihExitLoginCmd
- (id) init {
    if (self = [super init]) {
        self.addr = @"doctorWebLoginAccount/doctorLoginOut";
        self.token = [ConfigUtil stringWithKey:APP_TOKEN];
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

@implementation ExtractWithDoctorRecordCmd
- (id) init {
    if (self = [super init]) {
        self.addr = @"hospDoctorAccountManage/findapplyWithDrawRecord";
        self.token = [ConfigUtil stringWithKey:APP_TOKEN];
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

@implementation IncommingWithDoctorCmd
- (id) init {
    if (self = [super init]) {
        self.addr = @"hospDoctorAccountManage/diagnoseOrRedPactetNotWithdrawList";
        self.token = [ConfigUtil stringWithKey:APP_TOKEN];
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

@implementation LastincomingCmd
- (id) init {
    if (self = [super init]) {
        self.addr = @"doctor/incoming/last";
        self.token = [ConfigUtil stringWithKey:APP_TOKEN];
        self.respondType = [BaseRespond class];
    }
    return self;
}

@end

@implementation LastExtractCmd
- (id) init {
    if (self = [super init]) {
        self.addr = @"doctor/extract/last";
        self.token = [ConfigUtil stringWithKey:APP_TOKEN];
        self.respondType = [BaseRespond class];
    }
    return self;
}

@end

@implementation HospDoctorAccountManageCmd
- (id) init {
if (self = [super init]) {
    self.addr = @"hospDoctorAccountManage/doctorWithDraw";
    self.token = [ConfigUtil stringWithKey:APP_TOKEN];
    self.withdrawPassword = @"999";
    self.respondType = [BaseRespond class];
}
    return self;
}

@end
//医院列表
@implementation FindHospitalListCmd
- (id) init {
    if (self = [super init]) {
        self.addr = @"hospitalAndDepartment/findHospital";
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end
//科室列表

@implementation FindDepartmentCmd
- (id) init {
    if (self = [super init]) {
        self.addr = @"/hospitalAndDepartment/findDepartment";
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

@implementation UserCodeCmd
- (id) init {
    if (self = [super init]) {
        self.addr = @"doctor/getMessageCode";
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

@implementation UserUploadIamge
- (id) init {
    if (self = [super init]) {
        self.addr = @"fileUpload/uploadPicture";
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

@implementation DoctorRegisterCmd
- (id) init {
    if (self = [super init]) {
        self.addr = @"/doctor/registe";
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

@implementation updatePasswordCmd
- (id) init {
    if (self = [super init]) {
        self.addr = @"doctor/updatePassword";
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

@implementation EditUserInfoCmd
- (id) init {
    if (self = [super init]) {
        self.addr = @"doctor/app/updateAccountInfo";
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

@implementation saveCertificationInfoCmd
- (id) init {
    if (self = [super init]) {
        self.addr = @"doctor/saveCertificationInfo";
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

@implementation getValidateInfoCmd
- (id) init {
    if (self = [super init]) {
        self.addr = @"doctorValidate/getValidateInfo";
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

@implementation ForgetPwdCmd
- (id) init {
    if (self = [super init]) {
        self.addr = @"doctor/forgetPwd";
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

@implementation GetClinicalRecordListCmd
- (id) init {
    if (self = [super init]) {
        self.addr = @"doctorRecord/getClinicalRecordList";
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

@implementation GetInquiryRecordCmd
- (id) init {
    if (self = [super init]) {
        self.addr = @"doctorRecord/inquiryRecord";
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end

@implementation GetMyPatientRecordCmd
- (id) init {
    if (self = [super init]) {
        self.addr = @"doctorRecord/myPatientRecord";
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end


@implementation GetPatientHealthCmd
- (id) init {
    if (self = [super init]) {
        self.addr = @"patientHealth/getPatientHealth";
        self.respondType = [BaseRespond class];
    }
    return self;
}
@end
