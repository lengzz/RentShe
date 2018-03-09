//
//  PublishVideoVC.m
//  RentShe
//
//  Created by Lzz on 2018/3/7.
//  Copyright © 2018年 Lengzz. All rights reserved.
//

#import "PublishVideoVC.h"
#import "TXLiteAVSDK_UGC/TXUGCPublish.h"

@interface PublishVideoVC ()<TXVideoPublishListener>
{
    UIImage *                       _coverImage;;
    BOOL                            _isAuth;
    NSString*                       _videoPath;
}
@end

@implementation PublishVideoVC

- (instancetype)initWithCoverImage:(UIImage *)coverImage
                         videoPath:(NSString*)videoPath
                            isAuth:(BOOL)isAuth
{
    if (self = [super init])
    {
        _coverImage = coverImage;
        _videoPath =  videoPath;
        _isAuth = isAuth;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    if (_isAuth)
    {
        [self requestKey];
    }
    else
    {
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)requestKey
{
    [SVProgressHUD showWithStatus:@"准备上传..."];
    
    NSDictionary *dic = @{@"type":@"status",
                          @"brief":@"So funny ~!!!"
                          };
    [NetAPIManager getShortVideoKey:dic callBack:^(BOOL success, id object) {
        if (success) {
            NSDictionary *dic = object[@"data"];
            NSString *key = dic[@"key"];
            if ([key isKindOfClass:[NSString class]] && key.length) {
                [self publishVideo:key];
            }
        }
    }];
}

- (void)publishVideo:(NSString *)key
{
    [SVProgressHUD setStatus:@"开始上传..."];
    TXPublishParam * param = [[TXPublishParam alloc] init];
    param.signature = key;
    param.videoPath = _videoPath;
    param.coverImage = _coverImage;
    
    TXUGCPublish *_ugcPublish = [[TXUGCPublish alloc] init];
    _ugcPublish.delegate = self;
    [_ugcPublish publishVideo:param];
}

#pragma mark -
#pragma mark - TXVideoPublishListener
-(void) onPublishProgress:(NSInteger)uploadBytes totalBytes: (NSInteger)totalBytes
{
    NSInteger progress = uploadBytes * 100 / totalBytes;
    [SVProgressHUD setStatus:[NSString stringWithFormat:@"上传 %ld%%",progress]];
}

-(void) onPublishComplete:(TXPublishResult*)result
{
    [SVProgressHUD dismiss];
    
    if (result.retCode == PUBLISH_RESULT_OK) {
        [SVProgressHUD showSuccessWithStatus:@"上传完成"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
        /*
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:result.videoURL forKey:@"video_addr"];
        [dic setValue:result.coverURL forKey:@"video_cover"];
        if (_isAuth)
        {
            
        }
        else
        {
            [dic setValue:@"So funny ~!!!" forKey:@"brief"];
            [NetAPIManager shortVideoStatus:dic callBack:^(BOOL success, id object) {
                if (success) {
                    [SVProgressHUD showSuccessWithStatus:@"上传完成"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    });
                }
            }];
        }
         */
    }
    
}
@end
