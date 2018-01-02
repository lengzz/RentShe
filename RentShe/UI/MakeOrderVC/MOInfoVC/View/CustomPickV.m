//
//  CustomPickV.m
//  RentShe
//
//  Created by Lengzz on 2017/8/12.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "CustomPickV.h"

@interface CustomPickV ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIView *_contentV;
}
@property (nonatomic, strong) UIPickerView *pickerV;
@property (nonatomic, strong) NSMutableDictionary *dataDic;
@end

@implementation CustomPickV

- (void)dealloc
{
    NSLog(@"CustomPickV dealloc");
}

- (NSMutableDictionary *)dataDic
{
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}

- (UIPickerView *)pickerV
{
    if (!_pickerV) {
        _pickerV = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, kWindowWidth, 210)];
        _pickerV.backgroundColor = kRGB_Value(0xf2f2f2);
        _pickerV.delegate = self;
        _pickerV.dataSource = self;
    }
    return _pickerV;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createV];
    }
    return self;
}

- (void)createV
{
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0, 0, kWindowWidth, kWindowHeight);
    UIView *contentV = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight - 250, kWindowWidth, 250)];
    contentV.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentV];
    _contentV = contentV;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, .5)];
    line.backgroundColor = kRGB(227, 227, 229);
    [_contentV addSubview:line];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(10, 5, 40, 30);
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:kRGB(255, 117, 26) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [_contentV addSubview:cancelBtn];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(kWindowWidth - 50, 5, 40, 30);
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:kRGB(255, 117, 26) forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [_contentV addSubview:confirmBtn];
    
    [_contentV addSubview:self.pickerV];
}

- (void)showPickV
{
    [self.pickerV reloadAllComponents];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
}

- (void)selectWithTitles:(NSArray *)arr
{
    if (arr.count) {
        for (NSInteger i = 0; i < arr.count; i ++) {
            if (i < self.pickerV.numberOfComponents)
            {
                NSInteger row = 0;
                NSArray *data = self.dataDic[@(i)];
                if ([data containsObject:arr[i]]) {
                    row = [data indexOfObject:arr[i]];
                }
                [self.pickerV selectRow:row inComponent:i animated:YES];
            }
            else
                break;
        }
    }
}

- (void)reloadCustomPickV
{
    [self.pickerV reloadAllComponents];
}

- (NSInteger)selectedRowInComponent:(NSInteger)component
{
    return [self.pickerV selectedRowInComponent:component];
}

- (void)cancelAction
{
    [self removeFromSuperview];
}

- (void)confirmAction
{
    NSMutableArray *rows = [@[] mutableCopy];
    for(NSInteger i = 0; i<self.pickerV.numberOfComponents; i++)
    {
        [rows addObject:@([self.pickerV selectedRowInComponent:i])];
    }
    if ([self.delegate respondsToSelector:@selector(customPickV:didSelectRows:inComponents:)])
    {
        [self.delegate customPickV:self didSelectRows:rows inComponents:self.pickerV.numberOfComponents];
    }
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

#pragma mark - 
#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if ([self.dataSource respondsToSelector:@selector(numberOfComponentsInCustomPickV:)])
    {
        return [self.dataSource numberOfComponentsInCustomPickV:self];
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([self.dataSource respondsToSelector:@selector(customPickV:contentOfRowsInComponent:)])
    {
        [self.dataDic setObject:[self.dataSource customPickV:self contentOfRowsInComponent:component] forKey:@(component)];
        return [self.dataSource customPickV:self contentOfRowsInComponent:component].count;
    }
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (pickerView.numberOfComponents) {
        case 1:
            
            break;
            
        case 2:
            
            break;
            
        case 3:
            if (!component)
            {
                [pickerView reloadComponent:1];
                [pickerView reloadComponent:2];
            }
            else if(component == 1)
            {
                [pickerView reloadComponent:2];
            }
            break;
            
        default:
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([self.dataSource respondsToSelector:@selector(customPickV:contentOfRowsInComponent:)]) {
        return [self.dataSource customPickV:self contentOfRowsInComponent:component][row];
    }
    return @"";
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (!component)
    {
        return kWindowWidth/2.0;
    }
    else
        return kWindowWidth/4.0;
}

@end
