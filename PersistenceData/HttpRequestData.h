//
//  HttpRequestData.h
//  PersistenceData
//
//  Created by 李士杰 on 15/11/25.
//  Copyright © 2015年 李士杰. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^finishBlock)(id data);

@interface HttpRequestData : NSObject
//根据URL回调数据
+ (void)getRequestWithUrl:(NSString *)urlStr withFinishBlock:(finishBlock)block;

@end
