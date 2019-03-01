//
//  PhotoCell.h
//  jiaMai
//
//  Created by 黄黎雯 on 16/7/20.
//  Copyright © 2016年 cxz. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Photos;
//扩散发布列表用model
@interface PotoModel : NSObject
@property(nonatomic,strong)PHAsset*asset;
@property(nonatomic,assign)CGFloat progress;
@property(nonatomic,assign)BOOL isShow;
@property(nonatomic,assign)BOOL isSelect;
@end
@protocol PhotoCellDelegate <NSObject>
-(void)onSelectAsset:(PotoModel*)mode;
@end
@interface PhotoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imagePic;
@property (weak, nonatomic) IBOutlet UILabel *labJd;
@property (weak, nonatomic) IBOutlet UIButton *btnSelect;

@property(nonatomic,weak)id<PhotoCellDelegate>delegate;

@property(nonatomic,strong)PotoModel *potomode;
@property (nonatomic, assign) NSInteger limit;
-(void)setPotomode:(PotoModel *)potomode;
@end
