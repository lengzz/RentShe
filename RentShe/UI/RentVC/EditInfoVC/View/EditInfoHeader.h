//
//  EditInfoHeader.h
//  RentShe
//
//  Created by Lengzz on 2017/9/23.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EditInfoHeader;
@protocol EditInfoHeaderDataSource <NSObject>

@required

- (NSString *)editInfoHeader:(EditInfoHeader *)header imageUrlAtIndex:(NSInteger)index;

@end

@protocol EditInfoHeaderDelegate <NSObject>

@required

- (void)editInfoHeader:(EditInfoHeader *)header clickImageAtIndex:(NSInteger)index;
- (void)editInfoHeader:(EditInfoHeader *)header moveImageAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)toIndex;

@end

@interface EditInfoHeader : UIView

@property (nonatomic, weak) id <EditInfoHeaderDelegate> delegate;
@property (nonatomic, weak) id <EditInfoHeaderDataSource> dataSource;

@property (nonatomic, assign) NSInteger imgNum;

- (void)deleteImage:(NSInteger)index;
- (void)addImage:(NSInteger)index;
- (void)updateHeader;
@end
