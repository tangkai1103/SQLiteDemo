//
//  DBHelper.m
//  PersistenceData
//
//  Created by 李士杰 on 15/11/25.
//  Copyright © 2015年 李士杰. All rights reserved.
//

#import "DBHelper.h"
#import <sqlite3.h>
#import "MusicModel.h"

@implementation DBHelper

//声明单例方法
+ (instancetype)sharedDBHelper
{
    static DBHelper * shareSingle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        shareSingle = [[[self class] alloc] init];
        
    });
    return shareSingle;
}

// 创建一个指针变量，代表数据库
static sqlite3 *db = nil;

//打开数据库
- (void)openDB
{
    
    // 1.拼接路径
//    NSString *dbFilePath = [NSTemporaryDirectory() stringByAppendingString:@"musicData.sqlite"];
    NSString *dbFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:@"musicData.sqlite"];
    NSLog(@"%@", dbFilePath);
    
    // 打开数据库
    // 第一个参数：数据库路径
    // 第二个参数：数据库
    int res = sqlite3_open(dbFilePath.UTF8String, &db);
    
    // 判断结果
    if (res == SQLITE_OK) {
        NSLog(@"数据库打开成功");
        
        // 创建数据表
        // 1.准备建表的sql语句
        NSString *sql = @"CREATE TABLE IF NOT EXISTS Music (number INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE, name NOT NULL, picUrl NOT NULL, singer NOT NULL)";
        // 2.执行sql语句
        // 参数1：数据库
        // 参数2：sql语句
        // 参数3：用来回调的函数指针
        // 参数4：函数指针参数
        // 参数5：错误信息
        int result = sqlite3_exec(db, sql.UTF8String, nil, nil, nil);
        // 3.判断
        if (result == SQLITE_OK) {
            NSLog(@"创建数据表成功");
        } else {
            NSLog(@"创建数据表失败");
        }
        
    } else {
        NSLog(@"数据库打开失败");
    }
}

//关闭数据库
- (void)closeDB
{
    if (db != nil) {
        // 通过 sqlite3_close() 函数
        int res = sqlite3_close(db);
        if (res == SQLITE_OK) {
            NSLog(@"关闭成功");
        }
        db = nil;
    }
}


//插入数据
- (void)insertData:(MusicModel *)music
{
    
    
    // 1.准备sql语句
    
    sqlite3_stmt * stmt = nil;
    
    NSString * sql = @"INSERT INTO Music (name, picUrl, singer) values (?, ?, ?)";
    
    // 验证sql语句
    int result = sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil);
    
    if (result == SQLITE_OK) {
        // sql语句绑定数据
        sqlite3_bind_text(stmt, 1, [music.name UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 2, [music.picUrl UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 3, [music.singer UTF8String], -1, nil);
    }

    // 执行sql语句
    int result2 = sqlite3_step(stmt);
    
    if (result2 != SQLITE_ERROR) {
        NSLog(@"插入成功");
    } else {
        NSLog(@"插入失败");
    }
    sqlite3_finalize(stmt);
    


}

//删除全部
- (void)deleteAllData
{
    NSString *sql = @"DELETE FROM Music";
        
    char *error;
        
    if (SQLITE_OK == sqlite3_exec(db, sql.UTF8String, nil, nil, &error)) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
        NSLog(@"%s", error);
    }
}

//查询所有数据
- (NSArray *)selectAllMusicData
{
    NSMutableArray *array = [NSMutableArray array];
    
    // 1.准备sql语句
    NSString *sql = @"SELECT * FROM Music";
    
    // 2.创建存值，取值指针（跟随指针）
    sqlite3_stmt *stmt = nil;
    
    // 3.准备sql语句，并查询数据
    int res = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, nil);
    
    // 4.从stmt中取出数据
    if (SQLITE_OK == res) {
        
        // 4.1.遍历stmt中的内容，如果没有数据了，循环结束
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            // name
            const char *nameSqlStr = (const char *)sqlite3_column_text(stmt, 1);
            NSString *name = [NSString stringWithCString:nameSqlStr encoding:NSUTF8StringEncoding];

            // picUrl
            const char *picUrlSqlStr = (const char *)sqlite3_column_text(stmt, 2);
            NSString *picUrl = [NSString stringWithCString:picUrlSqlStr encoding:NSUTF8StringEncoding];
            
            // singer
            const char *singerSqlStr = (const char *)sqlite3_column_text(stmt, 3);
            NSString *singer = [NSString stringWithCString:singerSqlStr encoding:NSUTF8StringEncoding];
            
            // 创建MusicModel模型
            MusicModel *music = [MusicModel new];
            music.name = name;
            music.picUrl = picUrl;
            music.singer = singer;
            
            // 放到数组中
            [array addObject:music];
        }
    }
    
    // 关掉stmt
    sqlite3_finalize(stmt);
    
    return array;
}

@end
