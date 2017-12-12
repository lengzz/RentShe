//
//  UINavigationBar+Custom.h
//  CustomNavBar
//
//  Created by Lzz on 2017/9/22.
//  Copyright © 2017年 Lzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (Custom)
/**
 *  NavBar Background
 */
@property (nonatomic, strong, readonly) UIView *cusBgV;

- (void)setCustomBarBackgroundColor:(UIColor *)backgroundColor;
- (void)setTranslationY:(CGFloat)translationY;
- (void)setSubviewsAlpha:(CGFloat)alpha;
- (void)resetCustomBackground;
@end

@interface UINavigationController (Custom)
/**
 *  UINavigationController PopGestureRecognizer
 */
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *fullscreenPopGestureRecognizer;

@property (nonatomic, assign) BOOL viewControllerBasedNavigationBarAppearanceEnabled;

@end


@interface UIViewController (Custom)

/// Whether the interactive pop gesture is disabled when contained in a navigation
/// stack.
@property (nonatomic, assign) BOOL interactivePopDisabled;
/// Indicate this view controller prefers its navigation bar hidden or not,
/// checked when view controller based navigation bar's appearance is enabled.
/// Default to NO, bars are more likely to show.
@property (nonatomic, assign) BOOL prefersNavigationBarHidden;
/// Max allowed initial distance to left edge when you begin the interactive pop
/// gesture. 0 by default, which means it will ignore this limit.
@property (nonatomic, assign) CGFloat interactivePopMaxAllowedInitialDistanceToLeftEdge;

@end
