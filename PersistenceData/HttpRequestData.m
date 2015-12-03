//
//  HttpRequestData.m
//  PersistenceData
//
//  Created by 李士杰 on 15/11/25.
//  Copyright © 2015年 李士杰. All rights reserved.
//

#import "HttpRequestData.h"

@implementation HttpRequestData

+ (void)getRequestWithUrl:(NSString *)urlStr withFinishBlock:(finishBlock)block;
{
    HttpRequestData * request = [HttpRequestData new];
    
   [request fetchDataWithUrl:urlStr WithBlock:^(id data) {
       block(data);
   }];
}

- (void)fetchDataWithUrl:(NSString *)urlStr WithBlock:(finishBlock)block
{
 
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray * array = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:urlStr]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(array);
        });
    });

}
@end
