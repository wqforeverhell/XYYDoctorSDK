//
//  SelectTimeGyq.m
//  jiaMai
//
//  Created by 黄黎雯 on 2016/12/3.
//  Copyright © 2016年 cxz. All rights reserved.
//

#import "HLWSelectTimeGyq.h"
#import "TimeUtil.h"
#import "XYYDoctorSDK.h"
#define VIEW_ALL_HEIGTH 280 //整个view 的高度
@implementation YPpickViewModel

@end
@interface HLWSelectTimeGyq ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray *_YoneArray;
    NSMutableArray *_YtwoGArray;
    NSMutableArray *_MArray;
    NSMutableArray *_DayArray;
    UIView *_view;
    onDoneDateBlock _block;
}
@property (strong, nonatomic) UIPickerView *pickerView;
@property (nonatomic, strong)YPpickViewModel *model;
@end
@implementation HLWSelectTimeGyq

-(instancetype)init{
    if (self = [super initWithFrame:CGRectMake(0, SCREEN_HEIGHT-VIEW_ALL_HEIGTH, SCREEN_WIDTH, VIEW_ALL_HEIGTH)]){
        [self initData];
        [self initView];
        [self.pickerView reloadAllComponents];
    }
    return self;
}

#pragma mark - dataSource
-(void)initData{
    _YoneArray = [NSMutableArray array];
    _YtwoGArray=[NSMutableArray array];
    _MArray=[NSMutableArray array];
    _DayArray=[NSMutableArray array];
    for (int i=0; i<100; i++) {
        NSString *content=[NSString stringWithFormat:@"%d",i];
        if (i>0&&i<32) {
            if(i<22){
                //年第一位
                [_YoneArray addObject:content];
            }
            if(i<10){
                content=[NSString stringWithFormat:@"0%d",i];
            }
            if(i<13){
                //月
                [_MArray addObject:content];
            }
            //日
            [_DayArray addObject:content];
        }
        //年第二位
        if (i==0) {
            content=[NSString stringWithFormat:@"0%d",i];
        }
        [_YtwoGArray addObject:content];
        
    }
    
}

-(void)setIndex:(NSString*)index{
    //  设置默认选中时间
    NSDateComponents *comDate=[[TimeUtil getInstance] currentDateCompoent];
    if (!IS_EMPTY(index)) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *today = [formatter dateFromString:index];
        comDate=[[TimeUtil getInstance] dateCompoentFromDate:today];
    }
    
    NSString*yeerOne=[[NSString stringWithFormat:@"%ld",(long)comDate.year] substringToIndex:2];
    NSString*yeerTwo=[[NSString stringWithFormat:@"%ld",(long)comDate.year] substringFromIndex:2];
    self.model = [[YPpickViewModel alloc]init];
    self.model.timeYone = _YoneArray[[yeerOne intValue]-1];
    self.model.timeYtwo = _YtwoGArray[[yeerTwo intValue]];
    self.model.timeM = _MArray[comDate.month-1];
    self.model.timeD = _DayArray[comDate.day-1];
    
    [self.pickerView selectRow:[yeerOne intValue]-1 inComponent:0 animated:YES];
    [self.pickerView selectRow:[_YtwoGArray[[yeerTwo intValue]] intValue] inComponent:1 animated:YES];
    [self.pickerView selectRow:comDate.month-1 inComponent:3 animated:YES];
    [self.pickerView selectRow:comDate.day-1 inComponent:5 animated:YES];
}

-(void)initView{
    [self setBackgroundColor:LINE_COLOR];
    UIView *viewTools=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    [viewTools setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:viewTools];
    CALayer *layer=[CALayer layer];
    layer.borderColor=LINE_COLOR.CGColor;
    layer.frame=CGRectMake(0, 0, SCREEN_WIDTH, 1);
    [viewTools.layer addSublayer:layer];
    UIButton *btnCancel=[[UIButton alloc] initWithFrame:CGRectMake(16, 0, 40, 44)];
    [btnCancel setTitle:@"取消" forState:0];
    [btnCancel setTitleColor:HexRGB(0x6495ED) forState:0];
    [btnCancel.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btnCancel addTarget:self action:@selector(onCancel) forControlEvents:UIControlEventTouchUpInside];
    [viewTools addSubview:btnCancel];
    UIButton *btnDone=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-56, 0, 40, 44)];
    [btnDone setTitle:@"完成" forState:0];
    [btnDone setTitleColor:HexRGB(0x6495ED) forState:0];
    [btnDone.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btnDone addTarget:self action:@selector(onDone) forControlEvents:UIControlEventTouchUpInside];
    [viewTools addSubview:btnDone];
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, VIEW_ALL_HEIGTH-44)];
    self.pickerView.backgroundColor = [UIColor clearColor];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    [self addSubview:self.pickerView];
    
    [self setIndex:nil];
}

#pragma mark pickerviewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 7;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==2||component==4||component==6){
        return 1;
    }
    if (component==0) {
        return _YoneArray.count;
    }
    if (component==3) {
        return _MArray.count;
    }
    if (component==5) {
        return _DayArray.count;
    }
    return _YtwoGArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 47.0f;
}

- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return  (self.frame.size.width-30)/7;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (!view){
        view = [[UIView alloc]init];
    }
    UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, (self.frame.size.width-10)/7, 47)];
    text.textAlignment=NSTextAlignmentCenter;
    text.font = [UIFont systemFontOfSize:16];
    text.textColor=HexRGB(0x3c4d6b);
    if (component==2) {
        text.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:16];
        text.text = @"年";
    }else if (component==0){
        text.text=[_YoneArray objectAtIndex:row];
    }else if (component==3){
        text.text=[_MArray objectAtIndex:row];
    }else if (component==4){
        text.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:16];
        text.text=@"月";
    }else if (component==5){
        text.text=[_DayArray objectAtIndex:row];
    }else if (component==6){
        text.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:16];
        text.text=@"日";
    }else{
        text.text = [_YtwoGArray objectAtIndex:row];
    }
    [view addSubview:text];
    return view;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str = @"";
    if (component==2) {
        str = @"年";
    }else if(component==0){
        str=[_YoneArray objectAtIndex:row];
    }else if(component==3){
        str=[_MArray objectAtIndex:row];
    }else if(component==4){
        str=@"月";
    }else if(component==5){
        str=[_DayArray objectAtIndex:row];
    }else if(component==6){
        str=@"日";
    }else{
        str = [_YtwoGArray objectAtIndex:row];
    }
    return str;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str = @"";
    if (component==2) {
        str = @"年";
    }else if(component==0){
        str=[_YoneArray objectAtIndex:row];
    }else if(component==3){
        str=[_MArray objectAtIndex:row];
    }else if(component==4){
        str=@"月";
    }else if(component==5){
        str=[_DayArray objectAtIndex:row];
    }else if(component==6){
        str=@"日";
    }else{
        str = [_YtwoGArray objectAtIndex:row];
    }
    NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc]initWithString:str];
    [AttributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16], NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, [AttributedString  length])];
    
    return AttributedString;
}

//被选择的行
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component==0) {
        self.model.timeYone = [_YoneArray objectAtIndex:row];
    }
    
    if (component==1) {
        self.model.timeYtwo = [_YtwoGArray objectAtIndex:row];
    }
    if (component==3) {
        self.model.timeM = [_MArray objectAtIndex:row];
    }
    if (component==5) {
        self.model.timeD = [_DayArray objectAtIndex:row];
    }
}
-(void)setOnDoneBlock:(onDoneDateBlock)block{
    if (block) {
        _block=nil;
        _block=[block copy];
    }
}
-(void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
-(void)dissmis{
    [self onCancel];
}
#pragma mark 点击事件
-(void)onCancel{
    [self removeFromSuperview];
}
-(void)onDone{
    NSString*date=[NSString stringWithFormat:@"%@%@-%@-%@",self.model.timeYone,self.model.timeYtwo,self.model.timeM,self.model.timeD];
    if (_block) {
        _block(date);
    }
    [self removeFromSuperview];
}
@end
