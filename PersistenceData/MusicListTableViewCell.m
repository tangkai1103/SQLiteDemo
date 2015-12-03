//
//  MusicListTableViewCell.m
//  PersistenceData
//
//  Created by 李士杰 on 15/11/25.
//  Copyright © 2015年 李士杰. All rights reserved.
//

#import "MusicListTableViewCell.h"
#import "MusicModel.h"
#import "UIImageView+WebCache.h"

@interface MusicListTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *singer;

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;

@end

@implementation MusicListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setMusicListWithMode:(MusicModel *)model
{
    self.name.text = model.name;
    
    self.singer.text = model.singer;
    
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
}
@end
