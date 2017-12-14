//
//  DQBroswerItemView.m
//  RentShe
//
//  Created by Lengzz on 17/5/19.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "DQBroswerItemView.h"
#import "DQPhotoModel.h"
@interface DQBroswerItemView ()<UIScrollViewDelegate>
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIImageView  *imgView;
@end
@implementation DQBroswerItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.backgroundColor = [UIColor blackColor];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.delegate = self;
        self.scrollView.minimumZoomScale = 1.0;
        self.scrollView.maximumZoomScale = 2.0;
        [self addSubview:self.scrollView];
        self.imgView = [[UIImageView alloc] init];
        self.imgView.backgroundColor = [UIColor redColor];
        [self.scrollView addSubview:self.imgView];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
     self.scrollView.frame = self.bounds;
    self.imgView.frame = CGRectMake(0,65, self.scrollView.frame.size.width, kWindowWidth);
    typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        CGFloat W = self.scrollView.frame.size.width;
        CGFloat H = kWindowWidth;
        CGFloat Y = (self.bounds.size.height - H)/2;
        weakSelf.imgView.frame = CGRectMake(0, Y, W, H);
    }];
}
- (void)setPModel:(DQPhotoModel *)pModel
{
    _pModel = pModel;
    [self.imgView sd_setImageWithUrlStr:pModel.image_HD_U];
}
- (void)resetToDismiss:(BOOL)dismiss
{
    self.scrollView.zoomScale = 1.0;
    if (dismiss) {
        typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.imgView.frame = CGRectMake(0,kNavBarHeight, self.scrollView.frame.size.width, kWindowWidth);
        }];
    }
}
#pragma mark - scrollView代理方法
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imgView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
    
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
    
    [self.imgView setCenter:CGPointMake(xcenter, ycenter)];
}

@end
