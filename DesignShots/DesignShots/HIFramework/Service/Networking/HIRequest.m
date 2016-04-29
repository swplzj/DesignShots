//
//  HIRequest.m
//  UCreditSaleProject
//
//  Created by lizhenjie on 15/8/28.
//  Copyright (c) 2015年 UCredit. All rights reserved.
//

#import "HIRequest.h"
#import "HINetworkPrivate.h"
#import "HINetworkConfig.h"

@interface HIRequest ()

@property (strong, nonatomic) id cacheJSON;

@end

@implementation HIRequest {
    BOOL _isDataFromCache;
}

- (NSInteger)cacheTimeInSeconds {
    return -1;
}

- (long long)cacheVersion {
    return 0;
}

- (id)cacheSensitiveData {
    return nil;
}

- (void)start {
    if (self.ignorCache) {
        [super start];
        return;
    }
   
    // 检查缓存保存时间
    if ([self cacheTimeInSeconds] < 0) {
        [super start];
        return;
    }
    
    // 检查缓存版本
    long long cacheVersionFileContent = [self cacheVersionFileContent];
    if (cacheVersionFileContent != [self cacheVersion]) {
        [super start];
        return;
    }
    
    // 检查缓存是否存在
    NSString *path = [self cacheFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [super start];
        return;
    }
    
    // 检查缓存是否过期
    int seconds = [self cacheFileDuration:path];
    if (seconds < 0 || seconds > [self cacheTimeInSeconds]) {
        [super start];
        return;
    }
    
    // 加载缓存
    _cacheJSON = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (_cacheJSON == nil) {
        [super start];
        return;
    }
    
    _isDataFromCache = YES;
    [self requestCompleteFilter];
    HIRequest *strongSelf = self;
    [strongSelf.delegate requestFinished:strongSelf];
    if (strongSelf.successCompletionBlock) {
        strongSelf.successCompletionBlock(strongSelf);
    }
    [strongSelf clearCompletionBlock];
    
    
}

- (void)startWithoutCache {
    [super start];
}

- (id)cacheJSON {
    if (_cacheJSON) {
        return _cacheJSON;
    } else {
        NSString *path = [self cacheFilePath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:path]) {
            _cacheJSON = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        }
        return _cacheJSON;
    }
}

- (BOOL)isDataFromCache {
    return _isDataFromCache;
}

- (BOOL)isCacheVersionExpired {
    long long cacheVersionFileContent = [self cacheVersionFileContent];
    if (cacheVersionFileContent != [self cacheVersion]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma Network Request Delegate

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    [self saveJSONResponseToCacheFile:[super responseJSONObject]];
}

// 手动将其他请求的JsonResponse写入该请求的缓存
// 比如AddNoteApi, UpdateNoteApi都会获得Note，且其与GetNoteApi共享缓存，可以通过这个接口写入GetNoteApi缓存
- (void)saveJSONResponseToCacheFile:(id)JSONResponse {
    if ([self cacheTimeInSeconds] > 0 && ![self isDataFromCache]) {
        NSDictionary *json = JSONResponse;
        if (json != nil) {
            [NSKeyedArchiver archiveRootObject:json toFile:[self cacheFilePath]];
            [NSKeyedArchiver archiveRootObject:@([self cacheVersion]) toFile:[self cacheVersionFilePath]];
        }
    }
}

#pragma mark private methods

- (int)cacheFileDuration:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *attributesRetrievalError = nil;
    NSDictionary *attributes = [fileManager attributesOfItemAtPath:path error:&attributesRetrievalError];
    if (!attributes) {
        NSLog(@"Error get attributes for file at %@: %@", path, attributesRetrievalError);
        return -1;
    }
    int seconds = -[[attributes fileModificationDate] timeIntervalSinceNow];
    return seconds;
}

- (NSString *)cacheFilePath {
    NSString *cacheFileName = [self cacheFileName];
    NSString *path = [self cacheBasePath];
    path = [path stringByAppendingPathComponent:cacheFileName];
    return path;
}

- (long long)cacheVersionFileContent {
    NSString *path = [self cacheVersionFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSNumber *version = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        return [version longLongValue];
    } else {
        return 0;
    }
}

- (NSString *)cacheVersionFilePath {
    NSString *cacheVersionFileName = [NSString stringWithFormat:@"%@.version", [self cacheFileName]];
    NSString *path = [self cacheBasePath];
    path = [path stringByAppendingPathComponent:cacheVersionFileName];
    return path;
}

- (NSString *)cacheBasePath {
    NSString *pathOfLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [pathOfLibrary stringByAppendingPathComponent:@"LazyRequestCache"];
    
    NSArray *filters = [[HINetworkConfig sharedInstance] cacheDirPathFilters];
    if (filters.count > 0) {
        for (id<HICacheDirPathFilterProtocol> f in filters) {
            path = [f filterCacheDirPath:path withRequest:self];
        }
    }

    [self checkDirectory:path];
    return path;
}

- (void)checkDirectory:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    // 检查是否存在此目录：不存在创建
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {
        [self createBaseDirectoryAtPath:path];
    } else {
        if (!isDir) {
            NSError *error = nil;
            [fileManager removeItemAtPath:path error:&error];
            [self createBaseDirectoryAtPath:path];
        }
    }
}

- (void)createBaseDirectoryAtPath:(NSString *)path {
    __autoreleasing NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
    if (error) {
        NSLog(@"Create cache directory failed, error = %@", error);
    } else {
        [HINetworkPrivate addDoNotBackupAttribute:path];
    }
}

- (NSString *)cacheFileName {
    NSString *requestURL = [self requestURL];
    NSString *baseURL = [HINetworkConfig sharedInstance].baseURL;
    id parameter = [self cacheFileNameFilterForRequestParameter:[self requestParameter]];
    NSString *requestInfo = [NSString stringWithFormat:@"Method:%ld Host:%@ Url:%@ Argument:%@ AppVersion:%@ Sensitive:%@",
                             (long)[self requestMethod], baseURL, requestURL,
                             parameter, [HINetworkPrivate appVersionString], [self cacheSensitiveData]];
    NSString *cacheFileName = [HINetworkPrivate md5StringFromString:requestInfo];
    return cacheFileName;
}

@end
