//
//  BigSelectPhotoController.m
//  jiaMai
//
//  Created by 黄黎雯 on 2017/3/22.
//  Copyright © 2017年 cxz. All rights reserved.
//

#import "BigSelectPhotoController.h"
#import "XYYSDK.h"
#import "ImageUtil.h"
@interface BigSelectPhotoController ()<UIScrollViewDelegate, UIAlertViewDelegate,UIGestureRecognizerDelegate>{
    CGFloat lastScale ;
    NSInteger lastIndex;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation BigSelectPhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupBack];
    
    lastIndex=_index;
    
    lastScale=1.0;
    // scrollView初始化
    [self initScrollView];
    
    PHAsset*asset=[_photoList objectAtIndex:_index];
    //判断图片是否选中
    UIImage*img=[ImageUtil getImageByPatch:@"photo_state_normal"];
    if ([_selectArray containsObject:asset]) {
        img=[ImageUtil getImageByPatch:@"photo_state_selected"];
    }
    [self setupNextWithImage:img];
    
    NSString *str =  [NSString stringWithFormat:@"已选择(%ld)",(long)_selectArray.count];
    [self setupTitleWithString:str withColor:NVIGATION_BACKGOUND_COLOR];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setSelectArray:(NSMutableArray *)selectArray{
    _selectArray=[[NSMutableArray alloc] init];
    [_selectArray addObjectsFromArray:selectArray];
}

-(void)onBack{
    if(_delegate&&[_delegate respondsToSelector:@selector(onselect:)]){
        [_delegate onselect:_selectArray];
    }
    [super onBack];
}

#pragma mark 右上角按钮点击选中或取消
-(void)onNext{
    //判断图片是否选中
    PHAsset*asset=[_photoList objectAtIndex:_index];
    UIImage*img=[ImageUtil getImageByPatch:@"photo_state_normal"];
    if (![_selectArray containsObject:asset]) {
        if (_selectArray.count>=_maxP) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"最多选择%d张图片",_maxP] toView:self.view];
            return;
        }
        img=[ImageUtil getImageByPatch:@"photo_state_selected"];
        [_selectArray addObject:asset];
    }else{
        [_selectArray removeObject:asset];
    }
    [self setupNextWithImage:img];
    NSString *str =  [NSString stringWithFormat:@"已选择(%ld)",(long)_selectArray.count];
    [self setupTitleWithString:str withColor:DEFAULT_TITLE_COLOR];
}

#pragma mark 初始化页面
- (void)initScrollView
{
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollsToTop = NO;
    _scrollView.alwaysBounceVertical = NO;
    _scrollView.alwaysBounceHorizontal = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.delaysContentTouches=NO;
    
    [self showPhotos];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat scrollW = SCREEN_WIDTH;
    int page = (scrollView.contentOffset.x + scrollW * 0.5) / scrollW;
    self.index= page;
    
    //设置当前图片为大图
    PHAsset*asset=[_photoList objectAtIndex:_index];
    __block UIImageView*imageV=[_scrollView viewWithTag:page+10];
    PHImageRequestOptions *imageoptions = [[PHImageRequestOptions alloc] init];
    [imageoptions setResizeMode:PHImageRequestOptionsResizeModeFast];
    [imageoptions setDeliveryMode:PHImageRequestOptionsDeliveryModeHighQualityFormat];
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:imageoptions resultHandler:^(UIImage * result, NSDictionary * info){
        if (result) {
            if ([imageV isKindOfClass:[UIImageView class]]) {
                [imageV setImage:result];
            }
        }
    }];
    
    //上一张图片设置为小图
    __block UIImageView*imageSV=[_scrollView viewWithTag:lastIndex+10];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    [options setResizeMode:PHImageRequestOptionsResizeModeFast];
    [options setDeliveryMode:PHImageRequestOptionsDeliveryModeFastFormat];
    [[PHImageManager defaultManager] requestImageForAsset:[_photoList objectAtIndex:lastIndex] targetSize:(CGSize){250,250} contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * result, NSDictionary * info){
        if (result) {
            if ([imageSV isKindOfClass:[UIImageView class]]) {
                [imageSV setImage:result];
            }
            
        }
    }];
    lastIndex=page;
    //判断图片是否选中
    UIImage*img=[ImageUtil getImageByPatch:@"photo_state_normal"];
    if ([_selectArray containsObject:asset]) {
        img=[ImageUtil getImageByPatch:@"photo_state_selected"];
    }
    [self setupNextWithImage:img];
    
}

//显示scrollView照片
-(void)showPhotos
{
    CGFloat imageW = SCREEN_WIDTH;
    CGFloat imageH = SCREEN_HEIGHT*7/8;
    CGFloat imageY = 0;
    
    for(UIImageView *imageV in _scrollView.subviews){
        [imageV removeFromSuperview];
    }
    
    _scrollView.contentSize = CGSizeMake(_photoList.count * imageW, 0);
    for (int i = 0; i < _photoList.count; i++) {
        
        __block UIImageView *imageView = [[UIImageView alloc] init];
        
        imageView.autoresizingMask = UIViewAutoresizingNone;
        imageView.tag=i+10;
        CGFloat imageX = i * imageW;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        
        if(_index==i){
            //设置当前图片为大图
            PHImageRequestOptions *imageoptions = [[PHImageRequestOptions alloc] init];
            [imageoptions setResizeMode:PHImageRequestOptionsResizeModeFast];
            [imageoptions setDeliveryMode:PHImageRequestOptionsDeliveryModeHighQualityFormat];
            [[PHImageManager defaultManager] requestImageForAsset:[_photoList objectAtIndex:i] targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:imageoptions resultHandler:^(UIImage * result, NSDictionary * info){
                if (result) {
                    if ([imageView isKindOfClass:[UIImageView class]]) {
                        [imageView setImage:result];
                    }
                }
            }];
        }else{
            PHImageRequestOptions *imageoptions = [[PHImageRequestOptions alloc] init];
            [imageoptions setResizeMode:PHImageRequestOptionsResizeModeFast];
            [imageoptions setDeliveryMode:PHImageRequestOptionsDeliveryModeFastFormat];
            [[PHImageManager defaultManager] requestImageForAsset:[_photoList objectAtIndex:i] targetSize:(CGSize){250,250} contentMode:PHImageContentModeAspectFit options:imageoptions resultHandler:^(UIImage * result, NSDictionary * info){
                if (result) {
                    [imageView setImage:result];
                }
            }];
        }
        
        imageView.userInteractionEnabled=YES;
        UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
        
        [pinchRecognizer setDelegate:self];
        [imageView addGestureRecognizer:pinchRecognizer];
        
        [_scrollView addSubview:imageView];
        //        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 20, SCREEN_WIDTH , 1)];
        //        [line setBackgroundColor:[UIColor whiteColor]];
        //        [self.view addSubview:line];
    }
    
    
    [_scrollView setContentOffset:CGPointMake(_index * SCREEN_WIDTH, 0) animated:YES];
    
}

// 缩放
-(void)scale:(UIPinchGestureRecognizer*)sender {
    
    //当手指离开屏幕时,将lastscale设置为1.0
    if([sender state] == UIGestureRecognizerStateEnded) {
        lastScale = 1.0;
        return;
    }
    
    CGFloat scale = 1.0 - (lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    CGAffineTransform currentTransform =sender.view.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [sender.view setTransform:newTransform];
    lastScale = [sender scale];
}

- (IBAction)onDone:(id)sender {
    //完成
    if (_maxP==1) {
        [_selectArray removeAllObjects];
        [_selectArray addObject:[_photoList objectAtIndex:_index]];
    }else if (_selectArray.count==0){
        [MBProgressHUD showError:@"请选择图片" toView:self.view];
        return;
    }
    if(_delegate&&[_delegate respondsToSelector:@selector(onSelectDone:)]){
        [_delegate onSelectDone:_selectArray];
    }
    [self.navigationController popViewControllerAnimated:NO];
}
@end
