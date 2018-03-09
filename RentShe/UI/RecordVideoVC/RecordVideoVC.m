//
//  RecordVideoVC.m
//  RentShe
//
//  Created by Lzz on 2018/3/6.
//  Copyright © 2018年 Lengzz. All rights reserved.
//

#import "RecordVideoVC.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPMediaPickerController.h>
#import "TXLiteAVSDK_UGC/TXUGCRecord.h"
#import "BeautySettingPanel.h"
#import "VideoRecordProcessView.h"
#import "VideoRecordMusicView.h"

#import "PreviewVideoVC.h"

@interface RecordVideoVC ()<
TXUGCRecordListener,
BeautySettingPanelDelegate,
BeautyLoadPituDelegate,
TXVideoCustomProcessDelegate,
VideoRecordMusicViewDelegate
>
{
    BOOL                            _cameraFront;
    BOOL                            _lampOpened;
    
    int                             _beautyDepth;
    int                             _whitenDepth;
    
    BOOL                            _cameraPreviewing;
    BOOL                            _videoRecording;
    BOOL                            _isPaused;
    BOOL                            _isFlash;
    
    UIView *                        _mask_buttom;
    UIView *                        _videoRecordView;
    UIButton *                      _btnDelete;
    UIButton *                      _btnStartRecord;
    UIButton *                      _btnFlash;
    UIButton *                      _btnCamera;
    UIButton *                      _btnBeauty;
    UIButton *                      _btnMusic;
    UIButton *                      _btnLamp;
    UIButton *                      _btnDone;
    UILabel *                       _recordTimeLabel;
    CGFloat                         _currentRecordTime;
    
    BeautySettingPanel*             _vBeauty;
    
    BOOL                            _navigationBarHidden;
    BOOL                            _statusBarHidden;
    BOOL                            _appForeground;
    
    UIView*                         _tmplBar;
    
    UIDeviceOrientation             _deviceOrientation;
    AVAudioPlayer*                  _player;
    NSTimer*                        _timer;
    
    NSString*                       _BGMPath;
    CGFloat                         _BGMDuration;
    
    VideoRecordProcessView *        _progressView;
    VideoRecordMusicView *          _musicView;
    TXVideoAspectRatio              _aspectRatio;
    BOOL                            _isBackDelete;
    BOOL                            _bgmRecording;
    int                             _deleteCount;
    float                           _zoom;
    NSInteger                       _speedBtnSelectTag;
    
    CGFloat                         _bgmBeginTime;
    BOOL                            _receiveBGMProgress;
    
    SVProgressHUD*                  _hub;
}

@end

@implementation RecordVideoVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfig];
    
    [self initUI];
    [self initBeautyUI];
    self.view.backgroundColor = UIColor.blackColor;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _navigationBarHidden = self.navigationController.navigationBar.hidden;
    self.navigationController.navigationBar.hidden = YES;
    
    if (_cameraPreviewing == NO)
    {
        [self startCameraPreview];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = _navigationBarHidden;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint _touchPoint = [touch locationInView:self.view];
    if (!_vBeauty.hidden) {
        if (NO == CGRectContainsPoint(_vBeauty.frame, _touchPoint))
        {
            [self onBtnBeautyClicked];
        }
    }
    
    if (!_musicView.hidden) {
        if (NO == CGRectContainsPoint(_musicView.frame, _touchPoint))
        {
            [self onBtnMusicClicked];
        }
    }
}

#pragma mark -
#pragma mark - 初始化界面、配置
- (void)initConfig
{
    _cameraFront = YES;
    _lampOpened = NO;
    _cameraPreviewing = NO;
    _videoRecording = NO;
    _bgmRecording = NO;
    _receiveBGMProgress = YES;
    
    _beautyDepth = 6.3;
    _whitenDepth = 2.7;
    _zoom        = 1.0;
    _bgmBeginTime = 0;
    _currentRecordTime = 0;
    
    [TXUGCRecord shareInstance].recordDelegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidEnterBackGround:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onAudioSessionEvent:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChanged:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    _appForeground = YES;
}

-(void)initUI
{
    self.title = @"";
    _videoRecordView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_videoRecordView];
    
    UIPinchGestureRecognizer* pinchGensture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [_videoRecordView addGestureRecognizer:pinchGensture];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, kStatusBarHeight + 6, 32, 32);
    [backBtn setImage:[UIImage imageNamed:@"record_back"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"record_back_disable"] forState:UIControlStateDisabled];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    _btnBeauty = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnBeauty.frame = CGRectMake(kWindowWidth - 32 - 5, kStatusBarHeight + 6, 32, 32);
    [_btnBeauty setImage:[UIImage imageNamed:@"record_beauty"] forState:UIControlStateNormal];
    [_btnBeauty setImage:[UIImage imageNamed:@"record_beauty_hover"] forState:UIControlStateHighlighted];
    [_btnBeauty addTarget:self action:@selector(onBtnBeautyClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnBeauty];
    
    UILabel *beautyLabel = [[UILabel alloc] initWithFrame:CGRectMake(_btnBeauty.x, _btnBeauty.bottom + 10, 32, 11)];
    beautyLabel.text = @"美颜";
    beautyLabel.textColor = UIColor.whiteColor;
    beautyLabel.font = [UIFont systemFontOfSize:12];
    beautyLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:beautyLabel];
    
    _btnMusic = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnMusic.frame = CGRectOffset(_btnBeauty.frame, 0, 72);
    [_btnMusic setImage:[UIImage imageNamed:@"record_bgm"] forState:UIControlStateNormal];
    [_btnMusic setImage:[UIImage imageNamed:@"record_bgm_hover"] forState:UIControlStateHighlighted];
    [_btnMusic addTarget:self action:@selector(onBtnMusicClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnMusic];
    
    UILabel *musicLabel = [[UILabel alloc] initWithFrame:CGRectMake(_btnMusic.x, _btnMusic.bottom + 10, 32, 11)];
    musicLabel.text = @"音乐";
    musicLabel.textColor = UIColor.whiteColor;
    musicLabel.font = [UIFont systemFontOfSize:12];
    musicLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:musicLabel];
    
    _musicView = [[VideoRecordMusicView alloc] initWithFrame:CGRectMake(0, self.view.bottom - 175, self.view.width, 175)];
    _musicView.delegate = self;
    _musicView.hidden = YES;
    [self.view addSubview:_musicView];
    
    _mask_buttom = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 170, self.view.frame.size.width, 170)];
    [_mask_buttom setBackgroundColor:UIColor.blackColor];
    [_mask_buttom setAlpha:0.3];
    [self.view addSubview:_mask_buttom];
    
    _btnStartRecord = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
    _btnStartRecord.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 75 + 10);
    [_btnStartRecord setImage:[UIImage imageNamed:@"start_record"] forState:UIControlStateNormal];
    [_btnStartRecord setBackgroundImage:[UIImage imageNamed:@"start_ring"] forState:UIControlStateNormal];
    [_btnStartRecord addTarget:self action:@selector(onBtnRecordStartClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnStartRecord];
    
    _btnFlash = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnFlash.bounds = CGRectMake(0, 0, 32, 32);
    _btnFlash.center = CGPointMake(25 + 32 / 2, _btnStartRecord.center.y);
    if (_cameraFront) {
        [_btnFlash setImage:[UIImage imageNamed:@"record_openflash_disable"] forState:UIControlStateNormal];
        _btnFlash.enabled = NO;
    }else{
        [_btnFlash setImage:[UIImage imageNamed:@"record_closeflash"] forState:UIControlStateNormal];
        [_btnFlash setImage:[UIImage imageNamed:@"record_closeflash_hover"] forState:UIControlStateHighlighted];
        _btnFlash.enabled = YES;
    }
    [_btnFlash addTarget:self action:@selector(onBtnFlashClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnFlash];
    
    _btnCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnCamera.bounds = CGRectMake(0, 0, 32, 32);
    _btnCamera.center = CGPointMake(_btnFlash.right + 25 + 32 / 2, _btnStartRecord.center.y);
    //    _btnCamera.frame = CGRectOffset(_btnMusic.frame, 0, 72);
    [_btnCamera setImage:[UIImage imageNamed:@"record_camera"] forState:UIControlStateNormal];
    [_btnCamera setImage:[UIImage imageNamed:@"record_camera_hover"] forState:UIControlStateHighlighted];
    [_btnCamera addTarget:self action:@selector(onBtnCameraClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnCamera];
    
    _btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnDone.bounds = CGRectMake(0, 0, 32, 32);
    _btnDone.center = CGPointMake(CGRectGetWidth(self.view.bounds) - 25 - 32 / 2 , _btnStartRecord.center.y);
    [_btnDone setImage:[UIImage imageNamed:@"record_confirm_disable"] forState:UIControlStateNormal];
    [_btnDone setTitleColor:UIColor.brownColor forState:UIControlStateNormal];
    [_btnDone addTarget:self action:@selector(onBtnDoneClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnDone];
    _btnDone.enabled = NO;
    
    _btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnDelete.bounds = CGRectMake(0, 0, 32, 32);
    _btnDelete.center = CGPointMake(_btnDone.left - 25 - 32 / 2, _btnStartRecord.center.y);
    [_btnDelete setImage:[UIImage imageNamed:@"record_delete"] forState:UIControlStateNormal];
    [_btnDelete setImage:[UIImage imageNamed:@"record_delete_hover"] forState:UIControlStateHighlighted];
    [_btnDelete addTarget:self action:@selector(onBtnDeleteClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnDelete];
    
    _progressView = [[VideoRecordProcessView alloc] initWithFrame:CGRectMake(0,_mask_buttom.y - 3 + 0.5, self.view.frame.size.width, 3)];
    _progressView.backgroundColor = [UIColor blackColor];
    _progressView.alpha = 0.4;
    [self.view addSubview:_progressView];
    
    _recordTimeLabel = [[UILabel alloc]init];
    _recordTimeLabel.frame = CGRectMake(0, 0, 100, 100);
    [_recordTimeLabel setText:@"00:00"];
    _recordTimeLabel.font = [UIFont systemFontOfSize:10];
    _recordTimeLabel.textColor = [UIColor whiteColor];
    _recordTimeLabel.textAlignment = NSTextAlignmentLeft;
    [_recordTimeLabel sizeToFit];
    _recordTimeLabel.center = CGPointMake(CGRectGetMaxX(_progressView.frame) - _recordTimeLabel.frame.size.width / 2, _progressView.frame.origin.y - _recordTimeLabel.frame.size.height);
    [self.view addSubview:_recordTimeLabel];
}

- (void)handlePinch:(UIPinchGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
        [[TXUGCRecord shareInstance] setZoom:MIN(MAX(1.0, _zoom * recognizer.scale),5.0)];
    }else if (recognizer.state == UIGestureRecognizerStateEnded){
        _zoom = MIN(MAX(1.0, _zoom * recognizer.scale),5.0);
        recognizer.scale = 1;
    }
}

#pragma mark -
#pragma mark - 通知事件

-(void)onAudioSessionEvent:(NSNotification*)notification
{
    NSDictionary *info = notification.userInfo;
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    if (type == AVAudioSessionInterruptionTypeBegan) {
        // 在10.3及以上的系统上，分享跳其它app后再回来会收到AVAudioSessionInterruptionWasSuspendedKey的通知，不处理这个事件。
        if ([info objectForKey:@"AVAudioSessionInterruptionWasSuspendedKey"]) {
            
            
            return;
        }
        _appForeground = NO;
        if (!_isPaused && _videoRecording)
            [self onBtnRecordStartClicked];
        
    }else{
        AVAudioSessionInterruptionOptions options = [info[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
        if (options == AVAudioSessionInterruptionOptionShouldResume) {
            _appForeground = YES;
        }
    }
}

- (void)onAppDidEnterBackGround:(UIApplication*)app
{
    _appForeground = NO;
    if (!_isPaused && _videoRecording){
        [self onBtnRecordStartClicked];
    }
    
    if (!_vBeauty.hidden) {
        [self onBtnBeautyClicked];
    }
}

- (void)onAppWillEnterForeground:(UIApplication*)app
{
    _appForeground = YES;
    
}

- (void)onAppWillResignActive:(UIApplication*)app
{
    _appForeground = NO;
    if (!_isPaused && _videoRecording)
        [self onBtnRecordStartClicked];
    
    if (!_vBeauty.hidden) {
        [self onBtnBeautyClicked];
    }
    
}
- (void)onAppDidBecomeActive:(UIApplication*)app
{
    _appForeground = YES;
    
}

#pragma mark -
#pragma mark - 响应事件

- (void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onBtnMusicClicked
{
    _musicView.hidden = !_musicView.hidden;
    _vBeauty.hidden = YES;
    [self hideBottomView:!_musicView.hidden];
}

-(void)onBtnFlashClicked
{
    if (_isFlash) {
        [_btnFlash setImage:[UIImage imageNamed:@"record_closeflash"] forState:UIControlStateNormal];
        [_btnFlash setImage:[UIImage imageNamed:@"record_closeflash_hover"] forState:UIControlStateHighlighted];
    }else{
        [_btnFlash setImage:[UIImage imageNamed:@"record_openflash"] forState:UIControlStateNormal];
        [_btnFlash setImage:[UIImage imageNamed:@"record_openflash_hover"] forState:UIControlStateHighlighted];
    }
    _isFlash = !_isFlash;
    [[TXUGCRecord shareInstance] toggleTorch:_isFlash];
}

-(void)onBtnDeleteClicked
{
    if (_videoRecording && !_isPaused) {
        [self onBtnRecordStartClicked];
    }
    if (0 == _deleteCount) {
        [_progressView prepareDeletePart];
    }else{
        [_progressView comfirmDeletePart];
        [[TXUGCRecord shareInstance].partsManager deleteLastPart];
        _isBackDelete = YES;
        
        if ([TXUGCRecord shareInstance].partsManager.getVideoPathList.count ==0) {
            [[TXUGCRecord shareInstance] setRecordSpeed:VIDEO_RECORD_SPEED_NOMAL];
        }
    }
    if (2 == ++ _deleteCount) {
        _deleteCount = 0;
    }
}

-(void)onBtnRecordStartClicked
{
    if (!_videoRecording)
    {
        [self startVideoRecord];
    }
    else
    {
        if (_isPaused) {
            if (_bgmRecording) {
                [self resumeBGM];
            }else{
                [self playBGM:_bgmBeginTime];
                _bgmRecording = YES;
            }
            [[TXUGCRecord shareInstance] resumeRecord];
            
            [_btnStartRecord setImage:[UIImage imageNamed:@"record_pause"] forState:UIControlStateNormal];
            [_btnStartRecord setBackgroundImage:[UIImage imageNamed:@"pause_ring"] forState:UIControlStateNormal];
            _btnStartRecord.bounds = CGRectMake(0, 0, 75 * 0.85, 75 * 0.85);
            
            if (_deleteCount == 1) {
                [_progressView cancelDelete];
                _deleteCount = 0;
            }
            
            _isPaused = NO;
        }
        else {
            [[TXUGCRecord shareInstance] pauseRecord];
            [self pauseBGM];
            
            [_btnStartRecord setImage:[UIImage imageNamed:@"start_record"] forState:UIControlStateNormal];
            [_btnStartRecord setBackgroundImage:[UIImage imageNamed:@"record_start_ring"] forState:UIControlStateNormal];
            _btnStartRecord.bounds = CGRectMake(0, 0, 75, 75);
            
            [_progressView pause];
            
            _isPaused = YES;
        }
    }
}

- (void)onBtnDoneClicked
{
    if (!_videoRecording)
        return;
    
    [self stopVideoRecord];
}

-(void)startCameraPreview
{
    
    if (_cameraPreviewing == NO)
    {
        //简单设置
        //        TXUGCSimpleConfig * param = [[TXUGCSimpleConfig alloc] init];
        //        param.videoQuality = VIDEO_QUALITY_MEDIUM;
        //        [[TXUGCRecord shareInstance] startCameraSimple:param preview:_videoRecordView];
        //自定义设置
        TXUGCCustomConfig * param = [[TXUGCCustomConfig alloc] init];
        param.videoResolution =  VIDEO_RESOLUTION_540_960;
        param.videoFPS = 20;
        param.videoBitratePIN = 2000;
        param.GOP = 3;
        param.minDuration = 5;
        param.maxDuration = 30;
        [[TXUGCRecord shareInstance] startCameraCustom:param preview:_videoRecordView];
        [[TXUGCRecord shareInstance] setAspectRatio:_aspectRatio];
        [TXUGCRecord shareInstance].videoProcessDelegate = self;
        //[[TXUGCRecord shareInstance] setZoom:2.5];
        
        UIImage *watermark = [UIImage imageNamed:@"watermark.png"];
        CGRect watermarkFrame = (CGRect){0.01, 0.01, 0.3 , 0};
        [[TXUGCRecord shareInstance] setWaterMark:watermark normalizationFrame:watermarkFrame];
        [_vBeauty resetValues];
        
        _cameraPreviewing = YES;
    }
    
}

/* 各种情况下的横竖屏推流 参数设置
 //activity竖屏模式，竖屏推流
 [[TXUGCRecord shareInstance] setHomeOrientation:VIDEO_HOME_ORIENTATION_DOWN];
 [[TXUGCRecord shareInstance] setRenderRotation:0];
 
 //activity竖屏模式，home在右横屏推流
 [[TXUGCRecord shareInstance] setHomeOrientation:VIDOE_HOME_ORIENTATION_RIGHT];
 [[TXUGCRecord shareInstance] setRenderRotation:90];
 
 //activity竖屏模式，home在左横屏推流
 [[TXUGCRecord shareInstance] setHomeOrientation:VIDEO_HOME_ORIENTATION_LEFT];
 [[TXUGCRecord shareInstance] setRenderRotation:270];
 
 //activity横屏模式，home在右横屏推流 注意：渲染view要跟着activity旋转
 [[TXUGCRecord shareInstance] setHomeOrientation:VIDOE_HOME_ORIENTATION_RIGHT];
 [[TXUGCRecord shareInstance] setRenderRotation:0];
 
 //activity横屏模式，home在左横屏推流 注意：渲染view要跟着activity旋转
 [[TXUGCRecord shareInstance] setHomeOrientation:VIDEO_HOME_ORIENTATION_LEFT];
 [[TXUGCRecord shareInstance] setRenderRotation:0];
 */

- (void)statusBarOrientationChanged:(NSNotification *)note  {
    switch ([[UIDevice currentDevice] orientation]) {
        case UIDeviceOrientationPortrait:        //activity竖屏模式，竖屏录制
        {
            if (_deviceOrientation != UIDeviceOrientationPortrait) {
                
                [[TXUGCRecord shareInstance] setHomeOrientation:VIDEO_HOME_ORIENTATION_DOWN];
                [[TXUGCRecord shareInstance] setRenderRotation:0];
            }
        }
            break;
        case UIDeviceOrientationLandscapeLeft:   //activity横屏模式，home在右横屏录制 注意：渲染view要跟着activity旋转
        {
            if (_deviceOrientation != UIDeviceOrientationLandscapeLeft) {
                [[TXUGCRecord shareInstance] setHomeOrientation:VIDOE_HOME_ORIENTATION_RIGHT];
                [[TXUGCRecord shareInstance] setRenderRotation:0];
                //                [[TXUGCRecord shareInstance] startRecord];
            }
            
        }
            break;
        case UIDeviceOrientationLandscapeRight:   //activity横屏模式，home在左横屏录制 注意：渲染view要跟着activity旋转
        {
            if (_deviceOrientation != UIDeviceOrientationLandscapeRight) {
                
                [[TXUGCRecord shareInstance] setHomeOrientation:VIDEO_HOME_ORIENTATION_LEFT];
                [[TXUGCRecord shareInstance] setRenderRotation:0];
                //                [[TXUGCRecord shareInstance] startRecord];
            }
        }
            break;
        default:
            break;
    }
}


-(void)stopCameraPreview
{
    if (_cameraPreviewing == YES)
    {
        [[TXUGCRecord shareInstance] stopCameraPreview];
        [TXUGCRecord shareInstance].videoProcessDelegate = nil;
        _cameraPreviewing = NO;
    }
}

-(void)startVideoRecord
{
    [self refreshRecordTime:0];
    [self startCameraPreview];
    int result = [[TXUGCRecord shareInstance] startRecord];
    if(0 != result)
    {
        if(-3 == result) [self alert:@"启动录制失败" msg:@"请检查摄像头权限是否打开"];
        if(-4 == result) [self alert:@"启动录制失败" msg:@"请检查麦克风权限是否打开"];
    }else{
        [self playBGM:_bgmBeginTime];
        _bgmRecording = YES;
        _videoRecording = YES;
        _isPaused = NO;
        [_btnStartRecord setImage:[UIImage imageNamed:@"pause_record"] forState:UIControlStateNormal];
        [_btnStartRecord setBackgroundImage:[UIImage imageNamed:@"pause_ring"] forState:UIControlStateNormal];
        _btnStartRecord.bounds = CGRectMake(0, 0, 75 * 0.85, 75 * 0.85);
    }
}

-(void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)stopVideoRecord
{
    [[TXUGCRecord shareInstance] stopRecord];
    [self resetVideoUI];
}

-(void)resetVideoUI
{
    [_progressView deleteAllPart];
    [_btnStartRecord setImage:[UIImage imageNamed:@"start_record"] forState:UIControlStateNormal];
    [_btnStartRecord setBackgroundImage:[UIImage imageNamed:@"start_ring"] forState:UIControlStateNormal];
    _btnStartRecord.bounds = CGRectMake(0, 0, 75, 75);
    
    [_musicView resetUI];
    
    _btnMusic.enabled = YES;
    _isPaused = NO;
    _videoRecording = NO;
}

-(void)onBtnCameraClicked
{
    _cameraFront = !_cameraFront;
    [[TXUGCRecord shareInstance] switchCamera:_cameraFront];
    if (_cameraFront) {
        [_btnFlash setImage:[UIImage imageNamed:@"record_openflash_disable"] forState:UIControlStateNormal];
        _btnFlash.enabled = NO;
    }else{
        if (_isFlash) {
            [_btnFlash setImage:[UIImage imageNamed:@"record_openflash"] forState:UIControlStateNormal];
            [_btnFlash setImage:[UIImage imageNamed:@"record_openflash_hover"] forState:UIControlStateHighlighted];
        }else{
            [_btnFlash setImage:[UIImage imageNamed:@"record_closeflash"] forState:UIControlStateNormal];
            [_btnFlash setImage:[UIImage imageNamed:@"record_closeflash_hover"] forState:UIControlStateHighlighted];
        }
        _btnFlash.enabled = YES;
    }
    [[TXUGCRecord shareInstance] toggleTorch:_isFlash];
}

-(void)onBtnBeautyClicked
{
    _vBeauty.hidden = !_vBeauty.hidden;
    _musicView.hidden = YES;
    [self hideBottomView:!_vBeauty.hidden];
}

- (void)hideBottomView:(BOOL)bHide
{
    _btnFlash.hidden = bHide;
    _btnCamera.hidden = bHide;
    _btnStartRecord.hidden = bHide;
    _btnDelete.hidden = bHide;
    _btnDone.hidden = bHide;
    _progressView.hidden = bHide;
    _recordTimeLabel.hidden = bHide;
    _mask_buttom.hidden = bHide;
}

#pragma mark -
#pragma mark - VideoRecordMusicViewDelegate
-(void)onBtnMusicSelected
{
    MPMediaPickerController *mpc = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
    mpc.delegate = self;
    mpc.editing = YES;
    mpc.allowsPickingMultipleItems = NO;
    [self presentViewController:mpc animated:YES completion:nil];
    [self onBtnMusicClicked];
}

-(void)onBtnMusicStoped
{
    _BGMPath = nil;
    _bgmRecording = NO;
    [[TXUGCRecord shareInstance] stopBGM];
    if (!_musicView.hidden) {
        [self onBtnMusicClicked];
    }
}

-(void)onBGMValueChange:(UISlider *)slider
{
    [[TXUGCRecord shareInstance] setBGMVolume:slider.value];
}

-(void)onVoiceValueChange:(UISlider *)slider
{
    [[TXUGCRecord shareInstance] setMicVolume:slider.value];
}

-(void)onBGMPlayBeginChange
{
    _receiveBGMProgress = NO;
}

-(void)onBGMPlayChange:(UISlider *)slider
{
    [self playBGM:slider.value];
    _receiveBGMProgress = YES;
}

#pragma mark - MPMediaPickerControllerDelegate
- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
//    _hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    _hub.label.text = @"音频读取中...";
    [SVProgressHUD showWithStatus:@"音频读取中..."];
    
    NSArray *items = mediaItemCollection.items;
    MPMediaItem *songItem = [items objectAtIndex:0];
    
    NSURL *url = [songItem valueForProperty:MPMediaItemPropertyAssetURL];
    NSString* songName = [songItem valueForProperty: MPMediaItemPropertyTitle];
    NSString* authorName = [songItem valueForProperty:MPMediaItemPropertyArtist];
    NSNumber* duration = [songItem valueForKey:MPMediaItemPropertyPlaybackDuration];
    NSLog(@"MPMediaItemPropertyAssetURL = %@", url);
    
    RecordMusicInfo* musicInfo = [RecordMusicInfo new];
    musicInfo.duration = duration.floatValue;
    musicInfo.soneName = songName;
    musicInfo.singerName = authorName;
    
    if (mediaPicker.editing) {
        mediaPicker.editing = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self saveAssetURLToFile:musicInfo assetURL:url];
        });
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

//点击取消时回调
- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 将AssetURL(音乐)导出到app的文件夹并播放
- (void)saveAssetURLToFile:(RecordMusicInfo*)musicInfo assetURL:(NSURL*)assetURL
{
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:songAsset presetName:AVAssetExportPresetAppleM4A];
    NSLog (@"created exporter. supportedFileTypes: %@", exporter.supportedFileTypes);
    exporter.outputFileType = @"com.apple.m4a-audio";
    
    [AVAssetExportSession exportPresetsCompatibleWithAsset:songAsset];
    NSString *docDir = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"LocalMusics/"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:docDir]) {
        [fileManager createDirectoryAtPath:docDir withIntermediateDirectories:NO attributes:nil error:nil];
    }
    //    NSString *exportFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.m4a", musicInfo.soneName, musicInfo.singerName]];
    NSString *exportFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.m4a", musicInfo.soneName, musicInfo.singerName]];
    
    exporter.outputURL = [NSURL fileURLWithPath:exportFilePath];
    musicInfo.filePath = exportFilePath;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:exportFilePath]) {
        [self onSetBGM:musicInfo.filePath];
        return;
    }
    
    
    // do the export
    __weak __typeof(self) weakSelf = self;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        int exportStatus = exporter.status;
        switch (exportStatus) {
            case AVAssetExportSessionStatusFailed: {
                NSLog (@"AVAssetExportSessionStatusFailed: %@", exporter.error);
                break;
                
            }
            case AVAssetExportSessionStatusCompleted: {
                NSLog(@"AVAssetExportSessionStatusCompleted: %@", exporter.outputURL);
                
                // 播放背景音乐
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf onSetBGM:musicInfo.filePath];
                });
                break;
            }
            case AVAssetExportSessionStatusUnknown: { NSLog (@"AVAssetExportSessionStatusUnknown"); break;}
            case AVAssetExportSessionStatusExporting: { NSLog (@"AVAssetExportSessionStatusExporting"); break;}
            case AVAssetExportSessionStatusCancelled: { NSLog (@"AVAssetExportSessionStatusCancelled"); break;}
            case AVAssetExportSessionStatusWaiting: { NSLog (@"AVAssetExportSessionStatusWaiting"); break;}
            default: { NSLog (@"didn't get export status"); break;}
        }
    }];
}

-(void)onSetBGM:(NSString *)path
{
    //[MBProgressHUD hideHUDForView:self.view animated:YES];
    [SVProgressHUD dismiss];
    
    _BGMPath = path;
    _BGMDuration =  [[TXUGCRecord shareInstance] setBGM:_BGMPath];
    [_musicView setBGMDuration:_BGMDuration];
    
    //试听音乐这里要把RecordSpeed 设置为VIDEO_RECORD_SPEED_NOMAL，否则音乐可能会出现加速或则慢速播现象
    [[TXUGCRecord shareInstance] setRecordSpeed:VIDEO_RECORD_SPEED_NOMAL];
    
    _bgmRecording = NO;
    [self playBGM:0];
}

-(void)playBGM:(CGFloat)beginTime{
    if (_BGMPath != nil) {
        [[TXUGCRecord shareInstance] playBGMFromTime:beginTime toTime:_BGMDuration withBeginNotify:^(NSInteger errCode) {
            
        } withProgressNotify:^(NSInteger progressMS, NSInteger durationMS) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_receiveBGMProgress) {
                    [_musicView setBGMPlayTime:progressMS / 1000.0];
                }
            });
        } andCompleteNotify:^(NSInteger errCode) {
            
        }];
        _bgmBeginTime = beginTime;
    }
}

-(void)pauseBGM{
    if (_BGMPath != nil) {
        [[TXUGCRecord shareInstance] pauseBGM];
    }
}

- (void)resumeBGM
{
    if (_BGMPath != nil) {
        [[TXUGCRecord shareInstance] resumeBGM];
    }
}

#pragma mark -
#pragma mark - BeautyLoadPituDelegate
- (void)onLoadPituStart
{
    dispatch_async(dispatch_get_main_queue(), ^{
//        _hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        _hub.mode = MBProgressHUDModeText;
//        _hub.label.text = @"开始加载资源";
        [SVProgressHUD showWithStatus:@"开始加载资源"];
    });
}
- (void)onLoadPituProgress:(CGFloat)progress
{
    dispatch_async(dispatch_get_main_queue(), ^{
//        _hub.label.text = [NSString stringWithFormat:@"正在加载资源%d %%",(int)(progress * 100)];
        [SVProgressHUD setStatus:[NSString stringWithFormat:@"正在加载资源%d %%",(int)(progress * 100)]];
    });
}
- (void)onLoadPituFinished
{
    dispatch_async(dispatch_get_main_queue(), ^{
//        _hub.label.text = @"资源加载成功";
//        [_hub hideAnimated:YES afterDelay:1];
        [SVProgressHUD setStatus:@"资源加载成功"];
        [SVProgressHUD dismiss];
    });
}
- (void)onLoadPituFailed
{
    dispatch_async(dispatch_get_main_queue(), ^{
//        _hub.label.text = @"资源加载失败";
//        [_hub hideAnimated:YES afterDelay:1];
        [SVProgressHUD setStatus:@"资源加载失败"];
        [SVProgressHUD dismiss];
    });
}

#pragma mark -
#pragma mark - BeautySettingPanelDelegate
- (void)onSetBeautyStyle:(int)beautyStyle beautyLevel:(float)beautyLevel whitenessLevel:(float)whitenessLevel ruddinessLevel:(float)ruddinessLevel{
    [[TXUGCRecord shareInstance] setBeautyStyle:beautyStyle beautyLevel:beautyLevel whitenessLevel:whitenessLevel ruddinessLevel:ruddinessLevel];
}

- (void)onSetEyeScaleLevel:(float)eyeScaleLevel
{
    [[TXUGCRecord shareInstance] setEyeScaleLevel:eyeScaleLevel];
}

- (void)onSetFaceScaleLevel:(float)faceScaleLevel
{
    [[TXUGCRecord shareInstance] setFaceScaleLevel:faceScaleLevel];
}

- (void)onSetFilter:(UIImage*)filterImage
{
    [[TXUGCRecord shareInstance] setFilter:filterImage];
}

- (void)onSetGreenScreenFile:(NSURL *)file
{
    [[TXUGCRecord shareInstance] setGreenScreenFile:file];
}

- (void)onSelectMotionTmpl:(NSString *)tmplName inDir:(NSString *)tmplDir
{
    [[TXUGCRecord shareInstance] selectMotionTmpl:tmplName inDir:tmplDir];
}

- (void)onSetFaceVLevel:(float)faceVLevel{
    [[TXUGCRecord shareInstance] setFaceVLevel:faceVLevel];
}

- (void)onSetChinLevel:(float)chinLevel{
    [[TXUGCRecord shareInstance] setChinLevel:chinLevel];
}

- (void)onSetNoseSlimLevel:(float)slimLevel{
    [[TXUGCRecord shareInstance] setNoseSlimLevel:slimLevel];
}

- (void)onSetFaceShortLevel:(float)faceShortlevel{
    [[TXUGCRecord shareInstance] setFaceShortLevel:faceShortlevel];
}

- (void)onSetMixLevel:(float)mixLevel{
    [[TXUGCRecord shareInstance] setSpecialRatio:mixLevel / 10.0];
}

#pragma mark -
#pragma mark ---- Video Beauty UI ----
-(void)initBeautyUI
{
    NSUInteger controlHeight = [BeautySettingPanel getHeight];
    _vBeauty = [[BeautySettingPanel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - controlHeight, self.view.frame.size.width, controlHeight)];
    _vBeauty.hidden = YES;
    _vBeauty.delegate = self;
    _vBeauty.pituDelegate = self;
    [self.view addSubview:_vBeauty];
}

-(void)refreshRecordTime:(float)second
{
    _currentRecordTime = second;
    [_progressView update:_currentRecordTime / 30];
    NSInteger min = (int)_currentRecordTime / 60;
    NSInteger sec = (int)_currentRecordTime % 60;
    
    [_recordTimeLabel setText:[NSString stringWithFormat:@"%02ld:%02ld", (long)min, sec]];
    [_recordTimeLabel sizeToFit];
}

#pragma mark -
#pragma mark ---- VideoRecordListener ----
-(void) onRecordProgress:(NSInteger)milliSecond;
{
    [self refreshRecordTime: milliSecond / 1000.0];
    
    if (milliSecond / 1000 >= 5) {
        [_btnDone setImage:[UIImage imageNamed:@"record_confirm"] forState:UIControlStateNormal];
        [_btnDone setImage:[UIImage imageNamed:@"record_confirm_hover"] forState:UIControlStateHighlighted];
        _btnDone.enabled = YES;
    }else{
        [_btnDone setImage:[UIImage imageNamed:@"record_confirm_disable"] forState:UIControlStateNormal];
        _btnDone.enabled = NO;
    }
    if(0 == milliSecond / 1000.0){
        _btnMusic.enabled = YES;
    }else{
        _btnMusic.enabled = NO;
    }
    
    //    if (milliSecond / 1000 > 10) {
    //        [[TXUGCRecord shareInstance] stopRecord];
    //    }
}

-(void) onRecordComplete:(TXUGCRecordResult*)result;
{
    if (_appForeground)
    {
        if (result.retCode == UGC_RECORD_RESULT_OK) {
            //            VideoEditViewController *vc = [[VideoEditViewController alloc] init];
            //            [vc setVideoPath:result.videoPath];
            PreviewVideoVC* vc = [[PreviewVideoVC alloc]
                                              initWithCoverImage:result.coverImage
                                              videoPath:result.videoPath
                                              renderMode:_aspectRatio == VIDEO_ASPECT_RATIO_9_16 ? RENDER_MODE_FILL_SCREEN : RENDER_MODE_FILL_EDGE
                                              isFromRecord:YES];
            [self.navigationController pushViewController:vc animated:YES];
            [self stopCameraPreview];
        }
        else if(result.retCode == UGC_RECORD_RESULT_OK_BEYOND_MAXDURATION){
            //            VideoEditViewController *vc = [[VideoEditViewController alloc] init];
            //            [vc setVideoPath:result.videoPath];
            PreviewVideoVC* vc = [[PreviewVideoVC alloc]
                                  initWithCoverImage:result.coverImage
                                  videoPath:result.videoPath
                                  renderMode:_aspectRatio == VIDEO_ASPECT_RATIO_9_16 ? RENDER_MODE_FILL_SCREEN : RENDER_MODE_FILL_EDGE
                                  isFromRecord:YES];
            [self.navigationController pushViewController:vc animated:YES];
            [self stopCameraPreview];
            [self resetVideoUI];
        }
        else if(result.retCode == UGC_RECORD_RESULT_OK_INTERRUPT){
            [self toastTip:@"录制被打断"];
        }
        else if(result.retCode == UGC_RECORD_RESULT_OK_UNREACH_MINDURATION){
            [self toastTip:@"至少要录够5秒"];
        }
        else if(result.retCode == UGC_RECORD_RESULT_FAILED){
            [self toastTip:@"视频录制失败"];
        }
    }
    [[TXUGCRecord shareInstance].partsManager deleteAllParts];
    [self refreshRecordTime:0];
}

#pragma mark -
#pragma mark - Misc Methods

- (float) heightForString:(UITextView *)textView andWidth:(float)width{
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}

- (void) toastTip:(NSString*)toastInfo
{
    CGRect frameRC = [[UIScreen mainScreen] bounds];
    frameRC.origin.y = frameRC.size.height - 100;
    frameRC.size.height -= 100;
    __block UITextView * toastView = [[UITextView alloc] init];
    
    toastView.editable = NO;
    toastView.selectable = NO;
    
    frameRC.size.height = [self heightForString:toastView andWidth:frameRC.size.width];
    
    toastView.frame = frameRC;
    
    toastView.text = toastInfo;
    toastView.backgroundColor = [UIColor whiteColor];
    toastView.alpha = 0.5;
    
    [self.view addSubview:toastView];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(){
        [toastView removeFromSuperview];
        toastView = nil;
    });
}

#pragma mark -
#pragma mark - TXVideoCustomProcessDelegate
- (GLuint)onPreProcessTexture:(GLuint)texture width:(CGFloat)width height:(CGFloat)height
{
    static int i = 0;
    if (i++ % 100 == 0) {
        NSLog(@"onPreProcessTexture width:%f height:%f", width, height);
    }
    
    return texture;
}

@end

@implementation RecordMusicInfo

@end
