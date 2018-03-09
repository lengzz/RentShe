//
//  TextCell.m
//  BeautyDemo
//
//  Created by kennethmiao on 17/5/9.
//  Copyright © 2017年 kennethmiao. All rights reserved.
//

#import "TextCell.h"

@implementation TextCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setupView];
    }
    return self;
}

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

- (void)setSelected:(BOOL)selected
{
    if(selected){
        self.label.textColor = kRGB_Value(0x0ACCAC);
    }
    else{
        self.label.textColor = [UIColor whiteColor];
    }
}

- (void)setupView
{
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.label = [[UILabel alloc] initWithFrame:self.bounds];
    self.label.textColor = [UIColor whiteColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.label];
}


@end
