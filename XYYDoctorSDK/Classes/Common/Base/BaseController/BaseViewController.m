//
//  BaseViewController.m
//  xinyaomeng
//
//  Created by 黄黎雯 on 2017/6/8.
//  Copyright © 2017年 hlw. All rights reserved.
//

#import "BaseViewController.h"
#import "NSString+Category.h"
#import "ImageUtil.h"
#import "XYYSDK.h"
#import "XYYDoctorSDK.h"
@interface BaseViewController ()<UITextFieldDelegate, UIGestureRecognizerDelegate,UIAlertViewDelegate,UIApplicationDelegate> {
    NSInteger prewTag; //UITextField的tag
    float prewMoveY; //编辑到时候移动到高度
    UIImageView*navBarHairlineImageView;
}
@property(nonatomic,strong)UIImageView *imgwsView;
@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    [self registerHideKeyWindow];
//    navBarHairlineImageView= [self findHairlineImageViewUnder:self.navigationController.navigationBar];
//    navBarHairlineImageView.alpha=0;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    UIImage * image = [ImageUtil imageWithColor:NVIGATION_BACKGOUND_COLOR Size:CGSizeMake(SCREEN_WIDTH, TITLE_HEIGHT_WITH_BAR)];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];//设置半透明背景图
//
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //判断是否需要弹出红包提示
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)setShadoff:(CGSize)size withColor:(UIColor*)color {
    self.navigationController.navigationBar.layer.shadowColor = color.CGColor;
    
    //2.设置阴影偏移范围
    
    self.navigationController.navigationBar.layer.shadowOffset = size;
    
    //3.设置阴影颜色的透明度
    
    self.navigationController.navigationBar.layer.shadowOpacity = 0.2;
}
- (void)setupLeftNextWithImage:(UIImage *)image {
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 54, 44);
    [back setImage:image forState:UIControlStateNormal];
    [back setImageEdgeInsets:UIEdgeInsetsMake(0, -32, 0, 0)];
    [back addTarget:self action:@selector(onLeftNext) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    if (!image) {
        rightItem=nil;
    }
    self.navigationItem.leftBarButtonItem = rightItem;
    self.parentViewController.navigationItem.leftBarButtonItem=rightItem;
}
- (void)setupLeftNextWithString:(NSString *)text withColor:(UIColor *)color{
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:16] width:100];
    back.frame = CGRectMake(0, 0, size.width, 44);
    [back setTitle:text forState:UIControlStateNormal];
    [back setTitleColor:color forState:UIControlStateNormal];
    [back addTarget:self action:@selector(onLeftNext) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    if ([StringUtil QX_NSStringIsNULL:text]) {
        rightItem=nil;
        return;
    }
    self.navigationItem.leftBarButtonItem = rightItem;
    self.parentViewController.navigationItem.leftBarButtonItem=rightItem;
}
//- (UIImageView*)findHairlineImageViewUnder:(UIView*)view {
//    
//    if([view isKindOfClass:UIImageView.class] && view.bounds.size.height<=1.0) {
//        return(UIImageView*)view;
//    }
//    for(UIView*subview in view.subviews) {
//        UIImageView*imageView = [self findHairlineImageViewUnder:subview];
//        if(imageView) {
//            return imageView;
//        }
//    }
//    return nil;
//}

#pragma mark 初始化标题栏
- (void) setupBack{
    [self setupBack:@"default_back"];
}
// 返回
- (void) setupBack:(NSString *)name{
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 40, 40);
    // [back setTitle:@"返回" forState:UIControlStateNormal];
    // back.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [back setImage:[ImageUtil getImageByPatch:name] forState:UIControlStateNormal];
    // [back setImage:[UIImage imageNamed:@"back_highlight"] forState:UIControlStateHighlighted];
    [back setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    //  [back setTitleEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    [back addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = rightItem;
}

- (void) setupNextWithImage:(UIImage *)image {
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 54, 44);
    [back setImage:image forState:UIControlStateNormal];
    [back setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -32)];
    [back addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    if (!image) {
        rightItem=nil;
    }
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void) setupNextWithArray:(NSArray*) array{
    self.navigationItem.rightBarButtonItems = array;
    self.parentViewController.navigationItem.rightBarButtonItems=array;
}

- (void) setupNextWithString:(NSString *)text {
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.titleLabel.font = [UIFont systemFontOfSize:16.0f];
//    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:16] width:100];
    back.frame = CGRectMake(0, 0, 100, 44);
    [back setTitle:text forState:UIControlStateNormal];
    [back setTitleColor:NEXT_TITLE_COLOR forState:UIControlStateNormal];
    [back addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    if (!text) {
        rightItem=nil;
    }
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void) setupNextWithString:(NSString *)text withColor:(UIColor *)color {
    UIButton* back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.titleLabel.font = [UIFont systemFontOfSize:16.0f];
//    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:16] width:100];
    back.frame = CGRectMake(0, 0, 100, 44);
    [back setTitle:text forState:UIControlStateNormal];
    [back setTitleColor:color forState:UIControlStateNormal];
    [back addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)setupTitleWithString:(NSString *)text withColor:(UIColor *)color{
    UILabel *titleView = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.0-30, 0, 60, TITLE_HEIGHT_WITH_BAR)];
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.text = text;
    titleView.font = [UIFont boldSystemFontOfSize:19];
    titleView.textColor = color;
    NSLog(@"%@",self.navigationItem);
    self.navigationItem.titleView = titleView;
}

-(void)setupTitleWithString:(NSString *)text{
    UILabel *titleView = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.0-30, 0, 60, TITLE_HEIGHT_WITH_BAR)];
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.text = text;
    titleView.font = [UIFont boldSystemFontOfSize:19];
    titleView.textColor = DEFAULT_TITLE_COLOR;
    NSLog(@"%@",self.navigationItem);
    self.navigationItem.titleView = titleView;
}


#pragma mark 界面点击 关闭键盘用
- (void)registerHideKeyWindow {
    if([self needRegisterHideKeyboard]) {
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyWindow)];
        tap.delegate = self;
        [self.view addGestureRecognizer:tap];
    }
}

- (void)hideKeyWindow {
    [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] || [NSStringFromClass([touch.view class]) isEqualToString:@"UICollectionViewCellContentView"]) {
        return NO;
    }
    if ( [NSStringFromClass([touch.view.superview class]) isEqualToString:@"UICollectionViewCell"]) {
        return NO;
    }
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    return YES;
}

#pragma mark - 重载onback
- (void)onBack {
    UIViewController * controller=[self.navigationController.viewControllers objectAtIndex:0];
    if(controller == self) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 重载onnext
- (void)onNext {
    
}

#pragma mark - 重载popByDrag
- (void)popByDrag {
}

#pragma mark - 是否需要侧拉返回
- (BOOL)needDragBack {
    return YES;
}

#pragma mark - 是否需要注册隐藏键盘手势
- (BOOL)needRegisterHideKeyboard {
    return YES;
}
@end
