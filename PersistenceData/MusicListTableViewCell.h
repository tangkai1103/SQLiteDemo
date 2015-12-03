//
//  MusicListTableViewCell.h
//  PersistenceData
//
//  Created by 李士杰 on 15/11/25.
//  Copyright © 2015年 李士杰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MusicModel;
@interface MusicListTableViewCell : UITableViewCell
//根据Model进行赋值
- (void)setMusicListWithMode:(MusicModel *)model;

@end
