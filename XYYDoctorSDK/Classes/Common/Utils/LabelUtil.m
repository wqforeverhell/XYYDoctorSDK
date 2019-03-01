//
//  LabelUtil.m
//  xinyaomeng
//
//  Created by 黄黎雯 on 2017/6/8.
//  Copyright © 2017年 hlw. All rights reserved.
//

#import "LabelUtil.h"
#import "XYYSDK.h"
@implementation LabelUtil
+ (id)getInstance {
    __strong static LabelUtil *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LabelUtil alloc] init];
    });
    return instance;
}

- (CGFloat)fitLabelHeight:(UILabel *)label {
    //label.numberOfLines = 0;
    CGSize size = [label sizeThatFits:CGSizeMake(label.frame.size.width, 0)];
    //[label.text sizeWithFont:label.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    CGSize labelSize = [label.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size;
    
    CGRect frame = label.frame;
    //frame.size.height =size.height;
    frame.size.height = labelSize.height;
    label.frame = frame;
    
    return label.frame.size.height;
}

- (CGFloat)fitLabelWidth:(UILabel *)label {
    label.numberOfLines = 0;
    CGSize size = [label sizeThatFits:CGSizeMake(0, label.frame.size.height)];
    // [label.text sizeWithFont:label.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    CGSize labelSize = [label.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size;
    
    CGRect frame = label.frame;
    //frame.size.width = size.width;
    frame.size.width = labelSize.width;
    label.frame = frame;
    
    return label.frame.size.width;
}

-(CGFloat)getLabelHjjHeight:(NSString*) content label:(UILabel*)label width:(CGFloat)width{
    return [self getLabelHjjHeight:content label:label width:width size:15];
}

-(CGFloat)getLabelHjjHeight:(NSString*) content label:(UILabel*)label width:(CGFloat)width size:(CGFloat)size{
    if (IS_EMPTY(content)) {
        return 0;
    }
    ///先通过NSMutableAttributedString设置和上面tttLabel一样的属性,例如行间距,字体
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:content];
    //自定义str和TTTAttributedLabel一样的行间距
    NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
    [paragrapStyle setLineSpacing:8];
    //设置行间距
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, content.length)];
    //设置字体
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size] range:NSMakeRange(0, content.length)];
    
    //得到自定义行间距的UILabel的高度
    CGFloat labheight=[attrString boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
    if (label) {
        [label setAttributedText:attrString];
    }
    
    return labheight;
}
@end
