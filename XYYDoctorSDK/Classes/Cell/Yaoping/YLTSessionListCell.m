//
//  YLTSessionListCell.m
//  yaolianti
//
//  Created by zl on 2018/7/18.
//  Copyright © 2018年 hlw. All rights reserved.
//

#import "YLTSessionListCell.h"
#import "NIMAvatarImageView.h"
#import "UIView+NIM.h"
#import "NIMKitUtil.h"
#import "NIMBadgeView.h"
#import "HuanzheStruce.h"
#import "XYYDoctorSDK.h"
@interface YLTSessionListCell()
{
    onjieshuBlock _block;
}
@end
@implementation YLTSessionListCell
#define AvatarWidth 40
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _avatarImageView = [[NIMAvatarImageView alloc] initWithFrame:CGRectMake375(15, 10, 45, 45)];
        [self addSubview:_avatarImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 120, 15)];
        _nameLabel.backgroundColor = [UIColor whiteColor];
        _nameLabel.textColor       =  RGB(51, 51, 51);
        _nameLabel.font            = [UIFont systemFontOfSize:15.f];
        //_nameLabel.nim_width = 140;
        [self addSubview:_nameLabel];
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageLabel.backgroundColor = [UIColor whiteColor];
        _messageLabel.font            = [UIFont systemFontOfSize:14.f];
        _messageLabel.textColor       = [UIColor lightGrayColor];
        [self addSubview:_messageLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.backgroundColor = [UIColor whiteColor];
        _timeLabel.font            = [UIFont systemFontOfSize:14.f];
        _timeLabel.textColor       = [UIColor lightGrayColor];
        _timeLabel.hidden = YES;
        [self addSubview:_timeLabel];
        
        _badgeView = [NIMBadgeView viewWithBadgeTip:@""];
        _badgeView.hidden = YES;
        [self addSubview:_badgeView];
        
        _jieshuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _jieshuBtn.frame = CGRectMake375(120, 24, 100, 60);
        _jieshuBtn.hidden = NO;
        _jieshuBtn.titleLabel.font = FONT(15);
        [_jieshuBtn setBackgroundColor:JIANBIAN_GREEN_START_COLOR];
        _jieshuBtn.layer.cornerRadius = 5;
        _jieshuBtn.layer.masksToBounds = YES;
        [_jieshuBtn setTitle:@"结束会诊" forState:UIControlStateNormal];
        //[_jieshuBtn setBackgroundColor:HUISE_COLOR];
        [_jieshuBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_jieshuBtn];
        
    }
    return self;
}

#define NameLabelMaxWidth    160.f
#define MessageLabelMaxWidth 130.f
-(void)reloadDataWithModel:(DoctorWithListDetailModel*)model{
    self.model = model;
    self.nameLabel.nim_width = self.nameLabel.nim_width > NameLabelMaxWidth ? NameLabelMaxWidth : self.nameLabel.nim_width;
    [self.avatarImageView nim_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.headPicUrl]] placeholderImage:[UIImage imageNamed:@"icon_team_creator"]];
   
}
-(void)setOnYpBigAddBlock:(onjieshuBlock)block{
    if (block) {
        _block=nil;
        _block=[block copy];
    }
}

- (void)btnClick {
    if(_block){
        _block(self.model);
    }
    
}

//- (void)layoutSubviews{
//    [super layoutSubviews];
//    //Session List
//    NSInteger sessionListAvatarLeft             = 15;
//    NSInteger sessionListNameTop                = 15;
//    NSInteger sessionListNameLeftToAvatar       = 15;
//    NSInteger sessionListMessageLeftToAvatar    = 15;
//    NSInteger sessionListMessageBottom          = 15;
//    NSInteger sessionListTimeRight              = 15;
//    NSInteger sessionListTimeTop                = 15;
//    NSInteger sessionBadgeTimeBottom            = 15;
//    NSInteger sessionBadgeTimeRight             = 15;
//
//    _avatarImageView.nim_left    = sessionListAvatarLeft;
//    _avatarImageView.nim_centerY = self.nim_height * .5f;
//    _nameLabel.nim_top           = sessionListNameTop;
//    _nameLabel.nim_left          = _avatarImageView.nim_right + sessionListNameLeftToAvatar;
//    _messageLabel.nim_left       = _avatarImageView.nim_right + sessionListMessageLeftToAvatar;
//    _messageLabel.nim_bottom     = self.nim_height - sessionListMessageBottom;
//    _timeLabel.nim_right         = self.nim_width - sessionListTimeRight;
//    _timeLabel.nim_top           = sessionListTimeTop;
//    _jieshuBtn.nim_right         =  self.nim_width- sessionBadgeTimeRight;
//    _jieshuBtn.nim_bottom        =   self.nim_height-sessionBadgeTimeBottom;
//
//    _jieshuBtn.nim_top = _timeLabel.nim_bottom + 5;
//    _jieshuBtn.nim_height = AutoY375(30);
//
//}

@end

