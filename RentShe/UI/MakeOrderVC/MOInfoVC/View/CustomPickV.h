//
//  CustomPickV.h
//  RentShe
//
//  Created by Lengzz on 2017/8/12.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomPickV;
@protocol CustomPickVDataSource<NSObject>
@required
- (NSInteger)numberOfComponentsInCustomPickV:(CustomPickV *)customPickV;
- (NSArray *)customPickV:(CustomPickV *)customPickV contentOfRowsInComponent:(NSInteger)component;
@end

@protocol CustomPickVDelegate<NSObject>
@optional
- (void)customPickV:(CustomPickV *)customPickV didSelectRows:(NSArray *)rows inComponents:(NSInteger)components;
@end

@interface CustomPickV : UIView

@property (nonatomic, weak) id<CustomPickVDelegate> delegate;
@property (nonatomic, weak) id<CustomPickVDataSource> dataSource;
- (void)showPickV;
- (void)reloadCustomPickV;
- (void)selectWithTitles:(NSArray *)arr;
- (NSInteger)selectedRowInComponent:(NSInteger)component; 
@end

