//
//  ShareToV.m
//  CustomNavBar
//
//  Created by Lzz on 2017/11/7.
//  Copyright © 2017年 Lzz. All rights reserved.
//

#import "ShareToV.h"

#define kShareToCell @"ShareToCell"


@interface ShareToCell : UICollectionViewCell

- (void)refreshCell:(id)obj;

@end

@interface ShareToV ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIView *_contentV;
    UICollectionView *_myCollectionV;
}
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation ShareToV

+ (instancetype)shareInstance
{
    static ShareToV *shareV = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareV = [[ShareToV alloc] init];
    });
    return shareV;
}

+ (BOOL)isShare
{
    BOOL isShare = NO;
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession])
    {
        isShare = YES;
    }
    
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ])
    {
        isShare = YES;
    }
    return isShare;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createV];
        [self configData];
    }
    return self;
}

- (void)configData
{
    self.dataArr = [NSMutableArray array];
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession])
    {
        [self.dataArr addObject:@(UMSocialPlatformType_WechatSession)];
        [self.dataArr addObject:@(UMSocialPlatformType_WechatTimeLine)];
    }
    
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ])
    {
        [self.dataArr addObject:@(UMSocialPlatformType_QQ)];
        [self.dataArr addObject:@(UMSocialPlatformType_Qzone)];
    }
    [self.dataArr addObject:@(UMSocialPlatformType_UserDefine_Report)];
    [self.dataArr addObject:@(UMSocialPlatformType_UserDefine_Shield)];
    [_myCollectionV reloadData];
}

- (void)createV
{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.frame = [UIApplication sharedApplication].keyWindow.frame;
    
    UIView *contentV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 169)];
    contentV.backgroundColor = [UIColor clearColor];
    [self addSubview:contentV];
    _contentV = contentV;
    
    UIView *shareV = [[UIView alloc] initWithFrame:CGRectMake(15, 0, self.frame.size.width - 30, 105)];
    shareV.backgroundColor = [UIColor whiteColor];
    shareV.layer.cornerRadius = 10.0;
    shareV.layer.masksToBounds = YES;
    [_contentV addSubview:shareV];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(60, 80);
    layout.minimumInteritemSpacing = 10;
    
    UICollectionView *myCollectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(shareV.frame) - 20, 85) collectionViewLayout:layout];
    myCollectionV.backgroundColor = [UIColor clearColor];
    myCollectionV.delegate = self;
    myCollectionV.dataSource = self;
    [myCollectionV registerClass:[ShareToCell class] forCellWithReuseIdentifier:kShareToCell];
    myCollectionV.showsHorizontalScrollIndicator = NO;
    [shareV addSubview:myCollectionV];
    _myCollectionV = myCollectionV;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15, CGRectGetHeight(contentV.frame) - 44 - 10, self.frame.size.width - 30, 44);
    btn.layer.cornerRadius = 10.0;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dismissV) forControlEvents:UIControlEventTouchUpInside];
    [_contentV addSubview:btn];
    
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    _contentV.alpha = 1.0f;
    
    CGRect frame = _contentV.frame;
    frame.origin.y = CGRectGetMaxY(self.frame);
    _contentV.frame = frame;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _contentV.frame;
        frame.origin.y = CGRectGetMaxY(self.frame) - CGRectGetHeight(_contentV.frame) - kSafeAreaBottomHeight;
        _contentV.frame = frame;
    }];
}

- (void)dismissV
{
    
    [UIView animateWithDuration:0.4 animations:^{
        _contentV.alpha = 0;
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _contentV.frame;
        frame.origin.y = CGRectGetMaxY(self.frame);
        _contentV.frame = frame;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self removeFromSuperview];
    });
}

- (void)shareTo:(UMSocialPlatformType)type
{
    [self dismissV];
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.shareTitle descr:self.shareContent thumImage:self.shareImg];
    
    shareObject.webpageUrl = self.shareUrl;
    messageObject.shareObject = shareObject;
    
    
    [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:nil completion:^(id result, NSError *error) {
        if (error)
        {
            [SVProgressHUD showErrorWithStatus:@"分享失败"];
        }
        else
        {
            [SVProgressHUD showSuccessWithStatus:@"分享成功"];
        }

    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissV];
}

#pragma mark -
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShareToCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kShareToCell forIndexPath:indexPath];
    [cell refreshCell:self.dataArr[indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UMSocialPlatformType type = [self.dataArr[indexPath.item] integerValue];
    if (type == UMSocialPlatformType_UserDefine_Report)
    {
        if (self.feebackBlock) {
            self.feebackBlock(UMSocialPlatformType_UserDefine_Report);
        }
        [self dismissV];
        return;
    }
    else if (type == UMSocialPlatformType_UserDefine_Shield)
    {
        if (self.feebackBlock) {
            self.feebackBlock(UMSocialPlatformType_UserDefine_Shield);
        }
        [self dismissV];
        return;
    }
    [self shareTo:type];
}

@end

@interface ShareToCell ()
{
    UIImageView *_imgV;
    UILabel *_nameLab;
}
@end

@implementation ShareToCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createCell];
    }
    return self;
}

- (void)createCell
{
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    imgV.layer.cornerRadius = 5.0;
    imgV.contentMode = UIViewContentModeCenter;
    imgV.layer.masksToBounds = YES;
    [self.contentView addSubview:imgV];
    _imgV = imgV;
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 60, 20)];
    nameLab.textColor = [UIColor grayColor];
    nameLab.font = [UIFont systemFontOfSize:11];
    nameLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:nameLab];
    _nameLab = nameLab;
}

- (void)refreshCell:(id)obj
{
    if ([obj isKindOfClass:[NSNumber class]]) {
        switch ([obj integerValue]) {
            case UMSocialPlatformType_WechatSession:
                _imgV.image = [UIImage imageNamed:@"share_weixin"];
                _nameLab.text = @"微信";
                break;
                
            case UMSocialPlatformType_WechatTimeLine:
                _imgV.image = [UIImage imageNamed:@"share_weixin_friends"];
                _nameLab.text = @"朋友圈";
                break;
                
            case UMSocialPlatformType_QQ:
                _imgV.image = [UIImage imageNamed:@"share_qq"];
                _nameLab.text = @"QQ";
                break;
                
            case UMSocialPlatformType_Qzone:
                _imgV.image = [UIImage imageNamed:@"share_qq_space"];
                _nameLab.text = @"QQ空间";
                break;
                
            case UMSocialPlatformType_UserDefine_Report:
                _imgV.image = [UIImage imageNamed:@"share_inform"];
                _nameLab.text = @"举报";
                break;
                
            case UMSocialPlatformType_UserDefine_Shield:
                _imgV.image = [UIImage imageNamed:@"share_shield"];
                _nameLab.text = @"拉黑";
                break;
                
            default:
                break;
        }
        return;
    }
    _imgV.backgroundColor = [UIColor redColor];
    _nameLab.text = @"新浪微博薄";
}

@end
