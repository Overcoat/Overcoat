//
//  OVCModelResponseSerializerTests.m
//  Overcoat
//
//  Created by guille on 01/02/14.
//  Copyright (c) 2014 Guillermo Gonzalez. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Overcoat/Overcoat.h>

#import "OVCTestModel.h"
#import "OVCTestResponse.h"

@interface OVCModelResponseSerializerTests : XCTestCase

@property (strong, nonatomic) OVCModelResponseSerializer *serializer;

@end

@implementation OVCModelResponseSerializerTests

- (void)setUp {
    [super setUp];
    
    NSDictionary *modelClassesByPath = @{
        @"test": [OVCTestModel class],
        @"alternative": [OVCAlternativeModel class],
        @"paginated": [OVCAlternativeModel class]
    };
    
    OVCURLMatcher *matcher = [[OVCURLMatcher alloc] initWithBasePath:nil
                                                  modelClassesByPath:modelClassesByPath];

#if OVERCOAT_SUPPORT_COREDATA
    self.serializer = [OVCManagedModelResponseSerializer serializerWithURLMatcher:matcher
                                                          responseClassURLMatcher:nil
                                                             managedObjectContext:nil
                                                                    responseClass:[OVCResponse class]
                                                                  errorModelClass:[OVCErrorModel class]];
#else
    self.serializer = [OVCModelResponseSerializer serializerWithURLMatcher:matcher
                                                   responseClassURLMatcher:nil
                                                             responseClass:[OVCResponse class]
                                                           errorModelClass:[OVCErrorModel class]];
#endif
}

- (void)tearDown {
    self.serializer = nil;
    
    [super tearDown];
}

#if !OVERCOAT_SUPPORT_COREDATA
- (void)testSuccessResponseSerialization {
    NSData *data = [NSJSONSerialization dataWithJSONObject:@{
                        @"name": @"Iron Man",
                        @"realName": @"Anthony Stark"
                    } options:0 error:NULL];
    NSURLResponse *URLResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"http://example.com/test"]
                                                             statusCode:200
                                                            HTTPVersion:@"1.1"
                                                           headerFields:@{@"Content-Type": @"text/json"}];
    OVCResponse *response = [self.serializer responseObjectForResponse:URLResponse data:data error:NULL];
    
    XCTAssertTrue([response isKindOfClass:[OVCResponse class]], @"should return a OVCResponse instance");
    XCTAssertTrue([response.result isKindOfClass:[OVCTestModel class]], @"should return a OVCTestModel result");
}

- (void)testErrorResponseSerialization {
    NSData *data = [NSJSONSerialization dataWithJSONObject:@{
                        @"status": @"failed",
                        @"code": @97,
                        @"message": @"Missing signature"
                    } options:0 error:NULL];
    NSURLResponse *URLResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"http://example.com/test"]
                                                             statusCode:401
                                                            HTTPVersion:@"1.1"
                                                           headerFields:@{@"Content-Type": @"text/json"}];
    OVCResponse *response = [self.serializer responseObjectForResponse:URLResponse data:data error:NULL];
    
    XCTAssertTrue([response isKindOfClass:[OVCResponse class]], @"should return a OVCResponse instance");
    XCTAssertTrue([response.result isKindOfClass:[OVCErrorModel class]], @"should return a OVCErrorModel result");
}

#else
- (void)testManagedObjectModelSerialization {
    // Setup the Core Data stack
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:@[bundle]];
    OVCManagedStore *store = [OVCManagedStore managedStoreWithModel:model];
    
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [context setPersistentStoreCoordinator:store.persistentStoreCoordinator];
    
    // Setup the serializer
    
    OVCURLMatcher *matcher = self.serializer.URLMatcher;
    self.serializer = [OVCManagedModelResponseSerializer serializerWithURLMatcher:matcher
                                                          responseClassURLMatcher:nil
                                                             managedObjectContext:context
                                                                    responseClass:[OVCResponse class]
                                                                  errorModelClass:[OVCErrorModel class]];
    
    // Serialize successful response
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:@{
                        @"offset": @0,
                        @"limit": @100,
                        @"objects": @[
                            @{
                                @"name": @"Iron Man",
                                @"realName": @"Anthony Stark"
                            },
                            @{
                                @"name": @"Batman",
                                @"realName": @"Bruce Wayne"
                            }
                        ]
                    } options:0 error:NULL];
    
    NSURLResponse *URLResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"http://example.com/paginated"]
                                                             statusCode:200
                                                            HTTPVersion:@"1.1"
                                                           headerFields:@{@"Content-Type": @"text/json"}];
    
    OVCResponse *response = [self.serializer responseObjectForResponse:URLResponse data:data error:NULL];
    
    XCTAssertTrue([response isKindOfClass:[OVCResponse class]], @"should return a OVCResponse instance");
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"TestModel"];
    NSArray *objects = [context executeFetchRequest:fetchRequest error:NULL];
    
    XCTAssertEqual(2U, [objects count], @"should return two objects");
    
    // Serialize error response (should not be persisted)
    
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextObjectsDidChangeNotification
                                                                    object:context
                                                                     queue:nil
                                                                usingBlock:^(NSNotification *note) {
                                                                    XCTFail(@"should ignore error responses");
                                                                }];
    
    data = [NSJSONSerialization dataWithJSONObject:@{
                @"status": @"failed",
                @"code": @97,
                @"message": @"Missing signature"
            } options:0 error:NULL];
    URLResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"http://example.com/test"]
                                              statusCode:401
                                             HTTPVersion:@"1.1"
                                            headerFields:@{@"Content-Type": @"text/json"}];
    response = [self.serializer responseObjectForResponse:URLResponse data:data error:NULL];
    
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}
#endif

@end
