//
//  InformFooterV.h
//  RentShe
//
//  Created by Feng on 2017/11/19.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InformFooterV;
@protocol InformFooterVDataSource <NSObject>

@required

- (NSString *)informFooter:(InformFooterV *)footer imageUrlAtIndex:(NSInteger)index;

@end

@protocol InformFooterVDelegate <NSObject>

@required

- (void)informFooter:(InformFooterV *)footer clickImageAtIndex:(NSInteger)index;

@end
@interface InformFooterV : UIView
@property (nonatomic, weak) id <InformFooterVDelegate> delegate;
@property (nonatomic, weak) id <InformFooterVDataSource> dataSource;

- (void)updateHeader;
@end
