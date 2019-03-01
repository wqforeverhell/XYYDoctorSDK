//
//  PhotoCell.m
//  jiaMai
//
//  Created by 黄黎雯 on 16/7/20.
//  Copyright © 2016年 cxz. All rights reserved.
//

#import "PhotoCell.h"
#import "ImageUtil.h"
@implementation PotoModel

@end
@implementation PhotoCell
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
//    UITapGestureRecognizer* gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClicked:)];
//    [_imagePic setUserInteractionEnabled:YES];
//    [_imagePic addGestureRecognizer:gr];
    
}

-(void)dealloc{
    _potomode=nil;
    [_imagePic setImage:nil];
    
}

-(void)setPotomode:(PotoModel *)potomode{
    _potomode=potomode;
    _labJd.hidden=_potomode.isShow;
    if (!potomode.isShow) {
        _labJd.text=[NSString stringWithFormat:@"%0.0f%%",_potomode.progress*100];
    }
    [_btnSelect setImage:nil forState:UIControlStateNormal];
    [_imagePic setImage:nil];
    
    PHImageRequestOptions *imageoptions = [[PHImageRequestOptions alloc] init];
    [imageoptions setResizeMode:PHImageRequestOptionsResizeModeExact];
    [imageoptions setDeliveryMode:PHImageRequestOptionsDeliveryModeHighQualityFormat];
    [[PHImageManager defaultManager] requestImageForAsset:_potomode.asset targetSize:(CGSize){250,250} contentMode:PHImageContentModeAspectFit options:imageoptions resultHandler:^(UIImage * result, NSDictionary * info){
        if (result) {
            
            [_imagePic setImage:result];
            
        }
    }];
    
    if(_potomode.isSelect) {
        [_btnSelect setImage:[ImageUtil getImageByPatch:@"photo_state_selected"] forState:UIControlStateNormal];
    }
    else {
        [_btnSelect setImage:[ImageUtil getImageByPatch:@"photo_state_normal"] forState:UIControlStateNormal];
    }
//    if(_limit == 1) {
//        [_btnSelect setHidden:YES];
//    }
//    else {
        [_btnSelect setHidden:NO];
//    }
}

//- (void)itemClicked:(UITapGestureRecognizer*)gr {
//    
//}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat wh=([UIScreen mainScreen].bounds.size.width-9)/4;
    CGRect frame=[self frame];
    frame.size.width=wh;
    frame.size.height=wh;
    self.frame=frame;
    frame=[_imagePic frame];
    frame.size.width=wh;
    frame.size.height=wh;
    _imagePic.frame=frame;
    frame=[_labJd frame];
    frame.size.width=wh;
    frame.size.height=wh;
    _labJd.frame=frame;
    frame=[_btnSelect frame];
    frame.origin.x=wh-frame.size.width;
    frame.origin.y=wh-frame.size.height;
    _btnSelect.frame=frame;
}

#pragma mark 选择或取消选择图片
- (IBAction)onSelect:(id)sender {
    if (_delegate&&[_delegate respondsToSelector:@selector(onSelectAsset:)]) {
        [_delegate onSelectAsset:_potomode];
    }
}

@end
