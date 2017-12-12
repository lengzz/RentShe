//
//  InformVC.m
//  RentShe
//
//  Created by Feng on 2017/11/19.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "InformVC.h"
#import "InformFooterV.h"

#define kInformCell @"informCellIdentifier"

@interface InformVC ()<UITableViewDelegate,UITableViewDataSource,InformFooterVDelegate,InformFooterVDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSIndexPath *_selectedIndex;
}
@property (nonatomic, strong) UITableView *myTabV;
@property (nonatomic, strong) InformFooterV *myFooter;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSMutableArray *photoArr;
@end

@implementation InformVC

- (NSArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = @[@"虚假信息",
                     @"恶意骚扰",
                     @"淫秽色情",
                     @"垃圾广告",
                     @"欺骗，托",
                     @"其他"];
    }
    return _dataArr;
}

- (NSMutableArray *)photoArr
{
    if (!_photoArr) {
        _photoArr = [NSMutableArray array];
    }
    return _photoArr;
}

- (UITableView *)myTabV
{
    if (!_myTabV) {
        _myTabV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight) style:UITableViewStyleGrouped];
        _myTabV.delegate = self;
        _myTabV.dataSource = self;
        _myTabV.backgroundColor = kRGB_Value(0xf2f2f2);
        //        _myTabV.allowsMultipleSelection = YES;
        _myTabV.tableFooterView = self.myFooter;
        [self.view addSubview:_myTabV];
    }
    return _myTabV;
}

- (InformFooterV *)myFooter
{
    if (!_myFooter) {
        _myFooter = [[InformFooterV alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowWidth/3.0 + 50)];
        _myFooter.delegate = self;
        _myFooter.dataSource = self;
    }
    return _myFooter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavbar];
    [self myTabV];
    _selectedIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTabV selectRowAtIndexPath:_selectedIndex animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self.navigationController.navigationBar setCustomBarBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.shadowImage = nil;
}

- (void)createNavbar
{
    [self.navigationItem setTitleView:[CustomNavVC setNavgationItemTitle:@"举报"]];
    
    [self.navigationItem setLeftBarButtonItem:[CustomNavVC getLeftBarButtonItemWithTarget:self action:@selector(backClick) normalImg:[UIImage imageNamed:@"setting_back"] hilightImg:[UIImage imageNamed:@"setting_back"]]];
    
    [self.navigationItem setRightBarButtonItem:[CustomNavVC getRightBarButtonItemWithTarget:self action:@selector(commitAction) titile:@"提交"]];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)commitAction
{
    NSString *photoStr = [self.photoArr componentsJoinedByString:@","];
    NSDictionary *dic = @{@"explain":self.dataArr[_selectedIndex.row],
                          @"his_id":self.userId,
                          @"image":photoStr};
    [NetAPIManager reportUser:dic callBack:^(BOOL success, id object) {
        if (success) {
            NSString *string = object[@"message"];
            float time = (float)string.length*0.12 + 0.5;
            [SVProgressHUD showSuccessWithStatus:object[@"message"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else
            [SVProgressHUD showErrorWithStatus:object[@"message"]];
    }];
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
        [self.myFooter updateHeader];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [ctl addAction:deletePhoto];
    [ctl addAction:cancel];
    [self presentViewController:ctl animated:YES completion:nil];
}

#pragma mark -
#pragma mark - InformFooterVDelegate,InformFooterVDataSource

- (NSString *)informFooter:(InformFooterV *)footer imageUrlAtIndex:(NSInteger)index
{
    if (index < self.photoArr.count) {
        return self.photoArr[index];
    }
    else
    {
        return nil;
    }
}

- (void)informFooter:(InformFooterV *)header clickImageAtIndex:(NSInteger)index
{
    if (index < self.photoArr.count)
    {
        [self popDeletePhoto:index];
    }
    else
    {
        [self popImgChoose];
    }
}

#pragma mark -
#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kInformCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kInformCell];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = kRGB_Value(0x282828);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    }
    UIImageView *img = (UIImageView *)cell.accessoryView;
    if ([indexPath isEqual:_selectedIndex]) {
        img.image = [UIImage imageNamed:@"rent_chooseweek"];
    }
    else
        img.image = [UIImage new];
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 20)];
    footer.backgroundColor = [UIColor clearColor];
    return footer;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 20)];
    header.backgroundColor = [UIColor clearColor];
    
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_selectedIndex isEqual:indexPath]) {
        return;
    }
    NSIndexPath *oldIndex = _selectedIndex;
    _selectedIndex = indexPath;
    [tableView reloadRowsAtIndexPaths:@[indexPath,oldIndex] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [NetAPIManager uploadImg:image withParams:nil callBack:^(BOOL success, id object) {
        if (success) {
            NSDictionary *dic = object[@"data"];
            NSString *imgUrl = dic[@"url"];
            [self.photoArr addObject:imgUrl];
            [self.myFooter updateHeader];
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
