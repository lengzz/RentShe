//
//  EditInfoVC.m
//  RentShe
//
//  Created by Lengzz on 2017/9/20.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "EditInfoVC.h"
#import "EditInfoHeader.h"
#import "CustomPickV.h"
#import "NearbyM.h"

#define kCellIdentifier @"editInfoCell"

typedef NS_ENUM(NSInteger, PickType)
{
    PickTypeOfAge = 1,
    PickTypeOfHeight,
    PickTypeOfWeight
};

@interface EditInfoVC ()<UITableViewDelegate,UITableViewDataSource,EditInfoHeaderDataSource,EditInfoHeaderDelegate,CustomPickVDelegate,CustomPickVDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    PickType _type;
    NSString *_name;
    NSString *_birthday;
    NSString *_height;
    NSString *_weight;
    NSString *_profession;
    NSString *_avatar;
    NSString *_introduction;
    
    //选择图片类型：1 头部，2 头像
    NSInteger _imgType;
}
@property (nonatomic, strong) UITableView *myTabV;
@property (nonatomic, strong) EditInfoHeader *myHeader;
@property (nonatomic, strong) CustomPickV *pickV;

@property (nonatomic, strong) NSMutableArray *photoArr;

@property (nonatomic, strong) NSArray *yearsArr;
@property (nonatomic, strong) NSArray *monthsArr;
@property (nonatomic, strong) NSArray *heightArr;
@property (nonatomic, strong) NSArray *weightArr;
@end

@implementation EditInfoVC

- (NSMutableArray *)photoArr
{
    if (!_photoArr) {
        _photoArr = [NSMutableArray array];
    }
    return _photoArr;
}

- (NSArray *)yearsArr
{
    if (!_yearsArr) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSInteger i = 1980; i <= 2010; i++) {
            [arr addObject:[NSString stringWithFormat:@"%ld",(long)i]];
        }
        _yearsArr = [arr copy];
    }
    return _yearsArr;
}

- (NSArray *)monthsArr
{
    if (!_monthsArr) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSInteger i = 1; i <= 12; i++) {
            [arr addObject:[NSString stringWithFormat:@"%ld",(long)i]];
        }
        _monthsArr = [arr copy];
    }
    return _monthsArr;
}

- (NSArray *)heightArr
{
    if (!_heightArr) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSInteger i = 150; i <= 220; i++) {
            [arr addObject:[NSString stringWithFormat:@"%ld",(long)i]];
        }
        _heightArr = [arr copy];
    }
    return _heightArr;
}

- (NSArray *)weightArr
{
    if (!_weightArr) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSInteger i = 35; i <= 100; i++) {
            [arr addObject:[NSString stringWithFormat:@"%ld",(long)i]];
        }
        _weightArr = [arr copy];
    }
    return _weightArr;
}

- (CustomPickV *)pickV
{
    if (!_pickV) {
        _pickV = [[CustomPickV alloc] init];
        _pickV.delegate = self;
        _pickV.dataSource = self;
    }
    return _pickV;
}

- (EditInfoHeader *)myHeader
{
    if (!_myHeader) {
        _myHeader = [[EditInfoHeader alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowWidth + 20)];
        _myHeader.delegate = self;
        _myHeader.dataSource = self;
        _myHeader.imgNum = 4;
    }
    return _myHeader;
}

- (UITableView *)myTabV
{
    if (!_myTabV) {
        _myTabV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight) style:UITableViewStyleGrouped];
        _myTabV.backgroundColor = kRGB(242, 242, 242);
        _myTabV.delegate = self;
        _myTabV.dataSource = self;
        _myTabV.tableHeaderView = self.myHeader;
        _myTabV.rowHeight = 44;
        [self.view addSubview:_myTabV];
    }
    return _myTabV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavbar];
    
    [self myTabV];
//    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setCustomBarBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.shadowImage = nil;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)setInfoM:(NearbyM *)infoM
{
    _infoM = infoM;
    _name = infoM.user_info.nickname;
    _birthday = infoM.user_info.birthday;
    _weight = infoM.user_info.weight;
    _height = infoM.user_info.height;
    _profession = infoM.user_info.vocation;
    _avatar = infoM.user_info.avatar;
    _introduction = infoM.user_info.introduction;
    
    [self.myTabV reloadData];
    
    NSArray *arr = [infoM.user_info.photo componentsSeparatedByString:@","];
    if (arr.count) {
        for (NSString *str in arr) {
            if (str.length) {
                [self.photoArr addObject:str];
            }
        }
        [self.myHeader updateHeader];
    }
}

- (void)createNavbar
{
    [self.navigationItem setTitleView:[CustomNavVC setNavgationItemTitle:@"个人资料"]];
    
    [self.navigationItem setLeftBarButtonItem:[CustomNavVC getLeftBarButtonItemWithTarget:self action:@selector(backClick) normalImg:[UIImage imageNamed:@"setting_back"] hilightImg:[UIImage imageNamed:@"setting_back"]]];
    UIButton *btn = [CustomNavVC getRightDefaultButtonWithTarget:self action:@selector(completed) titile:@"完成"];
    [btn setTitleColor:kRGB(255, 117, 26) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:btn]];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)completed
{
    NSString *photoStr = [self.photoArr componentsJoinedByString:@","];
    NSDictionary *dic = @{@"nickname":_name,
                          @"birthday":_birthday,
                          @"height":_height,
                          @"weight":_weight,
                          @"vocation":_profession,
                          @"photo":photoStr,
                          @"introduction":_introduction,
                          @"avatar":_avatar};
    [NetAPIManager setUserInfo:dic callBack:^(BOOL success, id object) {
        if (success) {
            [UserDefaultsManager updateUserInfo];
            if (self.isChange)
            {
                self.isChange();
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoIsChange object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)editNickName:(UITextField *)tf
{
    if (tf.text.length) {
        if (tf.tag == 1)
        {
            _name = tf.text;
        }
        else if(tf.tag == 2)
        {
            _profession = tf.text;
        }
        else if (tf.tag == 3)
        {
            _introduction = tf.text;
        }
    }
}

- (void)popImgChoose
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

- (void)popDeletePhoto:(NSInteger)index
{
    UIAlertController *ctl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *deletePhoto = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.photoArr removeObjectAtIndex:index];
        [self.myHeader updateHeader];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [ctl addAction:deletePhoto];
    [ctl addAction:cancel];
    [self presentViewController:ctl animated:YES completion:nil];
}

#pragma mark -
#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.row || indexPath.row == 4 || indexPath.row == 5)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tfCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"tfCell"];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = kRGB(40, 40, 40);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UITextField *tf = [[UITextField alloc] init];
            tf.borderStyle = UITextBorderStyleNone;
            tf.clearButtonMode = UITextFieldViewModeNever;
            tf.font = [UIFont systemFontOfSize:13];
            tf.textAlignment = NSTextAlignmentRight;
            tf.textColor = kRGB(86, 86, 86);
            [tf addTarget:self action:@selector(editNickName:) forControlEvents:UIControlEventEditingChanged];
            [cell.contentView addSubview:tf];
            [tf mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@30);
                make.centerY.equalTo(cell.contentView);
                make.right.equalTo(cell.contentView).offset(-15);
                make.left.equalTo(cell.contentView).offset(100);
            }];
        }
        UITextField *tf;
        for (UIView *v in cell.contentView.subviews) {
            if ([v isKindOfClass:[UITextField class]]) {
                tf = (UITextField *)v;
                break;
            }
        }
        if (indexPath.row == 5)
        {
            cell.textLabel.text = @"职业";
            tf.text = _profession.length ? _profession : @"请设置";
            tf.tag = 2;
        }
        else if (indexPath.row == 4)
        {
            cell.textLabel.text = @"个人简介";
            tf.clearButtonMode = UITextFieldViewModeWhileEditing;
            tf.text = _introduction.length ? _introduction : @"请介绍自己";
            tf.tag = 3;
        }
        else
        {
            cell.textLabel.text = @"用户名";
            tf.text = _name;
            tf.tag = 1;
        }
        
        return cell;
    }
    else if (indexPath.row == 6)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imgCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"imgCell"];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = kRGB(40, 40, 40);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIImageView *img = [[UIImageView alloc] init];
            img.tag = 110;
            [cell.contentView addSubview:img];
            [img mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(@30);
                make.centerY.equalTo(cell.contentView);
                make.right.equalTo(cell.contentView).offset(-15);
            }];
        }
        cell.textLabel.text = @"修改头像";
        UIImageView *img = [cell.contentView viewWithTag:110];
        [img sd_setImageWithUrlStr:_avatar placeholderImage:[UIImage imageNamed:@"mine_default"]];
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = kRGB(40, 40, 40);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        cell.detailTextLabel.textColor = kRGB(86, 86, 86);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    switch (indexPath.row) {
        case 1:
            cell.textLabel.text = @"生日";
            cell.detailTextLabel.text = _birthday ? _birthday : @"请设置";
            break;
            
        case 2:
            cell.textLabel.text = @"身高";
            cell.detailTextLabel.text = _height ? [NSString stringWithFormat:@"%@cm",_height]: @"请设置";
            break;
            
        case 3:
            cell.textLabel.text = @"体重";
            cell.detailTextLabel.text = _weight ? [NSString stringWithFormat:@"%@kg",_weight]: @"请设置";
            break;
            
        case 4:
            cell.textLabel.text = @"职业";
            cell.detailTextLabel.text = @"年龄";
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 1:
            _type = PickTypeOfAge;
            [self.pickV showPickV];
            break;
            
        case 2:
            _type = PickTypeOfHeight;
            [self.pickV showPickV];
            break;
            
        case 3:
            _type = PickTypeOfWeight;
            [self.pickV showPickV];
            break;
            
        case 4:
            
            break;
            
        case 6:
            _imgType = 2;
            [self popImgChoose];
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark - EditInfoHeaderDataSource,EditInfoHeaderDelegate

- (NSString *)editInfoHeader:(EditInfoHeader *)header imageUrlAtIndex:(NSInteger)index
{
    if (index < self.photoArr.count) {
        return self.photoArr[index];
    }
    else
    {
        return nil;
    }
}

- (void)editInfoHeader:(EditInfoHeader *)header clickImageAtIndex:(NSInteger)index
{
    if (index < self.photoArr.count)
    {
        [self popDeletePhoto:index];
    }
    else
    {
        _imgType = 1;
        [self popImgChoose];
    }
}
- (void)editInfoHeader:(EditInfoHeader *)header moveImageAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)toIndex
{

}

#pragma mark -
#pragma mark - CustomPickVDelegate,CustomPickVDataSource
- (NSInteger)numberOfComponentsInCustomPickV:(CustomPickV *)customPickV
{
    if (_type == PickTypeOfAge) {
        return 2;
    }
    return 1;
}

- (NSArray *)customPickV:(CustomPickV *)customPickV contentOfRowsInComponent:(NSInteger)component
{
    if (_type == PickTypeOfAge)
    {
        if (!component)
        {
            return self.yearsArr;
        }
        else if(component == 1)
        {
            return self.monthsArr;
        }
    }
    else if (_type == PickTypeOfHeight)
    {
        return self.heightArr;
    }
    else if (_type == PickTypeOfWeight)
    {
        return self.weightArr;
    }
    return @[];
}

- (void)customPickV:(CustomPickV *)customPickV didSelectRows:(NSArray *)rows inComponents:(NSInteger)components
{
    if (_type == PickTypeOfAge)
    {
        NSInteger year = 0,month = 0;
        if (rows.count == 2) {
            year = [rows[0] integerValue];
            month = [rows[1] integerValue];
        }
        _birthday = [NSString stringWithFormat:@"%@-%@",self.yearsArr[year],self.monthsArr[month]];
        [self.myTabV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    else if (_type == PickTypeOfHeight)
    {
        NSInteger index = [rows[0] integerValue];
        _height = self.heightArr[index];
        [self.myTabV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    else if (_type == PickTypeOfWeight)
    {
        NSInteger index = [rows[0] integerValue];
        _weight = self.weightArr[index];
        [self.myTabV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
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
            if (_imgType == 2)
            {
                _avatar = imgUrl;
                [self.myTabV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
            else if (_imgType == 1)
            {
                [self.photoArr addObject:imgUrl];
                [self.myHeader updateHeader];
            }
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
