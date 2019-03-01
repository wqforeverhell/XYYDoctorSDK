//
//  SessionConfig.m
//  CloudXinDemo
//
//  Created by mango on 16/8/27.
//  Copyright © 2016年 mango. All rights reserved.
//

#import "SessionConfig.h"
#import "ImageUtil.h"
@implementation SessionConfig

- (NSArray *)mediaItems
{
    return @[[NIMMediaItem item:@"onTapMediaItemPicture:"
                    normalImage:[ImageUtil getImageByPatch:@"bk_media_picture_normal"]
                  selectedImage:[ImageUtil getImageByPatch:@"bk_media_picture_normal"]
                          title:@"相册"],
             
             [NIMMediaItem item:@"onTapMediaItemShoot:"
                    normalImage:[ImageUtil getImageByPatch:@"bk_media_shoot_normal"]
                  selectedImage:[ImageUtil getImageByPatch:@"bk_media_shoot_normal"]
                          title:@"拍摄"],
             
//             [NIMMediaItem item:NTESMediaButtonLocation
//                    normalImage:[UIImage imageNamed:@"bk_media_position_normal"]
//                  selectedImage:[UIImage imageNamed:@"bk_media_position_pressed"]
//                          title:@"位置"],
//
//             [NIMMediaItem item:NTESMediaButtonJanKenPon
//                    normalImage:[UIImage imageNamed:@"icon_jankenpon_normal"]
//                  selectedImage:[UIImage imageNamed:@"icon_jankenpon_pressed"]
//                          title:@"石头剪刀布"],
             
//             [NIMMediaItem item:@"onTapMediaItemAudioChat:"
//                    normalImage:[UIImage imageNamed:@"btn_media_telphone_message_normal"]
//                  selectedImage:[UIImage imageNamed:@"btn_media_telphone_message_pressed"]
//                          title:@"实时语音"],

             [NIMMediaItem item:@"onTapMediaItemVideoChat:"
                    normalImage:[ImageUtil getImageByPatch:@"btn_bk_media_video_chat_normal"]
                  selectedImage:[ImageUtil getImageByPatch:@"btn_bk_media_video_chat_normal"]
                          title:@"视频聊天"]];
//             ,
//
//             [NIMMediaItem item:NTESMediaButtonFileTrans
//                    normalImage:[UIImage imageNamed:@"icon_file_trans_normal"]
//                  selectedImage:[UIImage imageNamed:@"icon_file_trans_pressed"]
//                          title:@"文件传输"],
//
//             [NIMMediaItem item:NTESMediaButtonSnapchat
//                    normalImage:[UIImage imageNamed:@"bk_media_snap_normal"]
//                  selectedImage:[UIImage imageNamed:@"bk_media_snap_pressed"]
//                          title:@"阅后即焚"],
//
//             [NIMMediaItem item:NTESMediaButtonWhiteBoard
//                    normalImage:[UIImage imageNamed:@"btn_whiteboard_invite_normal"]
//                  selectedImage:[UIImage imageNamed:@"btn_whiteboard_invite_pressed"]
//                          title:@"白板"],
//
//             [NIMMediaItem item:NTESMediaButtonTip
//                    normalImage:[UIImage imageNamed:@"bk_media_tip_normal"]
//                  selectedImage:[UIImage imageNamed:@"bk_media_tip_pressed"]
//                          title:@"提醒消息"]];
    
    
}


- (BOOL)shouldHideItem:(NIMMediaItem *)item
{
    BOOL hidden = NO;
    BOOL isMe   = _session.sessionType == NIMSessionTypeP2P
    && [_session.sessionId isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]];
    if (_session.sessionType == NIMSessionTypeTeam || isMe) {
//        hidden = item.tag == NTESMediaButtonAudioChat ||
//        item.tag == NTESMediaButtonVideoChat ||
//        item.tag == NTESMediaButtonWhiteBoard||
//        item.tag == NTESMediaButtonSnapchat;
    }
    return hidden;
}

- (NSArray<NSNumber *> *)inputBarItemTypes{
    if (self.session.sessionType == NIMSessionTypeP2P && [[NIMSDK sharedSDK].robotManager isValidRobot:self.session.sessionId])
    {
        //和机器人 点对点 聊天
        return @[
                 @(NIMInputBarItemTypeTextAndRecord),
                 ];
    }
    return @[
             @(NIMInputBarItemTypeVoice),
             @(NIMInputBarItemTypeTextAndRecord),
             ];
}

- (id<NIMCellLayoutConfig>)layoutConfigWithMessage:(NIMMessage *)message{
    id<NIMCellLayoutConfig> config;
    
       return config;
}

- (BOOL)shouldHandleReceipt{
    return YES;
}
-(BOOL)disableInputView{
    return _isDisableInputView;
}
- (BOOL)shouldHandleReceiptForMessage:(NIMMessage *)message
{
    //文字，语音，图片，视频，文件，地址位置和自定义消息都支持已读回执，其他的不支持
    NIMMessageType type = message.messageType;
    if (type == NIMMessageTypeCustom) {
        NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
        id attachment = object.attachment;
        
    }
    
    
    
    return type == NIMMessageTypeText ||
    type == NIMMessageTypeAudio ||
    type == NIMMessageTypeImage ||
    type == NIMMessageTypeVideo ||
    type == NIMMessageTypeFile ||
    type == NIMMessageTypeLocation ||
    type == NIMMessageTypeCustom;
}



@end
