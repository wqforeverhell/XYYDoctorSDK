//
//  BaseRespond
//
//  Created by hlw on 14-10-19.
//  Copyright (c) 2014年 CXZ. All rights reserved.
//

#import "BaseRespond.h"

@implementation BaseRespond

- (instancetype)initWithJsonData:(NSDictionary *)jsonData {
    if (jsonData != nil && [jsonData count] > 0 && (self = [super initWithDictionary:jsonData])) {
        self.data=jsonData;
    }
    return self;
}

- (id)initWithDic:(NSData*)jsonData{
    NSError* error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];

    return dic;
}


- (Class)data_class:(NSNumber*)index {
    return [NSDictionary class];
}

@end
