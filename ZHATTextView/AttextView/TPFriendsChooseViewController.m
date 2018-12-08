//
//  TPFriendsChooseViewController.m
//  WolfClient
//
//  Created by 张云江 on 2018/12/4.
//  Copyright © 2018年 shsx. All rights reserved.
//

#import "TPFriendsChooseViewController.h"
#import "TPFriendsChooseTableViewCell.h"

static const int NAVIGATION_HEIGHT = 64;
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface TPFriendsChooseViewController () <UITableViewDelegate,UITableViewDataSource>
{
    UIBarButtonItem        *rightBtn;
}
@property(nonatomic,strong)UITableView    *tableView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)NSMutableArray *chooseDataArr;

@end

@implementation TPFriendsChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray array];
    self.chooseDataArr = [NSMutableArray array];
    
    Friend *friend = [[Friend alloc]init];
    friend.userId = 100;
    friend.nickName = [NSString stringWithFormat:@"张三"];
    
    Friend *friend1 = [[Friend alloc]init];
    friend1.userId = 101;
    friend1.nickName = [NSString stringWithFormat:@"李四"];
    
    [self.dataArr addObject:friend];
    [self.dataArr addObject:friend1];
    
    [self creatUI];
    [self setCustomNavBar];
    
    [self.tableView reloadData];
}

- (void)setCustomNavBar
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(onRightBtnClick)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)creatUI
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVIGATION_HEIGHT + 10);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"TPFriendsChooseTableViewCell";
    TPFriendsChooseTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[TPFriendsChooseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    Friend *friend = self.dataArr[indexPath.row];
    [cell update:friend];
    cell.chooseBtn.tag = indexPath.row;
    [cell.chooseBtn addTarget:self action:@selector(onChooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TPFriendsChooseTableViewCell *cell = (TPFriendsChooseTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    Friend *friend = self.dataArr[indexPath.row];
    if (cell.chooseBtn.selected == YES) {
        cell.chooseBtn.selected = NO;
        [self.chooseDataArr removeObject:friend];
    } else {
        cell.chooseBtn.selected = YES;
        [self.chooseDataArr addObject:friend];
    }
}

- (void)onChooseBtnClick:(UIButton *)btn
{
    Friend *friend = self.dataArr[btn.tag];
    if (btn.selected == YES) {
        btn.selected = NO;
        [self.chooseDataArr removeObject:friend];
    } else {
        btn.selected = YES;
        [self.chooseDataArr addObject:friend];
    }
}

- (void)onRightBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(onTPFriendsChooseViewControllerBack:)]) {
        [self.delegate onTPFriendsChooseViewControllerBack:self.chooseDataArr];
    }
}
@end
