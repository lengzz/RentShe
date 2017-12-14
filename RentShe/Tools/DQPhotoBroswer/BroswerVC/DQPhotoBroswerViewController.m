//
//  DQPhotoBroswerViewController.m
//  RentShe
//
//  Created by Lengzz on 17/5/19.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "DQPhotoBroswerViewController.h"
#import "DQBroswerItemView.h"
@interface DQPhotoBroswerViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic)  UIScrollView *scrollView;
/** 初始显示的index */
@property (nonatomic,assign) NSUInteger index;
/** 相册数组 */
@property (nonatomic,strong) NSArray *photoModels;
/**页码显示*/
@property (nonatomic,strong) UILabel *pageNumLabel;

@property(nonatomic,copy) void(^setCurrentPageBlock)(NSInteger page);
@end

@implementation DQPhotoBroswerViewController
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = self.bounds;
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(self.width * self.photoModels.count , 0);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = YES;
        _scrollView.delegate = self;
        [_scrollView setContentOffset:CGPointMake(self.index * self.width, 0) animated:NO];
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

+(void)showWithIndex:(NSUInteger)index photoModelBlock:(NSArray *(^)())photoModelBlock currentPageWhenDismiss:(void(^)(NSInteger page))setCurrentPage
{
    DQPhotoBroswerViewController *pbVC = [[self alloc] init];
    
    //记录
    pbVC.index = index;
    
    pbVC.photoModels = photoModelBlock();
    
    pbVC.setCurrentPageBlock = setCurrentPage;
    
    [pbVC addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:pbVC action:@selector(dismiss)]];
    //展示
    [pbVC show];

}
- (void)show
{
    //拿到window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    self.frame=[UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor blackColor];
    
    //添加视图
    [window addSubview:self];

    for (int i = 0; i < self.photoModels.count;i++) {
        DQBroswerItemView *itemView = [[DQBroswerItemView alloc] init];
        itemView.frame = CGRectMake(self.width * i, 0, self.width, self.height);
        itemView.pModel = self.photoModels[i];
        [self.scrollView addSubview:itemView];
    }
      __weak typeof(self) weak = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weak addNumPageIndicate];
    });
    
}
#pragma mark - 获取显示当前页码
- (void)addNumPageIndicate
{
     self.pageNumLabel = [[UILabel alloc] init];
     self.pageNumLabel.textColor = [UIColor whiteColor];
     self.pageNumLabel.textAlignment = NSTextAlignmentCenter;
     self.pageNumLabel.x = kWindowWidth - 70;
     self.pageNumLabel.y = kWindowHeight - 35 - 39;
     self.pageNumLabel.width = 39;
     self.pageNumLabel.height = 39;
     self.pageNumLabel.attributedText = [self addTextPageNum:self.index + 1];
   
//    UIImageView *imgView = [[UIImageView alloc] init];
//    imgView.image = [UIImage imageNamed:@"pageBg"];
//    imgView.frame = self.pageNumLabel.frame;
//    [self.view addSubview:imgView];
    [self addSubview: self.pageNumLabel];
}
- (NSAttributedString *)addTextPageNum:(NSInteger)idx
{
    
    NSString *text =[NSString stringWithFormat:@"%ld/%ld",(long)idx,self.photoModels.count];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:text];
    NSRange range = [text rangeOfString:@(idx).stringValue];
    if (idx >= 10) {
        self.pageNumLabel.font = [UIFont systemFontOfSize:13];
        [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
    }else{
        self.pageNumLabel.font = [UIFont systemFontOfSize:17];
        [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:range];
    }
    return attStr;
}

- (void)dismiss
{
    [self zoomBackBeforeAndDismiss:YES];
    NSInteger page = self.scrollView.contentOffset.x / self.scrollView.width;
    self.setCurrentPageBlock(page);
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        weakSelf.photoModels = nil;
        
        //移除视图
        [weakSelf removeFromSuperview];
    });
}
#pragma mark - 复原图片
- (void)zoomBackBeforeAndDismiss:(BOOL)dismiss
{
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(UIView *subView, NSUInteger idx, BOOL *stop) {
        if([subView isKindOfClass:[DQBroswerItemView class]]){
            DQBroswerItemView *itemView = (DQBroswerItemView *)subView;
            [itemView resetToDismiss:dismiss];
        }
    }];

}

#pragma mark - scrollView代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self zoomBackBeforeAndDismiss:NO];
     self.pageNumLabel.attributedText = [self addTextPageNum:(NSInteger)scrollView.contentOffset.x/kWindowWidth + 1];
}

@end
