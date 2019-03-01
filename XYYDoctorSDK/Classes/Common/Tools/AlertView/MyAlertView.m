//
//  MyAlertView.m
//  xinyaomeng
//
//  Created by 黄黎雯 on 2017/6/8.
//  Copyright © 2017年 hlw. All rights reserved.
//

#import "MyAlertView.h"
#import "XYYSDK.h"
#import "ImageUtil.h"
@interface MyAlertView() {
    BOOL _leftLeave;
}

@property (nonatomic, strong) UILabel *alertTitleLabel;
@property (nonatomic, strong) UILabel *alertContentLabel;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *middleBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *backImageView;
@end

@implementation MyAlertView

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        _width = 272.0f;
        _height = 160.0f;
        _yOffset = 0.0f;
    }
    return self;
}

-(id)initWtihWh:(CGFloat)width height:(CGFloat)height{
    if (self=[super init]) {
        _width=width;
        _height=height;
    }
    return self;
}

#define kTitleYOffset 15.0f
#define kTitleHeight 25.0f

#define kContentOffset 30.0f
#define kBetweenLabelOffset 20.0f

- (id)initWithTitle:(NSString *)title contentText:(NSString *)content leftButton:(NSString *)leftTitle rightButton:(NSString *)rigthTitle {
    if (self = [self init]) {
        
        [self addBackgroundImage];
        
        [self initTitle:title];
        
        UIFont* font = [UIFont systemFontOfSize:15.0f];
        CGSize sz = [content sizeWithFont:font constrainedToSize:CGSizeMake(_width-50, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, _height+20, sz.width, sz.height)];
        contentLabel.text = content;
        contentLabel.font = font;
        contentLabel.numberOfLines = NSIntegerMax;
        [self addSubview:contentLabel];
        
        _height += 50 + sz.height;
        
        [self addButtons:leftTitle RightButton:rigthTitle];
        
        [self adjustBackground];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}


- (void) initTitle : (NSString*) title{
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, _width, 25)];
    self.title.font = [UIFont boldSystemFontOfSize:20.0f];
    self.title.text = title;
    self.title.textColor = [UIColor lightGrayColor];
    [self.title setTextAlignment:NSTextAlignmentCenter];
    [self.title setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.title];
    self.height = CGRectGetMaxY(self.title.frame);
}

- (void) addButtons:(NSString*) left RightButton:(NSString*) right {
    CGRect leftBtnFrame = CGRectMake(0, _height, _width/2.0f, 40);;
    CGRect rightBtnFrame = CGRectMake(_width/2.0f, _height, _width/2.0f, 40);
    
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBtn.frame = leftBtnFrame;
    self.rightBtn.frame = rightBtnFrame;
    
    UIImage *leftNor = [[ImageUtil getImageByPatch:@"alert_ok_nor"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 20, 20)];
    UIImage *leftPress = [[ImageUtil getImageByPatch:@"alert_ok_pre"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 20, 20)];
    UIImage *rightNor = [[ImageUtil getImageByPatch:@"alert_cancel_nor"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 20, 20)];
    UIImage *rightPress = [[ImageUtil getImageByPatch:@"alert_cancel_pre"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 20, 20)];
    
    [self.rightBtn setBackgroundImage:rightNor forState:UIControlStateNormal];
    [self.rightBtn setBackgroundImage:rightPress forState:UIControlStateHighlighted];
    [self.rightBtn setBackgroundImage:rightPress forState:UIControlStateSelected];
    [self.leftBtn setBackgroundImage:leftNor forState:UIControlStateNormal];
    [self.leftBtn setBackgroundImage:leftPress forState:UIControlStateHighlighted];
    [self.leftBtn setBackgroundImage:leftPress forState:UIControlStateSelected];
    
    [self.rightBtn setTitle:right forState:UIControlStateNormal];
    [self.leftBtn setTitle:left forState:UIControlStateNormal];
    self.leftBtn.titleLabel.font = self.rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.rightBtn setTitleColor:TINTCOLOR forState:UIControlStateNormal];
    [self.leftBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [self.leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.leftBtn];
    [self addSubview:self.rightBtn];
    
    _height = CGRectGetMaxY(leftBtnFrame);
}


- (void) addButtons:(NSString*) left MiddleButton:(NSString*) middle RightButton:(NSString*) right {
    CGRect leftBtnFrame = CGRectMake(0, _height, _width/3.0f, 40);
    CGRect middleBtnFrame = CGRectMake(_width/3.0f, _height, _width/3.0f, 40);
    CGRect rightBtnFrame = CGRectMake(_width*2/3.0f, _height, _width/3.0f, 40);
    
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.middleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBtn.frame = leftBtnFrame;
    self.middleBtn.frame = middleBtnFrame;
    self.rightBtn.frame = rightBtnFrame;
    
    UIImage *leftNor = [[ImageUtil getImageByPatch:@"alert_ok_nor"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 20, 20)];
    UIImage *leftPress = [[ImageUtil getImageByPatch:@"alert_ok_pre"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 20, 20)];
    UIImage *middleNor = [[ImageUtil getImageByPatch:@"alert_middle_nor"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 20, 20)];
    UIImage *middlePress = [[ImageUtil getImageByPatch:@"alert_middle_pre"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 20, 20)];
    UIImage *rightNor = [[ImageUtil getImageByPatch:@"alert_cancel_nor"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 20, 20)];
    UIImage *rightPress = [[ImageUtil getImageByPatch:@"alert_cancel_pre"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 20, 20)];
    
    [self.rightBtn setBackgroundImage:rightNor forState:UIControlStateNormal];
    [self.rightBtn setBackgroundImage:rightPress forState:UIControlStateHighlighted];
    [self.rightBtn setBackgroundImage:rightPress forState:UIControlStateSelected];
    [self.middleBtn setBackgroundImage:middleNor forState:UIControlStateNormal];
    [self.middleBtn setBackgroundImage:middlePress forState:UIControlStateHighlighted];
    [self.middleBtn setBackgroundImage:middlePress forState:UIControlStateSelected];
    [self.leftBtn setBackgroundImage:leftNor forState:UIControlStateNormal];
    [self.leftBtn setBackgroundImage:leftPress forState:UIControlStateHighlighted];
    [self.leftBtn setBackgroundImage:leftPress forState:UIControlStateSelected];
    
    [self.rightBtn setTitle:right forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.leftBtn setTitle:left forState:UIControlStateNormal];
    self.leftBtn.titleLabel.font = self.rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.leftBtn setTitleColor:TINTCOLOR forState:UIControlStateNormal];
    [self.middleBtn setTitle:middle forState:UIControlStateNormal];
    self.middleBtn.titleLabel.font = self.middleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.middleBtn setTitleColor:TINTCOLOR forState:UIControlStateNormal];
    
    [self.leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.middleBtn addTarget:self action:@selector(middleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.leftBtn];
    [self addSubview:self.middleBtn];
    [self addSubview:self.rightBtn];
    
    _height = CGRectGetMaxY(leftBtnFrame);
}

- (void) addBackgroundImage {
    UIImage* bgImg = [[ImageUtil getImageByPatch:@"alert_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10 , 20, 20)];
    _background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _width, _height)];
    _background.image = bgImg;
    
    [self addSubview:_background];
}

- (void) adjustBackground {
    CGRect frame = _background.frame;
    frame.size.height = _height;
    _background.frame = frame;
}

- (BOOL)needHideBg{
    return YES;
}

- (void)leftBtnClicked:(id)sender
{
    _leftLeave = YES;
    [self dismissAlert];
    if (self.leftBlock) {
        self.leftBlock();
    }
}

- (void)middleBtnClicked:(id)sender
{
    _leftLeave = NO;
    [self dismissAlert];
    if (self.middleBlock) {
        self.middleBlock();
    }
}

- (void)rightBtnClicked:(id)sender
{
    _leftLeave = NO;
    [self dismissAlert];
    if (self.rightBlock) {
        self.rightBlock();
    }
}

- (void)show
{
    UIViewController *topVC = [self appRootViewController];
    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - self.width) * 0.5, - self.height - 30, self.width, self.height);
    [topVC.view addSubview:self];
}

- (void)show:(CGRect)frame{
    UIViewController *topVC = [self appRootViewController];
    self.width=frame.size.width;
    self.height=frame.size.height;
    self.yOffset=frame.origin.y;
    self.frame = frame;
    [topVC.view addSubview:self];
}

- (void)dismissAlert
{
    [[[UIApplication sharedApplication] keyWindow]endEditing:YES];

    [self removeFromSuperview];
    if (self.dismissBlock) {
        self.dismissBlock();
    
    }
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

- (void)removeFromSuperview
{
    [self.backImageView removeFromSuperview];
    self.backImageView = nil;
    UIViewController *topVC = [self appRootViewController];
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - _width) * 0.5, CGRectGetHeight(topVC.view.bounds), _width, _height);
    
    //    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    self.frame = afterFrame;
    //        if (_leftLeave) {
    //            self.transform = CGAffineTransformMakeRotation(-M_1_PI / 1.5);
    //        }else {
    //            self.transform = CGAffineTransformMakeRotation(M_1_PI / 1.5);
    //        }
    //    } completion:^(BOOL finished) {
    //        [super removeFromSuperview];
    //    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];
    
    if (!self.backImageView) {
        self.backImageView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        self.backImageView.backgroundColor = [UIColor blackColor];
        self.backImageView.alpha = 0.6f;
        self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onBackImage)];
    [self.backImageView addGestureRecognizer:tap];
    
    [topVC.view addSubview:self.backImageView];
    //    self.transform = CGAffineTransformMakeRotation(-M_1_PI / 2);
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - _width) * 0.5, (CGRectGetHeight(topVC.view.bounds) - _height) * 0.5 + _yOffset, _width, _height);
    //    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
    //        self.transform = CGAffineTransformMakeRotation(0);
    self.frame = afterFrame;
    //    } completion:^(BOOL finished) {
    //
    //    }];
    [super willMoveToSuperview:newSuperview];
}

-(void)onBackImage{
    if ([self needHideBg]) {
        [self dismissAlert];
    }else{
        [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
    }
}

@end
