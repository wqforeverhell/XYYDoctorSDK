//
//  HDPickerView.m
//  PickerView
//
//  Created by 侯荡荡 on 17/6/26.
//  Copyright © 2017年 HoHoDoDo. All rights reserved.
//

#import "HDPickerView.h"
#import "HDInputTableViewCell.h"

#define KEYWINDOW  [UIApplication sharedApplication].keyWindow

@interface HDPickerView ()
<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, copy)   SelectPickerValue pickerBlock;//picker选中值的回调
@property (nonatomic, strong) UIView *maskView;//工具条和picker的底部视图
@property (nonatomic, strong) UIView *toolBarView;//工具条
@property (nonatomic, strong) UIPickerView *pickerView;//picker
@property (nonatomic, strong) NSMutableArray *pickerDataSource;//picker数据源
@property (nonatomic, strong) NSString *selectValue;//picker选中的值
@property (nonatomic, assign) NSInteger selectComponent;//picker选中的当前列
@property (nonatomic, assign) NSInteger selectRow;//picker选中的当前行
@end

CGFloat PickViewHeight = 216.f;
CGFloat ToolBarHeight  = 44.f;
CGFloat MaskViewHeight = 260.f;

@implementation HDPickerView

- (instancetype)initPickerViewWithDataSource:(NSMutableArray *)dataSource selectVaule:(SelectPickerValue)block {
    
    if (self = [super init]) {
        
        self.pickerDataSource = dataSource;
        self.pickerBlock = block;
        
        self.frame = KEYWINDOW.bounds;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        [self addTarget:self action:@selector(hide)];
        [KEYWINDOW addSubview:self];
        
        self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, MaskViewHeight)];
        self.maskView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.maskView];
        
        
        self.toolBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, ToolBarHeight)];
        self.toolBarView.backgroundColor = [UIColor colorWithRed:249.f/255.f green:249.f/255.f blue:249.f/255.f alpha:0.8];
        [self.maskView addSubview:self.toolBarView];
        
        //取消按钮
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithRed:17.f/255.f green:71.f/255.f blue:115.f/255.f alpha:1] forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        cancelButton.frame = CGRectMake(5, 0, 60, ToolBarHeight);
        [cancelButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self.toolBarView addSubview:cancelButton];
        
        //确认按钮
        UIButton *trueButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [trueButton setTitle:@"确定" forState:UIControlStateNormal];
        [trueButton setTitleColor:[UIColor colorWithRed:17.f/255.f green:71.f/255.f blue:115.f/255.f alpha:1] forState:UIControlStateNormal];
        trueButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        trueButton.frame = CGRectMake(self.toolBarView.width - 65, 0, 60, ToolBarHeight);
        [trueButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
        [self.toolBarView addSubview:trueButton];
        
        //时间选择器
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.toolBarView.bottom, self.width, PickViewHeight)];
        self.pickerView.backgroundColor = [UIColor whiteColor];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.pickerView.showsSelectionIndicator = YES;
        [self.maskView addSubview:self.pickerView];
        
        [self changeSpearatorLineColor];
        
    }
    return self;
    
}

- (void)done {
    
    [self hide];
    if (self.pickerBlock) {
        if (self.selectValue.length == 0)
            self.selectValue = (self.pickerDataSource.count > 0) ? self.pickerDataSource[0] : @"";
        self.pickerBlock(self.selectValue, self.selectComponent, self.selectRow);
    }
    
}

- (void)show {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.maskView.top =  self.height - MaskViewHeight;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }];
}

- (void)hide {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.maskView.top =  self.height;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - 改变分割线的颜色
- (void)changeSpearatorLineColor {
    
    for (UIView *speartorView in self.pickerView.subviews) {
        if (speartorView.frame.size.height < 1) {//取出分割线view
            speartorView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        }
    }
}

#pragma mark - UIPickerViewDataSource
/**
 *  @brief 设置列数（必须要实现的代理方法）
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

/**
 *  @brief 每列多少行（必须要实现的代理方法）
 *  @param component 第几列
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [self.pickerDataSource count];
}

#pragma mark - UIPickerViewDelegate
/**
 *  @brief 返回行高
 */
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 40;
}

/*!
 * @brief 获取到数据源中的数据，展示到pickerView上
 * @param row 第几行
 * @param component 第几列
 * @return 选中的当前列当前行的值
 */
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return self.pickerDataSource[row];
}

/**
 *  @brief 当每次停止滚动，走这个代理。
 *  @param component 第几列
 *  @param row 第几行
 */
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectComponent = component;
    self.selectRow       = row;
    self.selectValue     = self.pickerDataSource[row];
}

/**
 *  @brief 返回的是每个选项的view,如果需要改变选择文字的字体、字号、颜色等可以选用此代理
 *  @param component 第几列
 *  @param row 第几行
 */
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16.f];
    id value = self.pickerDataSource[row];
    if ([value isKindOfClass:[NSString class]]) {
        label.text = value;
    } else {
        label.text = [value stringValue];
    }
    return label;
}

@end
