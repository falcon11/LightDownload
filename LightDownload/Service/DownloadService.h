//
//  DownloadService.h
//  LightDownload
//
//  Created by starnet on 10/16/15.
//  Copyright © 2015 com.evideo. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DownloadService : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@property (atomic, copy) void (^errorBlock)(NSString*);
@property (atomic, copy) void (^completion)();
@property (atomic, copy) void (^progressBlock)(long long currentBytes, long long totalBytes);

- (instancetype)initWithErrorBlock:(void (^)(NSString *))errorBlock completion:(void (^)())completion;

- (void)startWithURL:(NSString*)url cacheCapacity:(unsigned long long)capacity;

- (void)stop;

@end
