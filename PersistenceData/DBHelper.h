//
//  DBHelper.h
//  PersistenceData
//
//  Created by 李士杰 on 15/11/25.
//  Copyright © 2015年 李士杰. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MusicModel;

@interface DBHelper : NSObject

//声明单例方法
+ (instancetype)sharedDBHelper;

//打开数据库
- (void)openDB;

//关闭数据库
- (void)closeDB;

//插入数据
- (void)insertData:(MusicModel *)music;

//删除所有数据
- (void)deleteAllData;

//查询所有数据
- (NSArray *)selectAllMusicData;

@end
