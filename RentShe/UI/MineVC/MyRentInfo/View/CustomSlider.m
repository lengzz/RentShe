//
//  CustomSlider.m
//  RentShe
//
//  Created by Lengzz on 17/5/27.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "CustomSlider.h"
#define kBtnWidth 34
#define kBtnHeight 40

@interface CustomSlider ()
{
    UILabel *_leftLab;
    UILabel *_rightLab;
    UIImageView *_leftImg;
    UIImageView *_rightImg;
    UIButton *_leftBtn;
    UIButton *_rightBtn;
    
    CGFloat _leftBtnCenX;
    CGFloat _rightBtnCenX;
    
    CGFloat _currentVX;
}

@end

@implementation CustomSlider

- (void)setCenterX:(UIView *)v withCenter:(CGFloat)cenX
{
    CGPoint point = v.center;
    point.x = cenX;
    v.center = point;
}

- (void)setLeftValue:(CGFloat)leftValue
{
    _leftValue = leftValue;
    if (_rightValue)
    {
        _leftValue = leftValue > _rightValue?(_minValue?_minValue:0):leftValue;
    }
    if (leftValue < _minValue)
    {
        _leftValue = _minValue;
    }
    CGFloat centerX = (_leftValue - _minValue)* (self.bounds.size.width - kBtnWidth) / (_maxValue - _minValue);
    [self setCenterX:_leftBtn withCenter:centerX + kBtnWidth/2.0];
    _leftBtnCenX = centerX + kBtnWidth/2.0;
    
    _leftLab.text = [NSString stringWithFormat:@"%.0f",_leftValue];
    [_leftLab sizeToFit];
    [self setNeedsDisplay];
    [self setTopBtn];
}

- (void)setRightValue:(CGFloat)rightValue
{
    _rightValue = rightValue;
    if (_leftValue)
    {
        _rightValue = rightValue >= _leftValue ? rightValue : (_maxValue?_maxValue:_leftValue);
    }
    if (rightValue > _maxValue)
    {
        _rightValue = _maxValue;
    }
    
    CGFloat centerX = (_rightValue - _minValue) * (self.bounds.size.width - kBtnWidth)/ (_maxValue - _minValue);
    [self setCenterX:_rightBtn withCenter:centerX + kBtnWidth/2.0];
    _rightBtnCenX = centerX + kBtnWidth/2.0;
    
    _rightLab.text = [NSString stringWithFormat:@"%.0f",_rightValue];
    [_rightLab sizeToFit];
    [self setNeedsDisplay];
    [self setTopBtn];
}

- (void)setValue:(CGFloat *)value withOrignX:(CGFloat)x
{
    CGFloat val = (x - kBtnWidth/2.0)*(_maxValue - _minValue)/(self.bounds.size.width - kBtnWidth) + _minValue;
    if (value == &_leftValue)
    {
        self.leftValue = val;
    }
    else
        self.rightValue = val;
    if (self.resultBlock) {
        self.resultBlock(self.leftValue,self.rightValue);
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createV];
    }
    return self;
}

- (void)createV
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    self.backgroundColor = [UIColor whiteColor];
    UIImageView *leftImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rentinfo_time_line"]];
    leftImg.frame = CGRectMake(30, self.bounds.size.height/2.0 - 5, 1.5, 10);
    _leftImg = leftImg;
    [self addSubview:leftImg];
    
    UILabel *leftLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(leftImg.frame) - 20, 0, 14)];
    leftLab.font = [UIFont systemFontOfSize:14];
    leftLab.textColor = kRGB_Value(0x868686);
    leftLab.text = @"6";
    _leftLab = leftLab;
    [self addSubview:leftLab];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"rentinfo_time_arrows"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"rentinfo_time_arrows"] forState:UIControlStateHighlighted];
    leftBtn.frame = CGRectMake(7, self.bounds.size.height/2.0 - kBtnHeight/2.0, kBtnWidth, kBtnHeight);
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    leftBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    [leftBtn addGestureRecognizer:pan];
    _leftBtn = leftBtn;
    [self addSubview:leftBtn];
    
    UIImageView *rightImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rentinfo_time_line"]];
    rightImg.frame = CGRectMake(100, self.bounds.size.height/2.0 - 5, 1.5, 10);
    _rightImg = rightImg;
    [self addSubview:rightImg];
    
    UILabel *rightLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(rightImg.frame) - 20, 0, 14)];
    rightLab.font = [UIFont systemFontOfSize:14];
    rightLab.textColor = kRGB_Value(0x868686);
    rightLab.text = @"12";
    //    [rightLab sizeToFit];
    _rightLab = rightLab;
    [self addSubview:rightLab];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"rentinfo_time_arrows"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"rentinfo_time_arrows"] forState:UIControlStateHighlighted];
    rightBtn.frame = CGRectMake(100, self.bounds.size.height/2.0 - kBtnHeight/2.0, kBtnWidth, kBtnHeight);
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    rightBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    [rightBtn addGestureRecognizer:pan];
    _rightBtn = rightBtn;
    [self addSubview:rightBtn];
    _leftBtnCenX = _leftBtn.center.x;
    _rightBtnCenX = _rightBtn.center.x;
}

- (void)layoutSubviews
{
    [self setCenterX:_leftImg withCenter:_leftBtnCenX];
    [self setCenterX:_leftLab withCenter:_leftBtnCenX];
    
    [self setCenterX:_rightImg withCenter:_rightBtnCenX];
    [self setCenterX:_rightLab withCenter:_rightBtnCenX];
}

- (void)tapGestureAction:(UIPanGestureRecognizer *)pan
{
    UIView *v = pan.view;
    CGPoint transPoint = [pan translationInView:self];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            [self bringSubviewToFront:v];
            if ([v isEqual:_leftBtn])
            {
                _currentVX = _leftBtn.frame.origin.x;
            }
            else if ([v isEqual:_rightBtn])
            {
                _currentVX = _rightBtn.frame.origin.x;
            }
            break;
            
        case UIGestureRecognizerStateChanged:
            if ([v isEqual:_leftBtn])
            {
                CGRect frame = _leftBtn.frame;
                frame.origin.x = _currentVX + transPoint.x;
                if (frame.origin.x < 0)
                {
                    frame.origin.x = 0;
                }
                else if (frame.origin.x > _rightBtn.frame.origin.x)
                {
                    frame.origin.x = _rightBtn.frame.origin.x;
                }
                _leftBtn.frame = frame;
                _leftBtnCenX = _leftBtn.center.x;
                [self setValue:&_leftValue withOrignX:_leftBtnCenX];
            }
            else if ([v isEqual:_rightBtn])
            {
                CGRect frame = _rightBtn.frame;
                frame.origin.x = _currentVX + transPoint.x;
                if (frame.origin.x > self.bounds.size.width - kBtnWidth)
                {
                    frame.origin.x = self.bounds.size.width - kBtnWidth;
                }
                else if (frame.origin.x < _leftBtn.frame.origin.x)
                {
                    frame.origin.x = _leftBtn.frame.origin.x;
                }
                _rightBtn.frame = frame;
                _rightBtnCenX = _rightBtn.center.x;
                [self setValue:&_rightValue withOrignX:_rightBtnCenX];
            }
            break;
            
        default:
            break;
    }
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)setTopBtn
{
    if (_leftBtn.frame.origin.x < kBtnWidth)
    {
        [self bringSubviewToFront:_rightBtn];
    }
    else
    {
        [self bringSubviewToFront:_leftBtn];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 3);
    [kRGB_Value(0x868686) setStroke];
    CGContextMoveToPoint(context, kBtnWidth/2.0, self.bounds.size.height/2.0);
    CGContextAddLineToPoint(context, self.bounds.size.width - kBtnWidth/2.0, self.bounds.size.height/2.0);
    CGContextStrokePath(context);
    
    [kRGB(255, 101, 0) setStroke];
    CGContextMoveToPoint(context, _leftBtnCenX, self.bounds.size.height/2.0);
    CGContextAddLineToPoint(context, _rightBtnCenX, self.bounds.size.height/2.0);
    CGContextStrokePath(context);
}

@end
