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

typedef NS_ENUM(NSInteger, OVCURLMatcherType) {
    OVCURLMatcherTypeNone   = -1,
    OVCURLMatcherTypeExact  = 0,
    OVCURLMatcherTypeNumber = 1,
    OVCURLMatcherTypeText   = 2,
};

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
@property (strong, nonatomic) NSMutableArray *children;

@end

@implementation OVCURLMatcher

#pragma mark - Lifecycle

- (id)init {
    self = [super init];
    
    if (self) {
        _type = OVCURLMatcherTypeNone;
        _children = [NSMutableArray array];
    }
    
    return self;
}

- (id)initWithBasePath:(NSString *)basePath modelClassesByPath:(NSDictionary *)modelClassesByPath {
    self = [self init];
    
    if (self) {
        _basePath = [basePath copy];
        
        [modelClassesByPath enumerateKeysAndObjectsUsingBlock:^(NSString *path, Class class, BOOL *stop) {
            [self addModelClass:class forPath:path];
        }];
    }
    
    return self;
}

#pragma mark - Matching

- (Class)modelClassForURL:(NSURL *)url {
    NSParameterAssert(url);

    NSString *path = [url path];

    if (self.basePath && [path hasPrefix:self.basePath]) {
        path = [path substringFromIndex:[self.basePath length]];
    }

    path = [path stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];

    NSArray *pathComponents = [path componentsSeparatedByString:@"/"];

    if ([pathComponents count] == 0) {
        return self.modelClass;
    }

    OVCURLMatcher *node = self;

    for (NSString *u in pathComponents) {
        NSArray *list = node.children;

        if (!list) break;

        node = nil;

        for (OVCURLMatcher *n in list) {
            switch (n.type) {
                case OVCURLMatcherTypeExact:
                    if ([n.text isEqualToString:u]) {
                        node = n;
                    }
                    break;

                case OVCURLMatcherTypeNumber:
                    if (OVCTextOnlyContainsDigits(u)) {
                        node = n;
                    }
                    break;

                case OVCURLMatcherTypeText:
                    node = n;
                    break;

                case OVCURLMatcherTypeNone:
                    // Do nothing
                    break;
            }

            if (node) break;
        }

        if (!node) return nil;
    }

    return node.modelClass;
}

#pragma mark - Debugging

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, type:%@, text:%@, modelClass:%@, children:%@>",
            self.class, self, @(self.type), self.text, NSStringFromClass(self.modelClass), self.children];
}

#pragma mark - Private

- (void)addModelClass:(Class)modelClass forPath:(NSString *)path {
    NSParameterAssert([modelClass isSubclassOfClass:[MTLModel class]]);
    NSParameterAssert(path);
    
    NSArray *tokens = nil;
    
	if ([path length]) {
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
			} else {
				existingChild.type = OVCURLMatcherTypeExact;
			}
            
			existingChild.text = token;
			[node.children addObject:existingChild];
			node = existingChild;
		}
    }
    
    node.modelClass = modelClass;
}

@end
