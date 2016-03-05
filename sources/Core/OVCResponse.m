// OVCResponse.m
//
// Copyright (c) 2013-2016 Overcoat Team
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

#import "OVCResponse.h"
#import "NSDictionary+Overcoat.h"

@interface OVCResponse OVCGenerics(ResultType) ()

@property (strong, nonatomic, readwrite, OVC_NULLABLE) NSHTTPURLResponse *HTTPResponse;
@property (strong, nonatomic, readwrite) OVCGenericType(ResultType, id) result;
@property (strong, nonatomic, readwrite) Class resultClass;

@end

@implementation OVCResponse

+ (NSString *)resultKeyPathForJSONDictionary:(NSDictionary *)JSONDictionary {
    return nil;
}

+ (instancetype)responseWithHTTPResponse:(NSHTTPURLResponse *)HTTPResponse
                              JSONObject:(id)JSONObject
                             resultClass:(Class)resultClass
                                   error:(NSError *__autoreleasing *)error {
    OVCResponse *response = nil;
    id result = JSONObject;

    if ([JSONObject isKindOfClass:[NSDictionary class]]) {
        response = [MTLJSONAdapter modelOfClass:self fromJSONDictionary:JSONObject error:error];
        NSString *resultKeyPath = [[response class] resultKeyPathForJSONDictionary:JSONObject];
        if (resultKeyPath) {
            result = [(NSDictionary *)JSONObject ovc_objectForKeyPath:resultKeyPath];
        } else {
            response = [[self alloc] init];
        }
    } else {
        response = [[self alloc] init];
    }

    if (response == nil) {
        return nil;
    }

    response.HTTPResponse = HTTPResponse;
    response->_rawResult = JSONObject;

    if (result != nil) {
        if (resultClass != Nil) {
            NSValueTransformer *valueTransformer = nil;

            if ([result isKindOfClass:[NSDictionary class]]) {
                valueTransformer = [MTLJSONAdapter dictionaryTransformerWithModelClass:resultClass];
            } else if ([result isKindOfClass:[NSArray class]]) {
                valueTransformer = [MTLJSONAdapter arrayTransformerWithModelClass:resultClass];
            }

            if ([valueTransformer conformsToProtocol:@protocol(MTLTransformerErrorHandling)]) {
                BOOL success = NO;
                result = [(NSValueTransformer<MTLTransformerErrorHandling> *)valueTransformer transformedValue:result
                                                                                                       success:&success
                                                                                                         error:error];
                if (!success) {
                    result = nil;
                }
            } else {
                result = [valueTransformer transformedValue:result];
            }
        }

        response.result = result;
    }

    response.resultClass = resultClass;
    return response;
}

#pragma mark - Mantle

+ (MTLPropertyStorage)storageBehaviorForPropertyWithKey:(NSString *)propertyKey {
    if ([propertyKey isEqualToString:@"rawResult"]) {
        return MTLPropertyStorageNone;
    } else {
        return [super storageBehaviorForPropertyWithKey:propertyKey];
    }
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{};
}

#pragma mark - deprecated

+ (instancetype)responseWithHTTPResponse:(NSHTTPURLResponse *)HTTPResponse
                              JSONObject:(id)JSONObject
                             resultClass:(Class)resultClass {
    return [self responseWithHTTPResponse:HTTPResponse JSONObject:JSONObject resultClass:resultClass error:nil];
}

@end
