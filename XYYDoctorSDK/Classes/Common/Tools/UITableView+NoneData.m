//
//  UITableView+NoneData.m
//  xinyaomeng
//
//  Created by 黄黎雯 on 2017/6/8.
//  Copyright © 2017年 hlw. All rights reserved.
//

#import "UITableView+NoneData.h"
#import "XYYSDK.h"
@implementation UITableView(NoneData)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)createNoDataView
{
    UIView*view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.backgroundColor=[UIColor clearColor];
    UILabel*labl=[[UILabel alloc] initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, 20)];
    labl.text=@"下拉屏幕，重新加载";
    labl.textColor=HexRGB(0xa8a8a8);
    labl.font=[UIFont systemFontOfSize:14];
    labl.textAlignment=NSTextAlignmentCenter;
    [view addSubview:labl];
    [self setTableHeaderView:view];
  
}

- (void)hideView
{
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[UIView class]]&& v.tag == 100) {
            [v removeFromSuperview];
        }
    }
}

- (void)createNoDataText:(NSString*)tishi
{
    UIView*view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.backgroundColor=[UIColor clearColor];
    UILabel*labl=[[UILabel alloc] initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, 20)];
    labl.text=tishi;
    labl.textColor=HexRGB(0xa8a8a8);
    labl.font=[UIFont systemFontOfSize:14];
    labl.textAlignment=NSTextAlignmentCenter;
    [view addSubview:labl];
    [self setTableHeaderView:view];
}

- (void)createNoDataWithFrame:(CGRect)frame
{
    CGFloat picH = 150;
    CGFloat picW = 100;
    UIView *bgView = [[UIView alloc]initWithFrame:frame];
    bgView.backgroundColor = [UIColor clearColor];
    CGFloat x = (bgView.frame.size.width - picW)/2;
    UILabel *nodataLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, 150 , 100, 30)];
    nodataLabel.textAlignment = NSTextAlignmentCenter;
    nodataLabel.text = @"暂无数据";
    [bgView addSubview:nodataLabel];
    [self setTableHeaderView:bgView];
}
#pragma mark 包含图片文字按钮提示空数据
-(UIButton*)createNoDataWithImgStrBtn:(NSString*)imgstr content:(NSString*)content btnTitle:(NSString*)btnS btnC:(UIColor*)btnc frame:(CGRect)frame{
    UIView*view=[[UIView alloc] initWithFrame:frame];
    view.backgroundColor=[UIColor clearColor];
    UIImage*image=[UIImage imageNamed:imgstr];
    CGFloat imgy;
    if (@available(iOS 11.0, *)) {
        imgy=SCREEN_WIDTH>320?150:100;
        imgy-=TITLE_HEIGHT_WITH_BAR;
    }else{
        imgy=SCREEN_WIDTH>320?150:50;
    }
    UIImageView*imageView=[[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-image.size.width)/2, imgy, image.size.width, image.size.height)];
    [imageView setImage:image];
    [view addSubview:imageView];
    //提示文字
    UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+20, SCREEN_WIDTH, 40)];
    label.textAlignment=NSTextAlignmentCenter;
    [label setFont:[UIFont systemFontOfSize:15]];
    [label setTextColor:HexRGB(0xB4B4B4)];
    [label setText:content];
    [view addSubview:label];
    //跳转按钮
    UIButton*btnGo;
    if (!IS_EMPTY(btnS)) {
        btnGo=[[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, CGRectGetMaxY(label.frame)+15, 100, 44)];
        [btnGo setTitle:btnS forState:UIControlStateNormal];
        [btnGo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnGo.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [btnGo setBackgroundColor:btnc];
        btnGo.layer.cornerRadius=5;
        btnGo.layer.masksToBounds=YES;
        [view addSubview:btnGo];
    }
    [self setTableHeaderView:view];
    return btnGo;
}
-(UIButton*)createNoDataWithImgStrBtn:(NSString*)imgstr content:(NSString*)content btnTitle:(NSString*)btnS btnC:(UIColor*)btnc{
    return [self createNoDataWithImgStrBtn:imgstr content:content btnTitle:btnS btnC:btnc frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-TITLE_HEIGHT_WITH_BAR)];
}

@end
