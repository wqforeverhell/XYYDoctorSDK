//
//  ChoosePhotoViewController.m
//  jiaMai
//
//  Created by 黄黎雯 on 16/7/20.
//  Copyright © 2016年 cxz. All rights reserved.
//

#import "ChoosePhotoViewController.h"
#import "DDChoosePhotoBottom.h"
#import "PhotoCell.h"
#import "BigSelectPhotoController.h"
#import "ImageUtil.h"
#import "XYYSDK.h"
#define ADD_TAG 10000
#define IMAGE_WIDTH 35
@interface ChoosePhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,PhotoCellDelegate,BigSelectPhotoControllerDelegate>{
    NSInteger lastIndex;
}
@property(nonatomic,strong)NSMutableArray*dataArray;
@property(nonatomic,strong)NSMutableArray*dataImage;

@end

@implementation ChoosePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    setIndex = [[NSMutableOrderedSet alloc] init];
//    setRow = [[NSMutableOrderedSet alloc] init];
    _dataImage=[[NSMutableArray alloc] init];
    _dataArray=[NSMutableArray new];
    // Reload assets
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
    
    photoList = [PHAsset fetchAssetsInAssetCollection:_assetsGroup options:options];
    
    for (PHAsset *asset in photoList) {
        PotoModel*item=[[PotoModel alloc] init];
        item.asset=asset;
        item.isShow=YES;
        [_dataArray addObject:item];
    }
    
//    if(_limit != 1) {
        NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"DDChoosePhotoBottom" owner:nil options:nil];
        addView = [array objectAtIndex:0];
        addView.frame = CGRectMake(0, 0, self.navigationController.toolbar.frame.size.width, self.navigationController.toolbar.frame.size.height);
        [addView.bottomButton addTarget:self action:@selector(doneClicked) forControlEvents:UIControlEventTouchDown];
        UIImage* imageNor = [ImageUtil imageWithColor:[UIColor whiteColor] Size:addView.bottomButton.frame.size];
        UIImage* imageSel = [ImageUtil imageWithColor:[UIColor grayColor] Size:addView.bottomButton.frame.size];
        [addView.bottomButton setBackgroundImage:imageNor forState:UIControlStateNormal];
        [addView.bottomButton setBackgroundImage:imageSel forState:UIControlStateHighlighted];
        [addView.bottomButton setTintColor:TINTCOLOR];
        addView.bottomButton.layer.cornerRadius = 6;
        addView.bottomButton.layer.masksToBounds = YES;
        [addView setBackgroundColor:[UIColor clearColor]];
        [[self.navigationController toolbar] setBackgroundImage:[ImageUtil imageWithColor:TINTCOLOR Size:[self.navigationController toolbar].frame.size] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        
        [[self.navigationController toolbar] addSubview:addView];
//    }
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.collectionView.backgroundColor=BACKGOUND_COLOR;
    
    ensureChoose = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    if(_limit != 1) {
        [self.navigationController setToolbarHidden:NO animated:NO];
//    }
    //[self scrollToBottom];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    if(_limit != 1) {
        [self.navigationController setToolbarHidden:YES animated:NO];
//    }
    
}

#pragma mark - 是否需要注册隐藏键盘手势
- (BOOL)needRegisterHideKeyboard {
    return NO;
}

-(void)dealloc{
    if(_delegate!=nil){
        _delegate=nil;
    }
    self.assetsGroup=nil;
    photoList=nil;
//    setIndex=nil;
//    setRow=nil;
    self.dataImage=nil;
    if(addView != nil) {
        [addView removeFromSuperview];
    }
}

#pragma mark - 重载返回按钮
- (void)onBack {
    if(addView != nil) {
        [addView removeFromSuperview];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 重载popbydrag
- (void)popByDrag {
    if(addView != nil) {
        [addView removeFromSuperview];
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    PhotoCell *cell = (PhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    PotoModel *asset = [_dataArray objectAtIndex:row];
    cell.limit=_limit;
    cell.delegate=self;
    [cell setPotomode:asset];
    return cell;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat wh=(SCREEN_WIDTH-30)/4;
    return CGSizeMake(wh, wh);
}

// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
//    if (_limit == 1) {
//        PotoModel *item = [_dataArray objectAtIndex:indexPath.row];
//        //cell点击
//        item.isShow=NO;
//        lastIndex =indexPath.row;
//        @autoreleasepool {
//            PHImageRequestOptions *imageoptions=[self getPHImageRequestOptions];
//            WS(weakSelf);
//            [imageoptions setProgressHandler:^(double progress, NSError *__nullable error, BOOL *stop, NSDictionary *__nullable info){
//                if(error){
//                    item.isShow=YES;
//                }
//                item.progress=progress;
//                [weakSelf.dataArray replaceObjectAtIndex:indexPath.row withObject:item];
//                [weakSelf.collectionView reloadItemsAtIndexPaths:@[indexPath]];
//
//            }];
//            [[PHImageManager defaultManager] requestImageForAsset:item.asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:imageoptions resultHandler:^(UIImage * result, NSDictionary * info){
//                @autoreleasepool {
//                    item.isShow=YES;
//                    if (result) {
//                        [weakSelf onSelect:item index:indexPath];
//                    }
//
//                }
//            }];
//        }
//    }else{
        // 跳转到大图选择
        UIStoryboard* story = [UIStoryboard storyboardWithName:@"photo" bundle:nil];
        BigSelectPhotoController* ctrl = [story instantiateViewControllerWithIdentifier:@"BigSelectPhoto"];
        ctrl.index=indexPath.row;
        [ctrl setSelectArray:_dataImage];
        ctrl.photoList=photoList;
        ctrl.delegate=self;
        ctrl.maxP=_limit;
        ctrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctrl animated:YES];
//    }
    
}

#pragma mark cell点击委托
-(void)onSelectAsset:(PotoModel *)mode{
    __block PotoModel*item=mode;
    item.isShow=NO;
    NSInteger indexPath=[_dataArray indexOfObject:mode];
    @autoreleasepool {
        PHImageRequestOptions *imageoptions=[self getPHImageRequestOptions];
        WS(weakSelf);
        [imageoptions setProgressHandler:^(double progress, NSError *__nullable error, BOOL *stop, NSDictionary *__nullable info){
            if(error){
                item.isShow=YES;
            }
            item.progress=progress;
            [weakSelf.dataArray replaceObjectAtIndex:indexPath withObject:item];
            NSIndexPath *thindex=[NSIndexPath indexPathForRow:0 inSection:indexPath];
            [weakSelf.collectionView reloadItemsAtIndexPaths:@[thindex]];
            
        }];
        [[PHImageManager defaultManager] requestImageForAsset:item.asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:imageoptions resultHandler:^(UIImage * result, NSDictionary * info){
            @autoreleasepool {
                item.isShow=YES;
                if (result) {
                    NSIndexPath *thindex=[NSIndexPath indexPathForRow:indexPath inSection:0];
                    [weakSelf onSelect:item index:thindex];
                }
            }
        }];
    }
}

-(void)onSelect:(PotoModel *)model index:(NSIndexPath*)index{
    @autoreleasepool {
        PHAsset*asset=model.asset;
    lastIndex=index.row;
    if([_dataImage containsObject:asset]) {
        [_dataImage removeObject:asset];
        model.isSelect=NO;
    }
    else {
        if(_limit != 0 && [_dataImage count] >= _limit) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"最多选择%ld张照片", _limit] toView:nil];
        }
        else {
            [_dataImage addObject:asset];
            model.isSelect=YES;
        }
    }
    [self.navigationItem setTitle:[NSString stringWithFormat:@"选择照片(%ld)", [_dataImage count]]];

        [self.dataArray replaceObjectAtIndex:index.row withObject:model];
        [self.collectionView reloadItemsAtIndexPaths:@[index]];
//    if(_limit == 1 && [_dataImage count] == 1) {
//        [self doneClicked];
//    }
    }
}

- (void)doneClicked {
    if(ensureChoose) {
        return ;
    }
    if([_dataImage count] == 0) {
        [MBProgressHUD showError:@"请选择照片" toView:nil];
        return ;
    }
    [MBProgressHUD showMessag:@"正在处理图片，请稍等" toView:self.view];
    ensureChoose = YES;
     @autoreleasepool {
    for(int i = 0; i < [_dataImage count]; i ++) {
            @try {
                PHAsset * asset = [_dataImage objectAtIndex:i];
                PHImageRequestOptions *imageoptions=[self getPHImageRequestOptions];
                WS(weakSelf);
                [imageoptions setProgressHandler:^(double progress, NSError *__nullable error, BOOL *stop, NSDictionary *__nullable info){
                }];
                [[PHImageManager defaultManager] requestImageForAsset:asset  targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:imageoptions resultHandler:^(UIImage * result, NSDictionary * info){
                    @autoreleasepool {
                        if (result) {
                            
                            if(weakSelf.delegate != nil && [weakSelf.delegate respondsToSelector:@selector(choosePhotos:)]) {
                                [weakSelf.delegate choosePhotos:@[result]];
                            }
                            if (i==[weakSelf.dataImage count]-1) {
                                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
                                [weakSelf dismissViewControllerAnimated:YES completion:nil];
                            }
                        }
                        
                    }
                }];
                
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
        }
    }
}

-(PHImageRequestOptions*)getPHImageRequestOptions{
    PHImageRequestOptions *imageoptions = [[PHImageRequestOptions alloc] init];
    imageoptions.synchronous=YES;
    imageoptions.networkAccessAllowed=YES;
    [imageoptions setResizeMode:PHImageRequestOptionsResizeModeFast];
    [imageoptions setDeliveryMode:PHImageRequestOptionsDeliveryModeHighQualityFormat];
    return imageoptions;
}

#pragma mark 选择大图委托
-(void)onselect:(NSArray *)data{
    //返回大图选中的图片数组
    [_dataImage removeAllObjects];
    [_dataImage addObjectsFromArray:data];
    for (int i=0;i<_dataArray.count;i++) {
        PotoModel*mode=[_dataArray objectAtIndex:i];
        if ([_dataImage containsObject:mode.asset]) {
            mode.isSelect=YES;
        }else{
            mode.isSelect=NO;
        }
        [_dataArray replaceObjectAtIndex:i withObject:mode];
    }
    [self.collectionView reloadData];
}
-(void)onSelectDone:(NSArray *)data{
    //完成大图选中图片数组
    [_dataImage removeAllObjects];
    [_dataImage addObjectsFromArray:data];
    [self doneClicked];
}

#pragma mark - 滚动到底部
- (void)scrollToBottom {
    if(photoList != nil && [photoList count] > 0) {
        CGFloat y = self.collectionView.contentSize.height + 44;
        if(y > 0) {
            self.collectionView.contentOffset = CGPointMake(0, y);
        }
    }
}

@end
