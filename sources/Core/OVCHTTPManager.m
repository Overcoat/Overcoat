// OVCHTTPManager.m
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

#import "OVCHTTPManager_Internal.h"
#import "OVCModelResponseSerializer.h"
#import "OVCURLMatcher.h"
#import "OVCResponse.h"
#import "OVCHTTPManager.h"

OVC_EXTERN
OVCURLMatcher *OVCHTTPManagerCreateURLMatcher(id<OVCHTTPManager> httpManager) {
    return [[OVCURLMatcher alloc] initWithBasePath:httpManager.baseURL.path
                                modelClassesByPath:[[httpManager class] modelClassesByResourcePath]];
}

OVC_EXTERN
OVCURLMatcher * OVC__NULLABLE OVCHTTPManagerCreateResponseClassURLMatcher(id<OVCHTTPManager> httpManager) {
    OVCURLMatcher *responseClassMatcher = nil;

    NSDictionary OVCGenerics(NSString *, Class) *responseClassesByResourcePath = [[httpManager class]
                                                                                  responseClassesByResourcePath];
    if (responseClassesByResourcePath) {
#if DEBUG
        // Check if all the classes used in responseClassesByResourcePath are subclasses of OVCResponse
        [responseClassesByResourcePath
         enumerateKeysAndObjectsUsingBlock:^(NSString *path, Class responseClass, BOOL *stop) {
             if (![responseClass isSubclassOfClass:[OVCResponse class]]) {
                 [NSException
                  raise:NSInternalInconsistencyException
                  format:@"%@ is not a subclass of %@",
                  NSStringFromClass(responseClass), NSStringFromClass([OVCResponse class])];
             }
         }];
#endif
        responseClassMatcher = [[OVCURLMatcher alloc] initWithBasePath:httpManager.baseURL.path
                                                    modelClassesByPath:responseClassesByResourcePath];
    }
    return responseClassMatcher;
}

OVC_EXTERN
OVCModelResponseSerializer *OVCHTTPManagerCreateModelResponseSerializer(id<OVCHTTPManager> httpManager) {
    return [OVCModelResponseSerializer serializerWithURLMatcher:OVCHTTPManagerCreateURLMatcher(httpManager)
                                        responseClassURLMatcher:OVCHTTPManagerCreateResponseClassURLMatcher(httpManager)
                                                  responseClass:[[httpManager class] responseClass]
                                                errorModelClass:[[httpManager class] errorModelClass]];
}
