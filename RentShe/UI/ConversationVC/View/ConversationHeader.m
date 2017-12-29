//
//  ConversationHeader.m
//  RentShe
//
//  Created by Lzz on 2017/12/29.
//  Copyright © 2017年 Lengzz. All rights reserved.
//

#import "ConversationHeader.h"
#import "ConversationCell.h"

@interface ConversationHeader()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTabV;
@property (nonatomic, strong) NSArray *dataArr;
@end

@implementation ConversationHeader

- (NSArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = @[@(CustomConversationOfService),@(CustomConversationOfService)];
    }
    return _dataArr;
}

+ (instancetype)header
{
    ConversationHeader *header = [[ConversationHeader alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 0)];
    [header createV];
    return header;
}

- (void)createV
{
    self.height = self.dataArr.count * 70;
    UITableView *tabV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tabV.delegate = self;
    tabV.dataSource = self;
    tabV.backgroundColor = [UIColor orangeColor];
    tabV.separatorStyle = 
    tabV.scrollEnabled = NO;
    [self addSubview:tabV];
    _myTabV = tabV;
    
    [tabV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [tabV reloadData];
}

#pragma mark -
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConversationCell *cell = [ConversationCell cellWithTableView:tableView];
    cell.type = [self.dataArr[indexPath.row] integerValue];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

@end
