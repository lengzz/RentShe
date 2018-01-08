//
//  ConversationCell.h
//  RentShe
//
//  Created by Lengzz on 17/5/31.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, CustomConversation)
{
    CustomConversationOfService = 1
};
@interface ConversationCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, assign) CustomConversation type;

@end
