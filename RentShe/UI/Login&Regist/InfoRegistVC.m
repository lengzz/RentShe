//
//  InfoRegistVC.m
//  RentShe
//
//  Created by Lengzz on 17/5/23.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "InfoRegistVC.h"

typedef NS_ENUM(NSInteger,GenderType) {
    GenderTypeMale = 1,
    GenderTypeFemale
};

@interface InfoRegistVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{
    UIImageView *_headImg;
    UIImageView *_nickImg;
    UIImageView *_pswImg;
    UIButton *_finishBtn;
    UIButton *_currentBtn;
    
    NSString *_avatarUrl;
}
@property (nonatomic, strong) UITextField *nicknameTF;
@property (nonatomic, strong) UITextField *pswTF;
@end

@implementation InfoRegistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
}

- (void)createView
{
    self.view.backgroundColor = kRGB_Value(0xfde23d);
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 22, 40, 40);
    [backBtn setImage:[UIImage imageNamed:@"setting_back"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(kWindowWidth/2.0 - 30, 64 + 23, 60, 60)];
    headImg.image = [UIImage imageNamed:@"head_default"];
    headImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addHeadImg)];
    [headImg addGestureRecognizer:tap];
    _headImg = headImg;
    [self.view addSubview:headImg];
    //男
    UIButton *maleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    maleBtn.frame = CGRectMake(kWindowWidth/2.0 - 30 - 15 - 20, kWindowHeight/2.0 - 89 - 25 - 40, 30, 30);
    maleBtn.tag = GenderTypeMale;
    [maleBtn setImageEdgeInsets:UIEdgeInsetsMake(8.5, 8.5, 8.5, 8.5)];
    [maleBtn setImage:[UIImage imageNamed:@"regist_gender"] forState:UIControlStateNormal];
    [maleBtn setImage:[UIImage imageNamed:@"regist_gender_selected"] forState:UIControlStateSelected];
    [maleBtn addTarget:self action:@selector(genderClick:) forControlEvents:UIControlEventTouchUpInside];
    _currentBtn = maleBtn;
    maleBtn.selected = YES;
    [self.view addSubview:maleBtn];
    UILabel *maleLab = [[UILabel alloc] initWithFrame:CGRectMake(kWindowWidth/2.0 - 15 - 20, kWindowHeight/2.0 - 89 - 25 - 40, 15, 30)];
    maleLab.font = [UIFont systemFontOfSize:13];
    maleLab.textColor = kRGB_Value(0x656565);
    maleLab.textAlignment = NSTextAlignmentRight;
    maleLab.text = @"男";
    [self.view addSubview:maleLab];
    //女
    UIButton *femaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    femaleBtn.frame = CGRectMake(kWindowWidth/2.0 + 20, kWindowHeight/2.0 - 89 - 25 - 40, 30, 30);
    femaleBtn.tag = GenderTypeFemale;
    [femaleBtn setImageEdgeInsets:UIEdgeInsetsMake(8.5, 8.5, 8.5, 8.5)];
    [femaleBtn setImage:[UIImage imageNamed:@"regist_gender"] forState:UIControlStateNormal];
    [femaleBtn setImage:[UIImage imageNamed:@"regist_gender_selected"] forState:UIControlStateSelected];
    [femaleBtn addTarget:self action:@selector(genderClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:femaleBtn];
    UILabel *femaleLab = [[UILabel alloc] initWithFrame:CGRectMake(kWindowWidth/2.0 + 30 + 20, kWindowHeight/2.0 - 89 - 25 - 40, 15, 30)];
    femaleLab.font = [UIFont systemFontOfSize:13];
    femaleLab.textColor = kRGB_Value(0x656565);
    femaleLab.textAlignment = NSTextAlignmentRight;
    femaleLab.text = @"女";
    [self.view addSubview:femaleLab];
    
    //昵称 密码
    UIView *infoV = [[UIView alloc] initWithFrame:CGRectMake(kWindowWidth/2.0 - 114, kWindowHeight/2.0 - 89 - 25, 228, 89)];
    infoV.backgroundColor = [UIColor whiteColor];
    infoV.layer.masksToBounds = YES;
    infoV.layer.cornerRadius = 5.0;
    [self.view addSubview:infoV];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, 228, .5)];
    line.backgroundColor = kRGB_Value(0xc3c3c3);
    [infoV addSubview:line];
    
    UIImageView *nickImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 20, 20)];
    nickImg.image = [UIImage imageNamed:@"regist_nick"];
    [infoV addSubview:nickImg];
    _nickImg = nickImg;
    UITextField *nicknameTF = [[UITextField alloc] initWithFrame:CGRectMake(20 + 30, 12, 228 - 30 - 20 - 20, 20)];
    nicknameTF.placeholder = @"请输入您的昵称";
    nicknameTF.font = [UIFont systemFontOfSize:13];
    nicknameTF.delegate = self;
    self.nicknameTF = nicknameTF;
    [infoV addSubview:nicknameTF];
    
    UIImageView *pswImg = [[UIImageView alloc] initWithFrame:CGRectMake(15,44 + 12, 20, 20)];
    pswImg.image = [UIImage imageNamed:@"login_psw"];
    [infoV addSubview:pswImg];
    _pswImg = pswImg;
    UITextField *pswTF = [[UITextField alloc] initWithFrame:CGRectMake(20 + 30, 44 + 12, 228 - 30 - 20 - 20, 20)];
    pswTF.placeholder = @"8-30位数字或英文";
    pswTF.font = [UIFont systemFontOfSize:13];
    pswTF.delegate = self;
    self.pswTF = pswTF;
    [infoV addSubview:pswTF];
    
    UILabel *tipsLab = [[UILabel alloc] initWithFrame:CGRectMake(kWindowWidth/2.0 - 114 + 20, kWindowHeight/2.0 - 25, 200, 25)];
    tipsLab.font = [UIFont systemFontOfSize:10];
    tipsLab.textColor = kRGB_Value(0xff0000);
    tipsLab.text = @"＊ 性别一旦确认将不可更改";
    [self.view addSubview:tipsLab];
    
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.frame = CGRectMake(kWindowWidth/2.0 - 114, kWindowHeight/2.0, 228, 44);
    finishBtn.layer.masksToBounds = YES;
    finishBtn.layer.cornerRadius = 5.0;
    finishBtn.backgroundColor = kRGB_Value(0x442509);
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    _finishBtn = finishBtn;
    [self.view addSubview:finishBtn];
    [finishBtn addTarget:self action:@selector(finishClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addHeadImg
{
    UIImagePickerController *imgCtl = [[UIImagePickerController alloc] init];
    imgCtl.delegate = self;
    imgCtl.allowsEditing = YES;
    UIAlertController *ctl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imgCtl.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imgCtl animated:YES completion:nil];
    }];
    UIAlertAction *photoAlbum = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imgCtl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imgCtl animated:YES completion:nil];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [ctl addAction:takePhoto];
    [ctl addAction:photoAlbum];
    [ctl addAction:cancel];
    [self presentViewController:ctl animated:YES completion:nil];
}

- (void)finishClick:(UIButton *)btn
{
    if (!self.nicknameTF.text.length || !self.pswTF.text.length) {
        return;
    }
    NSDictionary *dic = @{@"nickname":self.nicknameTF.text,
                          @"password":SHA1Str(MD5Str(self.pswTF.text)),
                          @"mobile":self.phoneNum,
                          @"gender":@(_currentBtn.tag - 1),
                          @"avatar":_avatarUrl ? _avatarUrl : @"",
                          @"identification":MD5Str([NSString stringWithFormat:@"mobile%@",self.phoneNum])};
    [NetAPIManager regist:dic callBack:^(BOOL success, id object) {
        if (success)
        {
            NSLog(@"%@",object);
            [UserDefaultsManager login:object[@"data"]];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            NSLog(@"%@",@"AAAAA");
        }
    }];
}

- (void)genderClick:(UIButton *)btn
{
    if ([_currentBtn isEqual:btn])
    {
        return;
    }
    _currentBtn.selected = NO;
    btn.selected = YES;
    _currentBtn = btn;
}

#pragma mark -
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:_nicknameTF])
    {
        [_nickImg setImage:[UIImage imageNamed:@"regist_nick_selected"]];
    }
    else if ([textField isEqual:_pswTF])
    {
        [_pswImg setImage:[UIImage imageNamed:@"login_psw_selected"]];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:_nicknameTF])
    {
        [_nickImg setImage:[UIImage imageNamed:@"regist_nick"]];
    }
    else if ([textField isEqual:_pswTF])
    {
        [_pswImg setImage:[UIImage imageNamed:@"login_psw"]];
    }
}

#pragma mark -
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [NetAPIManager uploadImg:image withParams:nil callBack:^(BOOL success, id object) {
        if (success) {
            NSDictionary *dic = object[@"data"];
            NSString *imgUrl = dic[@"url"];
            _avatarUrl = imgUrl;
            [_headImg sd_setImageWithUrlStr:imgUrl];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
