//
//  ConversationHeader.h
//  RentShe
//
//  Created by Lzz on 2017/12/29.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConversationCell.h"

@class ConversationHeader;

@protocol ConversationHeaderDelegate<NSObject>

- (void)conversationHeader:(ConversationHeader *)header didSelectWithType:(CustomConversation )type;
@end

@interface ConversationHeader : UIView

@property (nonatomic, weak) id <ConversationHeaderDelegate> delegate;
+ (instancetype)header;
@end
