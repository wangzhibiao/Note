//
//  HomeTableViewController.m
//  RightBrain
//
//  Created by 王小帅 on 2017/3/2.
//  Copyright © 2017年 王小帅. All rights reserved.
//

#import "HomeTableViewController.h"
#import "NoteModel.h"
#import "RBDataTool.h"
#import "TableViewHeaderView.h"
#import "TextTableViewCell.h"
#import "TextEditorViewController.h"
#import "MainNavViewController.h"
#import "SoundEditorViewController.h"

@interface HomeTableViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>


// 数据源
@property (nonatomic, strong) NSMutableArray *noteArray;

// 没有数据背景图
@property (nonatomic, strong) UIImageView *noDataBG;



@end

@implementation HomeTableViewController

#pragma mark - 懒加载数据源
- (NSMutableArray *)noteArray
{
    if (_noteArray == nil){
        _noteArray = [NSMutableArray array];
    }
    return _noteArray;
}

- (UIImageView *)noDataBG
{
    if (!_noDataBG){
    
        UIImage *image = [UIImage imageNamed:@"messageEmpty~iphone"];
        _noDataBG = [[UIImageView alloc] initWithImage:image];
        
        [self.view addSubview:_noDataBG];
        
        _noDataBG.hidden = YES;
        _noDataBG.center = self.view.center;
    }
    return _noDataBG;
}




#pragma mark - 页面出实话方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 新用户给一条模拟的笔记
    [self setupNewUserNote];
    
    // 设置顶部搜索框
    [self setupTitleView];
    
    // 设置表格的样式 不让头部视图在顶端停靠
    self.tableView = [[UITableView alloc] initWithFrame:self.tableView.frame style:UITableViewStyleGrouped];
    // 去掉 cell 之间的分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 沙拉自动刷新
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        
        [self loadData];
    }];
    self.tableView.mj_footer = footer;
    
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNew];
    }];
    
    [header setTitle:@"你的日记都在下面了" forState:MJRefreshStateIdle];
    [header setTitle:@"古人云多劳才能多得" forState:MJRefreshStatePulling];
    [header setTitle:@"搜刮中..." forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden = YES;
    
    self.tableView.mj_header = header;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    // 注册cell
    UINib *textCell = [UINib nibWithNibName:@"TextTableViewCell" bundle:nil];
    [self.tableView registerNib:textCell forCellReuseIdentifier:@"textCell"];
    
}


#pragma mark - 设置顶部搜索框
- (void)setupTitleView
{
    
    // 暂时显示标题
    UILabel *title = [UILabel new];
    title.text = @"奋笔疾书";
    title.textColor = golbal_color(0, 0, 0);
    title.font = [UIFont systemFontOfSize:17 weight:1];
    [title sizeToFit];
    [self.navigationItem setTitleView:title];
    
    return;
// TODO: - 待完善搜索功能
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 35)];
    //allocate titleView
    UIColor *color =  self.navigationController.navigationBar.barTintColor;
    
    [titleView setBackgroundColor:color];
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    
    searchBar.delegate = self;
//    searchBar.frame = CGRectMake(0, 0, 200, 35);
    searchBar.backgroundColor = color;
    searchBar.layer.cornerRadius = 18;
    searchBar.layer.masksToBounds = YES;
    [searchBar.layer setBorderWidth:8];
    [searchBar.layer setBorderColor:[UIColor whiteColor].CGColor];  //设置边框为白色

    searchBar.placeholder = @"搜索关键字";
    [titleView addSubview:searchBar];
    
    //Set to titleView
    [self.navigationItem.titleView sizeToFit];
    self.navigationItem.titleView = titleView;
}

#pragma mark - 搜索框代理代码
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"***  searchBarSearchButtonClicked ****");
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"textDidChange:%@",searchText);
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            [cancel setTitle:@"搜索" forState:UIControlStateNormal];
            cancel.titleLabel.font = [UIFont systemFontOfSize:14];
        }
    }
}

/** 如果是第一次使用的用户 给一条模拟的数据 */
- (void)setupNewUserNote
{
    NSString *isNewUser = [[NSUserDefaults standardUserDefaults] valueForKey:@"isNewUser"];
    if (!isNewUser){
        
            NoteModel *model = [NoteModel new];
            model.noteID = @"1000000";
            model.noteBody = [[NSAttributedString alloc] initWithString: @"点击下方➕来创建你的第一条笔记吧"];
            model.noteDate = @"2017-03-08 12:35";
            
            [[RBDataTool shared] insertNote:model];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isNewUser"];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.noteArray.count > 0){
        [self.tableView.mj_header beginRefreshing];
    }else{
    
        [self loadData];
    }
}

- (void)loadNew
{
    for (NoteModel *model in [[RBDataTool shared] selectNotes:1]) {
        
        [self sortUpArray:model withTag:0];
    }
    
    [self.tableView.mj_header endRefreshing];
    
    [self.tableView reloadData];
    
    self.noDataBG.hidden = self.noteArray.count;

}


#pragma mark - 从本地数据库加载数据
- (void)loadData
{
    // 清空数组
    self.currentPage += 1;
    
    if ([[RBDataTool shared] selectNotes:self.currentPage].count){
    }else{

        if (self.currentPage > 1){
            self.currentPage -= 1;
        }
    }
    
    // 循环查询数据
    for (NoteModel *model in [[RBDataTool shared] selectNotes:self.currentPage]) {
        
        [self sortUpArray:model withTag:1];
    }
    
    [self.tableView reloadData];
    
    self.noDataBG.hidden = self.noteArray.count;
}



/** 分析数据放入数据源数组 */
- (void)sortUpArray:(NoteModel *)model withTag:(int)tag
{
    // 查看数据日期
    NSMutableDictionary *newDict = [self isContentModel:model.noteDate];
    // 不包含改日期就新建一个字典存储
    if (!newDict){
        newDict = [NSMutableDictionary dictionary];
        NSMutableArray *array = [NSMutableArray array];
        
        [array addObject:model];
        [newDict setValue:model.noteDate forKey:@"time"];
        [newDict setValue:array forKey:@"notes"];
        
        if (tag){
            [self.noteArray addObject:newDict];
        }else{
            [self.noteArray insertObject:newDict atIndex:0];
        }
    }else{
        // 包含了日期 就添加到数组中
        NSMutableArray *array = newDict[@"notes"];
        if (![self isContainsModel:model inArray:array]){
            if (tag){
                [array addObject:model];
            }else{
                [array insertObject:model atIndex:0];
            }
        }
    }
}

- (BOOL)isContainsModel:(NoteModel *)model inArray:(NSArray *)array
{
    for (__strong NoteModel *m in array) {
        
        if ([m.noteID isEqualToString:model.noteID]){
            
            // 顺便替换了
            m = model;
            return YES;
        }
        
    }
    
    return NO;
}

/** 查看新的数据是否在字典中匹配到了日期 因为安日期分组 所以一个日期不能有多个分组 */
- (NSMutableDictionary *)isContentModel:(NSString *)key
{
    for (NSMutableDictionary *dict in self.noteArray) {
        if ([[NSDate dateStrWithStr:dict[@"time"]] isEqualToString:[NSDate dateStrWithStr:key]]){
            return dict;
        }
    }
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view 数据源和代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.noteArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // 获取对应字典
    NSDictionary *dict = self.noteArray[section];
    NSArray *array = dict[@"notes"];

    return array.count;
}

/** 设置cell的数据 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *ID = @"textCell";
    
    TextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 获取model
    NSDictionary *dict = self.noteArray[indexPath.section];

    NoteModel *model = dict[@"notes"][indexPath.row];
    
    cell.model = model;
    
    return cell;
}

/** 组头视图 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    TableViewHeaderView *header = [TableViewHeaderView instance];
    header.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 44);
    // 获取model
    NSDictionary *dict = self.noteArray[section];
    
    header.dateLabel.text = [NSDate dateStrWithStr:dict[@"time"]];
    header.dateLabel.font = [UIFont systemFontOfSize:17 weight:1];
    
    return header;
}


/** cell 点击 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获取model
    NSDictionary *dict = self.noteArray[indexPath.section];
    NoteModel *model = dict[@"notes"][indexPath.row];
    
    if (model.type == 0 || model.type == 2){ // 文字
        // 创建控制器
        TextEditorViewController *editorVC = [[TextEditorViewController alloc] init];
        // 赋值属性
        editorVC.model = model;
        editorVC.isEditored = NO;
        
        // 导航控制器
        MainNavViewController *nav = [[MainNavViewController alloc] initWithRootViewController:editorVC];
        
        // 弹出
        [self presentViewController:nav animated:YES completion:nil];
        
    }else if (model.type == 1){// 录音
        
        // 弹出编辑视图
        SoundEditorViewController *soundEditor = [SoundEditorViewController new];
        MainNavViewController *nav = [[MainNavViewController alloc] initWithRootViewController:soundEditor];
        soundEditor.isEditored = NO;
        soundEditor.model = model;
        
        [self presentViewController:nav animated:YES completion:nil];

    }
    
    
}

/** 组头高度 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}

/** 这里要设置0.1 就是最小了 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

/** 行高 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

/** 删除 */
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        
//    }];
//    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        
//    }];
//    editAction.backgroundColor = [UIColor grayColor];
//    return @[deleteAction, editAction];
//}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // 获取model
        NoteModel *model = self.noteArray[indexPath.section][@"notes"][indexPath.row];
        [[RBDataTool shared] deleateNote:model];
        
        // 从当前数组中清楚
        NSDictionary *dict = self.noteArray[indexPath.section];
        NSMutableArray *array = dict[@"notes"];
    
        [array removeObjectAtIndex:indexPath.row];
        
        if (array.count == 0){
            [self.noteArray removeObjectAtIndex:indexPath.section];
        }
        
        // 如果是录音 还要将本地的录音删除
        if (model.type == 1){
            NSFileManager *manager = [NSFileManager defaultManager];
            
            if ([manager fileExistsAtPath:model.aduio isDirectory:nil]){
                [manager removeItemAtPath:model.aduio error:nil];
            }
        }
        
        
        // 重新加载数据
        [self loadData];
        
    }else{
    
    }
}

@end
