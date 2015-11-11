//
//  OVCModelResponseSerializerCoreDataTests.m
//  Overcoat
//
//  Created by sodas on 11/11/15.
//
//

#import <XCTest/XCTest.h>
#import <Overcoat/Overcoat.h>
#import "OVCCoreDataTestModel.h"

@interface OVCModelResponseSerializerCoreDataTests : XCTestCase

@property (strong, nonatomic) OVCModelResponseSerializer *serializer;

@end

@implementation OVCModelResponseSerializerCoreDataTests

- (void)setUp {
    [super setUp];

    NSDictionary *modelClassesByPath = @{
        @"test": [OVCManagedTestModel class],
        @"alternative": [OVCManagedAlternativeModel class],
        @"paginated": [OVCManagedAlternativeModel class]
    };

    OVCURLMatcher *matcher = [[OVCURLMatcher alloc] initWithBasePath:nil
                                                  modelClassesByPath:modelClassesByPath];

    self.serializer = [OVCManagedModelResponseSerializer serializerWithURLMatcher:matcher
                                                          responseClassURLMatcher:nil
                                                             managedObjectContext:nil
                                                                    responseClass:[OVCResponse class]
                                                                  errorModelClass:[OVCErrorModel class]];
}

- (void)tearDown {
    self.serializer = nil;

    [super tearDown];
}

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
                                                             } options:0 error:nil];

    NSURLResponse *URLResponse = [[NSHTTPURLResponse alloc]
                                  initWithURL:[NSURL URLWithString:@"http://example.com/paginated"]
                                  statusCode:200
                                  HTTPVersion:@"1.1"
                                  headerFields:@{@"Content-Type": @"text/json"}];

    OVCResponse *response = [self.serializer responseObjectForResponse:URLResponse data:data error:nil];

    XCTAssertTrue([response isKindOfClass:[OVCResponse class]], @"should return a OVCResponse instance");

    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"TestModel"];
    NSArray *objects = [context executeFetchRequest:fetchRequest error:nil];

    XCTAssertEqual(2U, [objects count], @"should return two objects");

    // Serialize error response (should not be persisted)

    id observer = [[NSNotificationCenter defaultCenter]
                   addObserverForName:NSManagedObjectContextObjectsDidChangeNotification
                   object:context
                   queue:nil
                   usingBlock:^(NSNotification *note) {
                       XCTFail(@"should ignore error responses");
                   }];
    
    data = [NSJSONSerialization dataWithJSONObject:@{
                                                     @"status": @"failed",
                                                     @"code": @97,
                                                     @"message": @"Missing signature"
                                                     } options:0 error:nil];
    URLResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"http://example.com/test"]
                                              statusCode:401
                                             HTTPVersion:@"1.1"
                                            headerFields:@{@"Content-Type": @"text/json"}];
    response = [self.serializer responseObjectForResponse:URLResponse data:data error:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}

@end
