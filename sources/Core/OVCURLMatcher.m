// OVCURLMatcher.m
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

#import "OVCURLMatcher.h"
#import <Mantle/Mantle.h>
#import <objc/runtime.h>

typedef NS_ENUM(NSInteger, OVCURLMatcherType) {  // The integer value is related to search order
    OVCURLMatcherTypeNone   = -1,
    OVCURLMatcherTypeExact  = 0,
    OVCURLMatcherTypeNumber = 1,
    OVCURLMatcherTypeText   = 2,
    OVCURLMatcherTypeAny    = 3,
};

static NSString *_Nullable NSStringFromOVCURLMatcherType(OVCURLMatcherType type) {
    switch (type) {
        case OVCURLMatcherTypeNone:
            return @"None";
        case OVCURLMatcherTypeExact:
            return @"Exact";
        case OVCURLMatcherTypeNumber:
            return @"Number";
        case OVCURLMatcherTypeText:
            return @"Text";
        case OVCURLMatcherTypeAny:
            return @"Any";
        default:
            return nil;
    }
}

static BOOL OVCTextOnlyContainsDigits(NSString *text) {
    static dispatch_once_t onceToken;
    static NSCharacterSet *notDigits;

    dispatch_once(&onceToken, ^{
        notDigits = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    });

	return [text rangeOfCharacterFromSet:notDigits].location == NSNotFound;
}

@interface OVCURLMatcher ()

@property (nonatomic, copy) NSString *basePath;
@property (nonatomic, assign) OVCURLMatcherType type;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) OVCURLMatcherNode *matcherNode;
@property (nonatomic, strong) NSMutableArray OVCGenerics(OVCURLMatcher *) *children;

@end

@interface OVCURLMatcherNode ()

@property (nonatomic, strong, readonly) OVCURLMatcherNodeBlock modelClassBlock;

@end

@implementation OVCURLMatcher

+ (instancetype)matcherWithBasePath:(OVC_NULLABLE NSString *)basePath
                 modelClassesByPath:(OVC_NULLABLE NSDictionary OVCGenerics(NSString *,id) *)modelClassesByPath {
    return [[self alloc] initWithBasePath:basePath modelClassesByPath:modelClassesByPath];
}

- (instancetype)initWithBasePath:(OVC_NULLABLE NSString *)basePath
              modelClassesByPath:(OVC_NULLABLE NSDictionary OVCGenerics(NSString *, id) *)modelClassesByPath {
    NSMutableDictionary<NSString *, OVCURLMatcherNode *> *matcherNodes = [[NSMutableDictionary alloc]
                                                                          initWithCapacity:modelClassesByPath.count];
    [modelClassesByPath enumerateKeysAndObjectsUsingBlock:^(NSString *path, id _ModelClass, BOOL *stop) {
        OVCURLMatcherNode *matcherNode;
        if ([_ModelClass isKindOfClass:[OVCURLMatcherNode class]]) {
            matcherNode = _ModelClass;
        } else if (OVC_IS_CLASS(_ModelClass)) {
            matcherNode = [OVCURLMatcherNode matcherNodeWithModelClass:_ModelClass];
        } else if ([_ModelClass isKindOfClass:[NSDictionary class]]) {
            matcherNode = [OVCURLMatcherNode matcherNodeWithModelClasses:_ModelClass];
        } else if ([_ModelClass isKindOfClass:[NSString class]]) {
            Class __ModelClass = NSClassFromString(_ModelClass);
            if (__ModelClass) {
                matcherNode = [OVCURLMatcherNode matcherNodeWithModelClass:__ModelClass];
            }
        }
        if (matcherNode) {
            matcherNodes[path] = matcherNode;
        } else {
            [NSException raise:NSInternalInconsistencyException
                        format:@"Got node with unknown type: %@", matcherNode];
        }
    }];
    return self = [self initWithBasePath:basePath matcherNodesByPath:matcherNodes];
}

- (instancetype)init {
    return [self initWithBasePath:nil matcherNodesByPath:nil];
}

+ (instancetype)matcherWithBasePath:(NSString *)basePath
                 matcherNodesByPath:(NSDictionary OVCGenerics(NSString *,OVCURLMatcherNode *) *)matcherNodes {
    return [[self alloc] initWithBasePath:basePath matcherNodesByPath:matcherNodes];
}

- (instancetype)initWithBasePath:(NSString *)basePath
              matcherNodesByPath:(NSDictionary OVCGenerics(NSString *, OVCURLMatcherNode *) *)matcherNodes {
    if (self = [super init]) {
        _type = OVCURLMatcherTypeNone;
        _children = [NSMutableArray array];

        _basePath = [basePath copy];

        [matcherNodes enumerateKeysAndObjectsUsingBlock:^(NSString *path, OVCURLMatcherNode *matcherNode, BOOL *stop) {
            NSAssert([matcherNode isKindOfClass:[OVCURLMatcherNode class]],
                     @"Expect %@, got %@", [OVCURLMatcherNode class], [matcherNode class]);
            [self addMatcherNode:matcherNode forPath:path sortChildren:NO];
        }];
        [self sortChildren];
    }
    return self;
}

#pragma mark - Matching

- (Class)modelClassForURLRequest:(NSURLRequest *)request andURLResponse:(NSHTTPURLResponse *)response {
    return [[self matcherNodeForPath:(response.URL ?: request.URL).path]
            modelClassForURLRequest:request andURLResponse:response];
}

- (Class)modelClassForURL:(NSURL *)url {
    return [[self matcherNodeForPath:url.path] modelClassForURLRequest:nil andURLResponse:nil];
}

- (OVCURLMatcherNode *)matcherNodeForPath:(NSString *)path {
    if (self.basePath && [path hasPrefix:self.basePath]) {
        path = [path substringFromIndex:self.basePath.length];
    }
    path = [path stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
    return [self _matcherNodeForPath:path];
}

- (OVCURLMatcherNode *)_matcherNodeForPath:(NSString *)path {
    // Split path in to tokens
    NSArray OVCGenerics(NSString *) *tokens = [path componentsSeparatedByString:@"/"];
    NSArray OVCGenerics(NSString *) *subTokens = [tokens subarrayWithRange:NSMakeRange(1, tokens.count-1)];
    NSString *firstToken = tokens.firstObject;
    NSString *subPath = [subTokens componentsJoinedByString:@"/"];

    OVCURLMatcherNode *__block resultMatcherNode = nil;
    [self.children enumerateObjectsUsingBlock:^(OVCURLMatcher *childMatcher, NSUInteger idx, BOOL *OVC__NONNULL stop) {
        // Find matched node in this level
        OVCURLMatcher *matchedMatcher = nil;
        switch (childMatcher.type) {
            case OVCURLMatcherTypeExact: {
                if ([childMatcher.text isEqualToString:firstToken]) {
                    matchedMatcher = childMatcher;
                }
                break;
            }
            case OVCURLMatcherTypeNumber: {
                if (OVCTextOnlyContainsDigits(firstToken)) {
                    matchedMatcher = childMatcher;
                }
                break;
            }
            case OVCURLMatcherTypeText: {
                matchedMatcher = childMatcher;
                break;
            }
            case OVCURLMatcherTypeAny: {
                // `**` means that we shouldn't check further nodes (path components), so return directly.
                // and it should be evaluated at the last.
                NSAssert(idx == self.children.count - 1,
                         @"Internal consistency error. `OVCURLMatcherTypeAny` should be tested at last.");
                resultMatcherNode = childMatcher.matcherNode;
            }
            case OVCURLMatcherTypeNone: {
                // Do nothing
                break;
            }
        }
        // Check children of this matched one
        if (!resultMatcherNode) {
            resultMatcherNode = (subTokens.count ?
                                 [matchedMatcher _matcherNodeForPath:subPath] : matchedMatcher.matcherNode);
        }
        *stop = resultMatcherNode != nil;
    }];
    return resultMatcherNode;
}

#pragma mark - Debugging

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, type:%@, text:%@, matcherNode:%@, children:%@>",
            self.class, self, @(self.type), self.text, self.matcherNode.description, self.children];
}

- (NSString *)debugDescription {
    @autoreleasepool {
        NSMutableString *result = [NSMutableString string];
        [result appendFormat:@"<%@>", NSStringFromOVCURLMatcherType(self.type)];
        if (self.basePath) {
            [result appendFormat:@" basePath: %@", self.basePath];
        }
        if (self.text) {
            [result appendFormat:@" text: %@", self.text];
        }

        if (self.children.count) {
            [result appendString:@"\n"];
            for (OVCURLMatcher *matcher in self.children) {
                NSArray OVCGenerics(NSString *) *lines = [matcher.debugDescription componentsSeparatedByString:@"\n"];
                [lines enumerateObjectsUsingBlock:^(NSString *line, NSUInteger idx, BOOL *stop) {
                    [result appendFormat:@"    %@\n", line];
                }];
            }
        }

        return [NSString stringWithString:[result
                                           stringByTrimmingCharactersInSet:[NSCharacterSet
                                                                            whitespaceAndNewlineCharacterSet]]];
    }
}

#pragma mark - Setup

- (void)addModelClass:(Class)ModelClass forPath:(NSString *)path {
    [self addMatcherNode:[OVCURLMatcherNode matcherNodeWithModelClass:ModelClass] forPath:path sortChildren:YES];
}

- (void)addMatcherNode:(OVCURLMatcherNode *)matcherNode forPath:(NSString *)path {
    return [self addMatcherNode:matcherNode forPath:path sortChildren:YES];
}

- (void)addMatcherNode:(OVCURLMatcherNode *)matcherNode forPath:(NSString *)path sortChildren:(BOOL)sortChildren {
    NSParameterAssert(path);

    NSArray *tokens = nil;

	if (path.length) {
		NSString *newPath = path;
		if ([path hasPrefix:@"/"]) {
			newPath = [path substringFromIndex:1];
		}

		tokens = [newPath componentsSeparatedByString:@"/"];
	}

    OVCURLMatcher *node = self;
    for (NSString *token in tokens) {
        NSMutableArray *children = node.children;
		OVCURLMatcher *existingChild = nil;

		for (OVCURLMatcher *child in children) {
			if ([token isEqualToString:child.text]) {
				node = child;
				existingChild = node;
				break;
			}
		}

        if (!existingChild) {
			existingChild = [[OVCURLMatcher alloc] init];

			if ([token isEqualToString:@"#"]) {
				existingChild.type = OVCURLMatcherTypeNumber;
			} else if ([token isEqualToString:@"*"]) {
				existingChild.type = OVCURLMatcherTypeText;
            } else if ([token isEqualToString:@"**"]) {
                existingChild.type = OVCURLMatcherTypeAny;
			} else {
				existingChild.type = OVCURLMatcherTypeExact;
			}

			existingChild.text = token;
			[node.children addObject:existingChild];
			node = existingChild;
		}
    }

    node.matcherNode = matcherNode;

    if (sortChildren) {
        [self sortChildren];
    }
}

- (void)sortChildren {
    NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"type" ascending:YES];
    [self.children sortUsingDescriptors:@[sd]];

    for (OVCURLMatcher *child in self.children) {
        [child sortChildren];
    }
}

@end

@implementation OVCURLMatcherNode

+ (instancetype)matcherNodeWithModelClass:(Class)ModelClass {
    NSParameterAssert([ModelClass conformsToProtocol:@protocol(MTLModel)]);
    return [self matcherNodeWithBlock:^Class(NSURLRequest *req, NSHTTPURLResponse *res) {
        return ModelClass;
    }];
}

+ (instancetype)matcherNodeWithResponseCode:(NSDictionary OVCGenerics(id, Class) *)modelClasses {
#if DEBUG
    [modelClasses enumerateKeysAndObjectsUsingBlock:^(id key, Class ModelClass, BOOL * _Nonnull stop) {
        NSParameterAssert([ModelClass conformsToProtocol:@protocol(MTLModel)]);
    }];
#endif
    return [self matcherNodeWithBlock:^Class(NSURLRequest *req, NSHTTPURLResponse *res) {
        return (res ? modelClasses[@(res.statusCode)] : nil) ?: modelClasses[@"*"];
    }];
}

+ (instancetype)matcherNodeWithRequestMethod:(NSDictionary OVCGenerics(NSString *, Class) *)modelClasses {
#if DEBUG
    [modelClasses enumerateKeysAndObjectsUsingBlock:^(NSString *key, Class ModelClass, BOOL * _Nonnull stop) {
        NSParameterAssert([ModelClass conformsToProtocol:@protocol(MTLModel)]);
    }];
#endif
    return [self matcherNodeWithBlock:^Class(NSURLRequest *req, NSHTTPURLResponse *res) {
        return (req.HTTPMethod ? modelClasses[req.HTTPMethod] : nil) ?: modelClasses[@"*"];
    }];
}

+ (instancetype)matcherNodeWithModelClasses:(NSDictionary OVCGenerics(id, Class) *)modelClasses {
#if DEBUG
    [modelClasses enumerateKeysAndObjectsUsingBlock:^(id key, Class ModelClass, BOOL * _Nonnull stop) {
        NSParameterAssert([ModelClass conformsToProtocol:@protocol(MTLModel)]);
    }];
#endif
    return [self matcherNodeWithBlock:^Class(NSURLRequest *req, NSHTTPURLResponse *res) {
        return (((req.HTTPMethod ? modelClasses[req.HTTPMethod] : nil) ?:
                 (res ? modelClasses[@(res.statusCode)] : nil)) ?:
                modelClasses[@"*"]);
    }];
}

+ (instancetype)matcherNodeWithBlock:(OVCURLMatcherNodeBlock)block {
    return [[OVCURLMatcherNode alloc] initWithBlock:block];
}

- (instancetype)initWithBlock:(OVCURLMatcherNodeBlock)block {
    if (self = [super init]) {
        _modelClassBlock = block;
    }
    return self;
}

- (OVC_NULLABLE Class)modelClassForURLRequest:(NSURLRequest *)request andURLResponse:(NSHTTPURLResponse *)urlResponse {
    Class OVC__NULLABLE ModelClass = self.modelClassBlock(request, urlResponse);
    NSAssert(!ModelClass || [ModelClass conformsToProtocol:@protocol(MTLModel)],
             @"%@ doesn't conform to protocol %@", ModelClass, @protocol(MTLModel));
    return ModelClass;
}

@end
