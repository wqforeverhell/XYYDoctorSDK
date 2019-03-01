//
//  HDInputTableViewCell.m
//  InputTableViewDemo
//
//  Created by Hou on 17/6/19.
//  Copyright © 2017年 HoHoDoDo. All rights reserved.
//

#import "HDInputTableViewCell.h"
#import <CoreText/CoreText.h>

static const CGFloat leftPadding     = 15.0;
static const CGFloat rightPadding    = 10.0;
static const CGFloat bothSidePadding = 10.0;
static const CGFloat titleWidth      = 80.0;


@implementation HDInputTableViewCell
@synthesize iconView, titleLabel, inputField, maskControl, line;

+ (instancetype)hd_initInputTableViewCellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier delegate:(id<HDInputTableViewCellDelegate>)delegate {

    HDInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[HDInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.delegate = delegate;
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:iconView];
        //iconView.backgroundColor = ColorRandom;
        
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:15.f];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.numberOfLines = 0;
        [self.contentView addSubview:titleLabel];
        //titleLabel.backgroundColor = ColorRandom;
        
        
        inputField = [[HDTextField alloc] initWithFrame:CGRectZero];
        inputField.clearsOnBeginEditing = NO;
        inputField.textColor = [UIColor blackColor];
        inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
        inputField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        //inputField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10.f, 0)];
        //inputField.leftViewMode = UITextFieldViewModeAlways;
        inputField.font = [UIFont systemFontOfSize:15.f];
        inputField.delegate = self;
        [inputField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:inputField];
        //inputField.backgroundColor = ColorRandom;
        
        
        maskControl = [[UIControl alloc] initWithFrame:self.contentView.bounds];
        [maskControl addTarget:self action:@selector(respondEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:maskControl];
        maskControl.hidden = YES;
        //maskControl.backgroundColor = ColorRandom;
        
        
        line = [CALayer layer];
        line.frame = CGRectZero;
        line.backgroundColor = [UIColor colorWithRed:221.f/255.f green:221.f/255.f blue:221.f/255.f alpha:1].CGColor;
        [self.contentView.layer addSublayer:line];
        
    }
    return self;
}


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL result = [self callbackTextField:textField shouldChangeCharactersInRange:range replacementString:string];
    return result;
}

- (BOOL)callbackTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    BOOL result = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(hd_inputTableViewCell:textFieldShouldChangeCharactersInRange:replacementString:)]) {
        result = [self.delegate hd_inputTableViewCell:self textFieldShouldChangeCharactersInRange:range replacementString:string];
    }
    return result;
}

#pragma mark - Actions
- (void)textFieldEditingChanged:(HDTextField *)textField {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(hd_inputTableViewCell:textFieldEditingChanged:)]) {
        self.inputModel.text = textField.text;
        [self.delegate hd_inputTableViewCell:self textFieldEditingChanged:textField.text];
    }
}

- (void)respondEvent:(id)sender {
    
    [[UIApplication sharedApplication] sendAction: @selector(resignFirstResponder)
                                               to: nil
                                             from: nil
                                         forEvent: nil];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(hd_inputTableViewCell:didSelectEvent:)]) {
        [self.delegate hd_inputTableViewCell:self didSelectEvent:self.event];
    }
    
}

- (void)setObject:(HDInputModel *)object {
    
    if (![object isKindOfClass:[HDInputModel class]]) return;
    
    self.inputModel             = object;
    iconView.image              = [UIImage imageNamed:object.iconName ?: @""];
    titleLabel.text             = object.title ?: nil;
    inputField.text             = object.text ?: @"";
    inputField.textColor        = object.textColor ?: [UIColor blackColor];
    inputField.placeholder      = object.placeHolder ?: @"";
    inputField.textAlignment    = object.inputAlignment ?: NSTextAlignmentLeft;
    inputField.keyboardType     = object.keyboardType ?: UIKeyboardTypeDefault;
    inputField.secureTextEntry  = object.secureTextEntry;
    maskControl.hidden          = object.editEnabled;
    inputField.enabled          = object.editEnabled;
    maskControl.hidden          = !object.clickEnable;
    inputField.enabled          = !object.clickEnable;
    self.accessoryView          = object.accessoryView ?: nil;
    self.accessoryType          = object.accessoryType ?: UITableViewCellAccessoryNone;
    self.event                  = object.event ?: @"";
}


- (BOOL)hd_inputLimitLength:(NSInteger)length allowString:(NSString *)allowString inputCharacter:(NSString *)character{
    
    if ([self isEmpty:allowString]) {
        if ([self.inputField.text length] < length || [character length] == 0) {
            return YES;
        } else {
            [self.inputField shakeAnimation];
            return NO;
        }
    } else {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:allowString] invertedSet];
        NSString *filtered = [[character componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL canChange     = [character isEqualToString:filtered];
        
        if ((canChange && [self.inputField.text length] < length) || [character length] == 0) {
            return YES;
        } else {
            [self.inputField shakeAnimation];
            return NO;
        }
    }
    return YES;
}

- (BOOL)hd_amountFormatWithIntegerBitLength:(NSInteger)length digitsLength:(NSInteger)digitsLength inputCharacter:(NSString *)character {
    
    if ([character isEqualToString:@""])
        return YES;
    
    if (self.inputField.text.length == 0) {
        if ([character isEqualToString:@"."]) {
            [self.inputField shakeAnimation];
            return NO;
        }
    }
    if ([self.inputField.text hasPrefix:@"0"]) {
        if (self.inputField.text.length == 1 && [character isEqualToString:@"0"]) {
            [self.inputField shakeAnimation];
            return NO;
        }
    }
    if ([self.inputField.text containsString:@"."]) {
        if ([character isEqualToString:@"."]) {
            [self.inputField shakeAnimation];
            return NO;
        }
        NSRange rangeOfPoint = [self.inputField.text rangeOfString:@"."];
        if (self.inputField.text.length > rangeOfPoint.location + digitsLength) {
            [self.inputField shakeAnimation];
            return NO;
        }
        if (self.inputField.text.length == length + digitsLength + 1) {
            [self.inputField shakeAnimation];
            return NO;
        }
    } else {
        if (self.inputField.text.length == length) {
            if ([character isEqualToString:@"."])
                return YES;
            [self.inputField shakeAnimation];
            return NO;
        }
    }
    return YES;
}

#pragma mark - private method
///判空
- (BOOL)isEmpty:(NSString *)string {
    
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

#pragma mark - layout
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    /*
     默认情况下：accessoryView右边距会空出20像素，所以重置accessoryView的frame，让其右边距为0
     */
    CGRect accessoryViewFrame   = self.accessoryView.frame;
    accessoryViewFrame.origin.x = CGRectGetWidth(self.bounds) - CGRectGetWidth(accessoryViewFrame);
    self.accessoryView.frame    = accessoryViewFrame;
    
    CGSize imageSize = iconView.image.size;
    iconView.frame = CGRectMake(leftPadding,
                                (self.height - imageSize.height) / 2,
                                imageSize.width,
                                imageSize.height);
    
    CGFloat padding0 = bothSidePadding;
    if (CGSizeEqualToSize(imageSize, CGSizeZero)) padding0 = 0;
    
    CGFloat title_w  = self.inputModel.titleMaxWidth ?: titleWidth;
    titleLabel.frame = CGRectMake(iconView.right + padding0,
                                  0,
                                  [self isEmpty:titleLabel.text] ? 0.f : title_w,
                                  self.height);
    
    if (self.inputModel.alignmentBothEnds) [titleLabel alignmentBothEnds];
    
    CGFloat padding = bothSidePadding;
    if ([self isEmpty:titleLabel.text]) padding = 0;
    
    if (self.accessoryType != UITableViewCellAccessoryNone) {
        inputField.frame = CGRectMake(titleLabel.right + padding,
                                      0,
                                      self.width - (titleLabel.right + padding) - rightPadding - 20,
                                      self.height);
    } else if (self.accessoryView){
        inputField.frame = CGRectMake(titleLabel.right + padding,
                                      0,
                                      self.width - (titleLabel.right + padding) - self.accessoryView.width - rightPadding,
                                      self.height);
    } else {
        inputField.frame = CGRectMake(titleLabel.right + padding,
                                      0,
                                      self.width - (titleLabel.right + padding) - rightPadding,
                                      self.height);
    }
    
    if (!maskControl.isHidden) {
        maskControl.frame = self.contentView.bounds;
    }
    
    if (CGRectEqualToRect(self.inputModel.lineFrame, CGRectZero)) {
        //line.frame = CGRectMake(inputField.left, inputField.bottom - 0.5, inputField.width, 0.5);
    } else {
        line.frame = self.inputModel.lineFrame;
    }
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end




/******************************* HDInputModel **********************************/

@implementation HDInputModel
@end





/******************************* UILabel (HDCategory) **********************************/

@implementation UILabel (HDCategory)

- (void)alignmentBothEnds {
    
    if (!self.text) return;
    CGSize textSize = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin |
                                                      NSStringDrawingTruncatesLastVisibleLine |
                                                      NSStringDrawingUsesFontLeading
                                           attributes:@{NSFontAttributeName : self.font}
                                              context:nil].size;
    
    CGFloat margin   = (self.frame.size.width - textSize.width) / (self.text.length - 1);
    NSNumber *number = [NSNumber numberWithFloat:margin];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attributeString addAttribute:(id)kCTKernAttributeName value:number range:NSMakeRange(0, self.text.length - 1)];
    self.attributedText = attributeString;
}

@end



/******************************* UIView (HDCategory) **********************************/

@implementation UIView (HDCategory)

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)shakeAnimation {
    
    CALayer* layer = [self layer];
    CGPoint position = [layer position];
    CGPoint y = CGPointMake(position.x - 3.0f, position.y);
    CGPoint x = CGPointMake(position.x + 3.0f, position.y);
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.08f];
    [animation setRepeatCount:3];
    [layer addAnimation:animation forKey:nil];
}

- (void)addTarget:(id)target action:(SEL)action {

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}
@end


