//
//  DownloadService.m
//  LightDownload
//
//  Created by starnet on 10/16/15.
//  Copyright © 2015 com.evideo. All rights reserved.
//

#import "DownloadService.h"


@interface DownloadService ()<NSURLConnectionDataDelegate, NSURLConnectionDelegate>
{
    BOOL hadGetName;
    NSString *_url;
}

@property (nonatomic, assign) unsigned long long    totalLength;    // 文件总大小
@property (nonatomic, assign) unsigned long long    startDataLength;    // 本地存在文件的大小
@property (nonatomic, assign) unsigned long long    expectedLength; // 从服务器期望文件的大小
@property (nonatomic, assign) unsigned long long    cacheCapacity;  // 缓存文件容量,以k为单位
@property (nonatomic, strong) NSURLConnection     *dataConncetion;   // 网络连接
@property (nonatomic, strong) NSDictionary        *responseHeaders;  // 网络连接头部信息
@property (nonatomic, strong) NSFileHandle        *file;             // 文件操作句柄
@property (nonatomic, strong) NSMutableData       *cacheData;        // 用于缓存的data数据
@property (atomic, strong) NSString *fileName;

@end

@implementation DownloadService
{


}


- (instancetype)initWithErrorBlock:(void (^)(NSString *))errorBlock completion:(void (^)())completion
{
    self = [super init];
    if (self) {
        _errorBlock = errorBlock;
        _completion = completion;
        hadGetName = NO;
    }
    return self;
}


- (void)startWithURL:(NSString *)url cacheCapacity:(unsigned long long)capacity
{
    //获取缓存容量
    if (capacity <= 0) {
        _cacheCapacity = 100*1024;
    }
    else
    {
        _cacheCapacity = capacity*1024;
    }
    _url = url;
    
    _cacheData = [[NSMutableData alloc] init];
    
    if (hadGetName == NO) {
        [self getFileName:url];
    }
    
}

- (void)didGetFileName
{
    NSString *fileName = _fileName;
    if (fileName == nil) {
        fileName = [_url lastPathComponent];
    }
    NSLog(@"..........suggest filename:%@", fileName);
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [array[0] stringByAppendingPathComponent:fileName];
    
    NSArray *allFile = [[NSFileManager defaultManager] directoryContentsAtPath:array[0]];
    NSLog(@"%@.......................", allFile);
    //记录文件起始位置
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        _startDataLength = [[NSData dataWithContentsOfFile:filePath] length];
        NSLog(@"yes file exits......startlength:%llu",_startDataLength);
    }
    else
    {
        _startDataLength = 0;
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    //打开写文件流
    _file = [NSFileHandle fileHandleForWritingAtPath:filePath];
    if (_file == nil) {
        if (_errorBlock != nil) {
            _errorBlock(@"get file handle failed!");
        }
        NSLog(@"get file handle failed!............");
        return;
    }
    
    //创建网络连接，禁止读取本地缓存
    NSURL *destinationURL = [[NSURL alloc] initWithString:_url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:destinationURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    
    NSDictionary *headers = [request allHTTPHeaderFields];
    [headers setValue:@"iOS-Client-ABC" forKey:@"User-Agent"];
    
    [request setHTTPMethod:@"GET"];
    //设置断点续传（需要服务器支持）
    [request setValue:[NSString stringWithFormat:@"bytes=%llu-", _startDataLength] forHTTPHeaderField:@"Range"];
    
    //开始连接与下载
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    
    _dataConncetion = connection;
    
    if (_dataConncetion == nil) {
        NSLog(@"create connecton failed............");
        if(_errorBlock != nil)
        {
            _errorBlock(@"无法连接到服务器。。。。。。。。。。。");
        }
        return;
    }
    [_dataConncetion setDelegateQueue: [[NSOperationQueue alloc] init]];
    [_dataConncetion start];
    NSLog(@".......start.........");

}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"connection response............");
    if (hadGetName == NO) {
        _fileName = response.suggestedFilename;
        hadGetName = YES;
        [self stop];
        [self didGetFileName];
        return;
    }
    if ([response isKindOfClass:[NSURLResponse class]]) {
        if ([response expectedContentLength] != NSURLResponseUnknownLength) {
            //获取将要下载的数据长度
            _expectedLength = [response expectedContentLength];
            
            _totalLength = _startDataLength + _expectedLength;
            NSLog(@"startlength:%llu............",_startDataLength);
            if (_totalLength <= _startDataLength) {
                [self stop];
                if (_completion) {
                    _completion();
                }
                NSLog(@"请求超出。。。。。。。。。");
            }
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            _responseHeaders = httpResponse.allHeaderFields;
            NSLog(@"respnse:%@...........",_responseHeaders);
            
        }
        else
        {
            NSLog(@"不支持断点续传。。。。。。。。");
            if (_errorBlock) {
                _errorBlock(@"不支持断点续传。。。。。。。");
            }
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_cacheData appendData:data];
    
    //如果该缓存数据长度已经超过指定大小
    if (_cacheData.length > _cacheCapacity) {
        [_file seekToEndOfFile];
        [_file writeData:_cacheData];
        [_cacheData setLength:0];
    }
    _startDataLength += data.length;
    
    if (_progressBlock) {
        _progressBlock(_startDataLength, _totalLength);
    }
    
//    NSLog(@"receive........");
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [_file seekToEndOfFile];
    [_file writeData:_cacheData];
    [_cacheData setLength:0];
    NSLog(@"下载完了..........");
    if (_completion) {
        self.completion();
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (_errorBlock) {
        _errorBlock(@"连接不成功，下载失败！");
    }
}

- (void)stop
{
    NSLog(@"%@---------------", _dataConncetion);
    [_dataConncetion cancel];
    _dataConncetion = nil;
    NSLog(@"call cancel.......");
}

- (void)getFileName:(NSString *)url
{
    NSLog(@"set filename............");
    NSURL *destinationURL = [[NSURL alloc] initWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:destinationURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    
    //开始连接与下载
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    _dataConncetion = connection;

    if (_dataConncetion == nil) {
        NSLog(@"create connecton failed............");
        if(_errorBlock != nil)
        {
            _errorBlock(@"无法连接到服务器。。。。。。。。。。。");
        }
        return;
    }
    [_dataConncetion setDelegateQueue: [[NSOperationQueue alloc] init]];
    [_dataConncetion start];
    NSLog(@"............%@", _dataConncetion);
    NSLog(@"set filename over............");
}






@end
