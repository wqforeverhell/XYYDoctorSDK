//
//  BigSelectPhotoController.h
//  jiaMai
//
//  Created by 黄黎雯 on 2017/3/22.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "BaseViewController.h"
@import Photos;
@protocol BigSelectPhotoControllerDelegate <NSObject>
-(void)onselect:(NSArray*)data;
-(void)onSelectDone:(NSArray*)data;
@end
@interface BigSelectPhotoController : BaseViewController

@property (weak, nonatomic) id <BigSelectPhotoControllerDelegate> delegate;

@property(nonatomic,strong)PHFetchResult * photoList;
@property(nonatomic,strong)NSMutableArray*selectArray;//以选中的图片数组
@property(nonatomic,assign)NSInteger index;//当前图片索引
@property(nonatomic,assign)int maxP;
-(void)setSelectArray:(NSMutableArray *)selectArray;
@end
