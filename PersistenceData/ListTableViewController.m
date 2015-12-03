//
//  ListTableViewController.m
//  PersistenceData
//
//  Created by 李士杰 on 15/11/25.
//  Copyright © 2015年 李士杰. All rights reserved.
//

#define musicUrl @"http://project.lanou3g.com/teacher/UIAPI/MusicInfoList.plist"
#import "ListTableViewController.h"
#import "HttpRequestData.h"
#import "MusicModel.h"
#import "DBHelper.h"
#import "MusicListTableViewCell.h"

@interface ListTableViewController ()

@property (nonatomic, strong)NSMutableArray * musicArray;

@end

@implementation ListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MusicListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell_id"];
    //加载数据
    [self loadingData];
}

//layz loading...
-(NSMutableArray *)musicArray
{
    if (!_musicArray) {
        _musicArray = [NSMutableArray array];
    }
    return _musicArray;
}

//数据请求及加载
- (void)loadingData
{
    //打开数据库
    [[DBHelper sharedDBHelper] openDB];
    
    //先从数据库中获取数据
    [self.musicArray addObjectsFromArray:[[DBHelper sharedDBHelper] selectAllMusicData]];
    
    //如果没有从数据库中拿到数组，然后去进行网络请求数据
    __weak ListTableViewController * weakSelf = self;
    
    if (self.musicArray.count == 0) {
        
        [HttpRequestData getRequestWithUrl:musicUrl withFinishBlock:^(id data) {
            
            NSMutableArray * array = [NSMutableArray array];
            
            for (NSDictionary * dic in data) {
                MusicModel * model = [MusicModel new];
                
                [model setValuesForKeysWithDictionary:dic];
                
                [array addObject:model];
                
                //往数据库插入数据
                [[DBHelper sharedDBHelper] insertData:model];
            }
            //添加数据源
            [weakSelf.musicArray addObjectsFromArray:array];
            
            [weakSelf.tableView reloadData];
            
            //插入完毕之后关闭数据库
            [[DBHelper sharedDBHelper] closeDB];
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.musicArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MusicListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_id" forIndexPath:indexPath];
    
    MusicModel * model = self.musicArray[indexPath.row];
    
    [cell setMusicListWithMode:model];
    
    return cell;
}

- (IBAction)deleteData:(id)sender
{
    //打开数据库
    [[DBHelper sharedDBHelper] openDB];
    
    //删除所有缓存
     [[DBHelper sharedDBHelper] deleteAllData];
    
    //关闭数据库
    [[DBHelper sharedDBHelper] closeDB];
}

@end
