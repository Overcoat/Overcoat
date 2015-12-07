// OVCURLMatcher.m
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

#import "OVCURLMatcher.h"
#import <Mantle/Mantle.h>

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

@property (copy, nonatomic) NSString *basePath;
@property (nonatomic) OVCURLMatcherType type;
@property (copy, nonatomic) NSString *text;
@property (nonatomic) Class modelClass;
@property (strong, nonatomic) NSMutableArray OVCGenerics(OVCURLMatcher *) *children;

@end

@implementation OVCURLMatcher

- (instancetype)init {
    return [self initWithBasePath:nil modelClassesByPath:nil];
}

- (id)initWithBasePath:(NSString *)basePath
    modelClassesByPath:(NSDictionary OVCGenerics(NSString *, Class) *)modelClassesByPath {
    if (self = [super init]) {
        _type = OVCURLMatcherTypeNone;
        _children = [NSMutableArray array];

        _basePath = [basePath copy];

        [modelClassesByPath enumerateKeysAndObjectsUsingBlock:^(NSString *path, Class class, BOOL *stop) {
            [self addModelClass:class forPath:path sortChildren:NO];
        }];
        [self sortChildren];
    }
    return self;
}

#pragma mark - Matching

- (Class)modelClassForURL:(NSURL *)url {
    NSParameterAssert(url);

    NSString *path = url.path;
    if (self.basePath && [path hasPrefix:self.basePath]) {
        path = [path substringFromIndex:self.basePath.length];
    }
    path = [path stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
    NSArray *tokens = [path componentsSeparatedByString:@"/"];

    if (tokens.count == 0) {
        return self.modelClass;
    }

    // Go through tokens
    OVCURLMatcher *node = self;
    for (NSString *token in tokens) {
        NSArray OVCGenerics(OVCURLMatcher *) *childrenNodes = node.children;
        if (!childrenNodes) {
            break;
        }

        node = nil;
        for (OVCURLMatcher *childNode in childrenNodes) {
            switch (childNode.type) {
                case OVCURLMatcherTypeExact: {  // string like `statuses`
                    if ([childNode.text isEqualToString:token]) {
                        node = childNode;
                    }
                    break;
                }
                case OVCURLMatcherTypeNumber: {  // `#`
                    if (OVCTextOnlyContainsDigits(token)) {
                        node = childNode;
                    }
                    break;
                }
                case OVCURLMatcherTypeText: {  // `*`
                    node = childNode;
                    break;
                }
                case OVCURLMatcherTypeAny: {  // `**`
                    // `**` means that we shouldn't check further nodes (path components)
                    // so return directly.
                    return childNode.modelClass;
                }
                case OVCURLMatcherTypeNone: {
                    // Do nothing
                    break;
                }
            }
            if (node) {
                break;
            }
        }
        if (!node) {
            return nil;
        }
    }

    return node.modelClass;
}

#pragma mark - Debugging

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, type:%@, text:%@, modelClass:%@, children:%@>",
            self.class, self, @(self.type), self.text, NSStringFromClass(self.modelClass), self.children];
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

- (void)addModelClass:(Class)modelClass forPath:(NSString *)path {
    [self addModelClass:modelClass forPath:path sortChildren:YES];
}

- (void)addModelClass:(Class)modelClass forPath:(NSString *)path sortChildren:(BOOL)sortChildren {
    NSParameterAssert([modelClass conformsToProtocol:@protocol(MTLModel)]);
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

    node.modelClass = modelClass;

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
