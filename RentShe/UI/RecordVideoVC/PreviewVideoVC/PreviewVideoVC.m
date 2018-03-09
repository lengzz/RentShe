//
//  PreviewVideoVC.m
//  RentShe
//
//  Created by Lzz on 2018/3/7.
//  Copyright © 2018年 Lengzz. All rights reserved.
//

#import "PreviewVideoVC.h"
#import "EditVideoVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "TXLiteAVSDK_UGC/TXVodPlayer.h"
#import "PublishVideoVC.h"

@interface PreviewVideoVC ()<TXVodPlayListener>
{
    UIView *                        _videoPreview;
    UIButton *                      _btnStartPreview;
    UILabel*                        _progressTipLabel;
    UISlider *                      _sdPreviewSlider;
    
    int                             _recordType;
    UIImage *                       _coverImage;
    BOOL                            _previewing;
    BOOL                            _startPlay;
    
    BOOL                            _navigationBarHidden;
    BOOL                            _statusBarHidden;
    BOOL                            _isFromRecord;
    
    NSString*                       _videoPath;
    TXVodPlayer*                    _voidPlayer;
    TX_Enum_Type_RenderMode         _renderMode;
}

@end

@implementation PreviewVideoVC

-(void)dealloc{
    [_voidPlayer removeVideoWidget];
    [_voidPlayer stopPlay];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithCoverImage:(UIImage *)coverImage
                         videoPath:(NSString*)videoPath
                        renderMode:(TX_Enum_Type_RenderMode)renderMode
                      isFromRecord:(BOOL)isFromRecord;
{
    if (self = [super init])
    {
        _coverImage = coverImage;
        _videoPath =  videoPath;
        _renderMode = renderMode;
        _isFromRecord = isFromRecord;
        _previewing   = NO;
        _startPlay    = NO;
        
        _voidPlayer = [[TXVodPlayer alloc] init];
        _voidPlayer.vodDelegate = self;
        _voidPlayer.config.playerType = PLAYER_AVPLAYER;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidEnterBackGround:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAudioSessionEvent:) name:AVAudioSessionInterruptionNotification object:nil];
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _navigationBarHidden = self.navigationController.navigationBar.hidden;
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    if (_previewing)
    {
        [self startVideoPreview:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = _navigationBarHidden;
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [self stopVideoPreview:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createView
{
    self.title = @"视频回放";
    self.navigationItem.hidesBackButton = YES;
    
    
    UIImageView * coverImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    coverImageView.backgroundColor = UIColor.blackColor;
    if(_renderMode == RENDER_MODE_FILL_EDGE){
        coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    }else{
        coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    coverImageView.image = _coverImage;
    [self.view addSubview:coverImageView];
    
    _videoPreview = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview: _videoPreview];
    
    _btnStartPreview = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 65)];
    _btnStartPreview.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [_btnStartPreview setImage:[UIImage imageNamed:@"startpreview"] forState:UIControlStateNormal];
    [_btnStartPreview setImage:[UIImage imageNamed:@"startpreview_press"] forState:UIControlStateSelected];
    [_btnStartPreview addTarget:self action:@selector(onBtnPreviewStartClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnStartPreview];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, kStatusBarHeight + 6, 32, 32);
    [backBtn setImage:[UIImage imageNamed:@"record_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton *btnDelete = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    btnDelete.center = CGPointMake(self.view.frame.size.width / 4, self.view.frame.size.height - 40 - 5);
    [btnDelete setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [btnDelete setImage:[UIImage imageNamed:@"delete_press"] forState:UIControlStateSelected];
    [btnDelete addTarget:self action:@selector(publishClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnDelete];
    
    if (_isFromRecord) {
        UIButton *btnEdit = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        btnEdit.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 40 - 5);
        [btnEdit setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
        [btnEdit setImage:[UIImage imageNamed:@"edit_press"] forState:UIControlStateSelected];
        [btnEdit addTarget:self action:@selector(onBtnDownEditClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnEdit];
    }
    
    UIButton *btnDownload = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    btnDownload.center = CGPointMake(self.view.frame.size.width * 3 / 4, self.view.frame.size.height - 40 - 5);
    [btnDownload setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
    [btnDownload setImage:[UIImage imageNamed:@"download_press"] forState:UIControlStateSelected];
    [btnDownload addTarget:self action:@selector(onBtnDownloadClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnDownload];
    
    _sdPreviewSlider = [[UISlider alloc] init];
    _sdPreviewSlider.frame = CGRectMake(0, 0, self.view.frame.size.width - 40, 60);
    _sdPreviewSlider.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 80);
    [_sdPreviewSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    [_sdPreviewSlider setMinimumTrackImage:[UIImage imageNamed:@"green"] forState:UIControlStateNormal];
    [_sdPreviewSlider setMaximumTrackImage:[UIImage imageNamed:@"gray"] forState:UIControlStateNormal];
    [_sdPreviewSlider addTarget:self action:@selector(onDragEnd:) forControlEvents:UIControlEventTouchUpInside];
    [_sdPreviewSlider addTarget:self action:@selector(onDragStart:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_sdPreviewSlider];
    
    _progressTipLabel = [UILabel new];
    _progressTipLabel.textAlignment = NSTextAlignmentRight;
    _progressTipLabel.textColor = UIColor.whiteColor;
    _progressTipLabel.font = [UIFont systemFontOfSize:10];
    _progressTipLabel.frame = CGRectMake(self.view.frame.size.width - 120, self.view.frame.size.height - 100, 100, 10);
    _progressTipLabel.text = @"00:00/00:00";
    [self.view addSubview:_progressTipLabel];
}

-(void)startVideoPreview:(BOOL) startPlay
{
    if(startPlay == YES){
        [_voidPlayer setupVideoWidget:_videoPreview insertIndex:0];
        [_voidPlayer startPlay:_videoPath];
        [_voidPlayer setRenderMode:_renderMode];
    }else{
        [_voidPlayer resume];
    }
    
}

-(void)stopVideoPreview:(BOOL) stopPlay
{
    
    if(stopPlay == YES)
        [_voidPlayer stopPlay];
    else
        [_voidPlayer pause];
    
}

- (void)onAppDidEnterBackGround:(UIApplication*)app
{
    [self stopVideoPreview:NO];
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onBtnPreviewStartClicked
{
    if (!_startPlay) {
        [self startVideoPreview:YES];
        _startPlay = YES;
    }
    _previewing = !_previewing;
    
    if (_previewing)
    {
        [self startVideoPreview:NO];
        [_btnStartPreview setImage:[UIImage imageNamed:@"pausepreview"] forState:UIControlStateNormal];
        [_btnStartPreview setImage:[UIImage imageNamed:@"pausepreview_press"] forState:UIControlStateSelected];
    }
    else
    {
        [self stopVideoPreview:NO];
        [_btnStartPreview setImage:[UIImage imageNamed:@"startpreview"] forState:UIControlStateNormal];
        [_btnStartPreview setImage:[UIImage imageNamed:@"startpreview_press"] forState:UIControlStateSelected];
    }
}

-(void)onBtnDownEditClicked
{
    EditVideoVC *vc = [[EditVideoVC alloc] init];
    [vc setVideoPath:_videoPath];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)onBtnDownloadClicked
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:_videoPath] completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error != nil) {
            NSLog(@"save video fail:%@", error);
        }
    }];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)publishClicked
{
    PublishVideoVC *vc = [[PublishVideoVC alloc] initWithCoverImage:_coverImage videoPath:_videoPath isAuth:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)onBtnShareClicked
{
    //    TCVideoPublishController *vc = [[TCVideoPublishController alloc] init:[TXUGCRecord shareInstance] recordType:_recordType RecordResult:_recordResult TCLiveInfo:_liveInfo];
    //    [self.navigationController pushViewController:vc animated:YES];
    
    //    TCVideoEditViewController *vc = [[TCVideoEditViewController alloc] init];
    //    [vc setVideoPath:_recordResult.videoPath];
    //    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onDragStart:(UISlider*)sender
{
    NSLog(@"onDragStart:%f", sender.value);
}

- (void)onDragEnd:(UISlider*)sender
{
    NSLog(@"onDragEnd:%f", sender.value);
    if (_sdPreviewSlider.maximumValue > 5.0) {
        [_voidPlayer seek:sender.value];
    }
}

- (void)onAppWillEnterForeground:(UIApplication*)app
{
    if (_previewing)
    {
        [self startVideoPreview:NO];
    }
}

- (void)onAudioSessionEvent:(NSNotification *)notification
{
    NSDictionary *info = notification.userInfo;
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    if (type == AVAudioSessionInterruptionTypeBegan) {
        if (_previewing) {
            [self onBtnPreviewStartClicked];
        }
    }
}

#pragma mark -
#pragma mark - TXLivePlayListener

-(void) onPlayEvent:(TXVodPlayer *)player event:(int)EvtID withParam:(NSDictionary*)param
{
    NSDictionary* dict = param;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (EvtID == PLAY_EVT_PLAY_PROGRESS) {
            float progress = [dict[EVT_PLAY_PROGRESS] floatValue];
            [_sdPreviewSlider setValue:progress];
            
            float duration = [dict[EVT_PLAY_DURATION] floatValue];
            if (duration > 0 && _sdPreviewSlider.maximumValue != duration) {
                _sdPreviewSlider.minimumValue = 0;
                _sdPreviewSlider.maximumValue = duration;
            }
            NSString* progressTips = [NSString stringWithFormat:@"%02d:%02d/%02d:%02d", (int)progress / 60, (int)progress % 60, (int)duration / 60, (int)duration % 60];
            _progressTipLabel.text = progressTips;
            return ;
        } else if(EvtID == PLAY_EVT_PLAY_END) {
            [_sdPreviewSlider setValue:0];
            //           [self stopVideoPreview:YES];
            //           [self startVideoPreview:YES];
            //           [_livePlayer startPlay:_videoPath type:PLAY_TYPE_LOCAL_VIDEO];
            [_voidPlayer resume];
            
            [_btnStartPreview setImage:[UIImage imageNamed:@"pausepreview"] forState:UIControlStateNormal];
            [_btnStartPreview setImage:[UIImage imageNamed:@"pausepreview_press"] forState:UIControlStateSelected];
            //[_livePlayer startPlay:_videoPath type:PLAY_TYPE_LOCAL_VIDEO];
            _progressTipLabel.text = @"00:00/00:00";
        }
    });
}

@end
