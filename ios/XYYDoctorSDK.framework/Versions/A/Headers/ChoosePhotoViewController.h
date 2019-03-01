//
//  ChoosePhotoViewController.h
//  jiaMai
//
//  Created by 黄黎雯 on 16/7/20.
//  Copyright © 2016年 cxz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDPhotoListViewController.h"
#import "DDChoosePhotoBottom.h"
#import "BaseViewController.h"
@import Photos;
@protocol DDChoosePhotoDelegate;
@interface ChoosePhotoViewController : BaseViewController{
    PHFetchResult * photoList;
//    NSMutableOrderedSet* setIndex;
//    NSMutableOrderedSet* setRow;
    DDChoosePhotoBottom* addView;
    BOOL ensureChoose;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//跳转参数
@property (nonatomic, weak) PHAssetCollection *assetsGroup;
@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, assign) BOOL orignal;
@property (nonatomic, weak) id<DDChoosePhotoDelegate> delegate;
@end
