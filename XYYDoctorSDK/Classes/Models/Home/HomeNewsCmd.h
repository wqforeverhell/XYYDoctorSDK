//
//  HomeNewsCmd.h
//  yaolianti
//
//  Created by qxg on 2018/12/15.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "BaseCommand.h"

@interface NewCollectionbriefListCmd : BaseCommand
@property (nonatomic,assign) NSInteger pageNum;
@property (nonatomic,assign) NSInteger pageSize;
@end
