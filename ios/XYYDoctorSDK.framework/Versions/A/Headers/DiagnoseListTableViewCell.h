//
//  DiagnoseListTableViewCell.h
//  yaolianti
//
//  Created by qxg on 2018/9/14.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DiagnoseListTableViewCell;
@class DiagnoselistModel;
@protocol  DiagnoselistDelegate<NSObject>
- (void)cell:(DiagnoseListTableViewCell *)cell selected:(BOOL)isSelected indexPath:(NSIndexPath *)indexPath;
@end
@interface DiagnoseListTableViewCell : UITableViewCell
@property (nonatomic, strong) NSIndexPath *indexPath;//cell对应的indexPath
@property (nonatomic, weak) id <DiagnoselistDelegate> delegate;
@property (nonatomic, assign) BOOL select;//是否是选中对应的商品
-(void)reloadDataWithModel:(DiagnoselistModel*)model type:(NSInteger)type;
@end
