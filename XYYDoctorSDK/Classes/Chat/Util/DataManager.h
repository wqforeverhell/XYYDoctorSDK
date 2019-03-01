//
//  DataManager.h
//  CloudXinDemo
//
//  Created by mango on 16/8/26.
//  Copyright © 2016年 mango. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>
#import <NIMAVChat/NIMAVChat.h>
#import "NIMKit.h"


@interface DataManager : NSObject<NIMKitDataProvider>

+ (instancetype)sharedInstance;

@property (nonatomic,strong) UIImage *defaultUserAvatar;

@property (nonatomic,strong) UIImage *defaultTeamAvatar;


@end
