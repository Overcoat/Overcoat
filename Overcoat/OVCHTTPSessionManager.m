// OVCHTTPSessionManager.m
// 
// Copyright (c) 2014 Guillermo Gonzalez
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "OVCHTTPSessionManager.h"
#import "OVCResponse.h"
#import "OVCModelResponseSerializer.h"
#import "OVCURLMatcher.h"

#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000) || (defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 1090)

@interface OVCHTTPSessionManager ()

@property (strong, nonatomic) NSManagedObjectContext *backgroundContext;
@property (strong, nonatomic) id contextObserver;

@end

@implementation OVCHTTPSessionManager

+ (Class)responseClass {
    return [OVCResponse class];
}

+ (Class)errorModelClass {
    return Nil;
}

+ (NSDictionary *)modelClassesByResourcePath {
    [NSException raise:NSInvalidArgumentException
                format:@"[%@ +%@] should be overridden by subclass", NSStringFromClass(self), NSStringFromSelector(_cmd)];
    return nil; // Not reached
}

- (void)dealloc {
    if (self.contextObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.contextObserver];
    }
}

- (id)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    return [self initWithBaseURL:url managedObjectContext:nil sessionConfiguration:configuration];
}

- (id)initWithBaseURL:(NSURL *)url
 managedObjectContext:(NSManagedObjectContext *)context
 sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    
    if (self) {
        _managedObjectContext = context;
        
        [self setupBackgroundContext];
        [self setupResponseSerializer];
    }
    
    return self;
}

#pragma mark - Making requests

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                   completion:(void (^)(id, NSError *))completion
{
    NSMutableURLRequest *request = [self.requestSerializer
                                    requestWithMethod:@"GET"
                                            URLString:[[NSURL URLWithString:URLString
                                                              relativeToURL:self.baseURL] absoluteString]
                                           parameters:parameters
                                                error:nil];
    
    NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (completion) completion(responseObject, error);
    }];
    
    [task resume];
    
    return task;
}

- (NSURLSessionDataTask *)HEAD:(NSString *)URLString
                    parameters:(id)parameters
                    completion:(void (^)(id, NSError *))completion
{
    NSMutableURLRequest *request = [self.requestSerializer
                                    requestWithMethod:@"HEAD"
                                            URLString:[[NSURL URLWithString:URLString
                                                              relativeToURL:self.baseURL] absoluteString]
                                           parameters:parameters
                                                error:nil];
    
    NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id __unused responseObject, NSError *error) {
        if (completion) completion(responseObject, error);
    }];
    
    [task resume];
    
    return task;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                    completion:(void (^)(id, NSError *))completion
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    
    NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (completion) completion(responseObject, error);
    }];
    
    [task resume];
    
    return task;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
     constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
                    completion:(void (^)(id, NSError *))completion
{
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters constructingBodyWithBlock:block error:nil];
    
    NSURLSessionDataTask *task = [self uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (completion) completion(responseObject, error);
    }];
    
    [task resume];
    
    return task;
}

- (NSURLSessionDataTask *)PUT:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                   completion:(void (^)(id, NSError *))completion
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"PUT" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    
    NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (completion) completion(responseObject, error);
    }];
    
    [task resume];
    
    return task;
}

- (NSURLSessionDataTask *)PATCH:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                     completion:(void (^)(id, NSError *))completion
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"PATCH" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    
    NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (completion) completion(responseObject, error);
    }];
    
    [task resume];
    
    return task;
}

- (NSURLSessionDataTask *)DELETE:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                      completion:(void (^)(id, NSError *))completion
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"DELETE" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    
    NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (completion) completion(responseObject, error);
    }];
    
    [task resume];
    
    return task;
}

#pragma mark - Private

- (void)setupResponseSerializer {
    OVCURLMatcher *matcher = [[OVCURLMatcher alloc] initWithBasePath:[self.baseURL path]
                                                  modelClassesByPath:[[self class] modelClassesByResourcePath]];
    self.responseSerializer = [OVCModelResponseSerializer serializerWithURLMatcher:matcher
                                                              managedObjectContext:self.backgroundContext
                                                                     responseClass:[[self class] responseClass]
                                                                   errorModelClass:[[self class] errorModelClass]];
}

- (void)setupBackgroundContext {
    if (self.managedObjectContext == nil) {
        return;
    }
    
    if ([self.managedObjectContext concurrencyType] == NSPrivateQueueConcurrencyType) {
        self.backgroundContext = self.managedObjectContext;
        return;
    }
    
    self.backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [self.backgroundContext setPersistentStoreCoordinator:self.managedObjectContext.persistentStoreCoordinator];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSManagedObjectContext *context = self.managedObjectContext;
    
    self.contextObserver = [notificationCenter addObserverForName:NSManagedObjectContextDidSaveNotification
                                                           object:self.backgroundContext
                                                            queue:nil
                                                       usingBlock:^(NSNotification *note) {
                                                           [context performBlock:^{
                                                               [context mergeChangesFromContextDidSaveNotification:note];
                                                           }];
                                                       }];
}

@end

#endif
