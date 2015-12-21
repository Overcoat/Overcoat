//
//  OVCModelResponseSerializerCoreDataTests.m
//  Overcoat
//
//  Created by sodas on 11/11/15.
//
//

#import <XCTest/XCTest.h>
#import <Overcoat/Overcoat.h>
#import <OvercoatCoreData/OvercoatCoreData.h>
#import "OVCCoreDataTestModel.h"

@interface OVCModelResponseSerializerCoreDataTests : XCTestCase

@property (strong, nonatomic) OVCModelResponseSerializer *serializer;
@property (strong, nonatomic) NSManagedObjectContext *context;

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

    // Setup the Core Data stack
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:@[bundle]];
    OVCManagedStore *store = [OVCManagedStore managedStoreWithModel:model];

    self.context = [[NSManagedObjectContext alloc]
                    initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.context.persistentStoreCoordinator = store.persistentStoreCoordinator;

    // Setup the serializer

    self.serializer = [OVCManagedModelResponseSerializer serializerWithURLMatcher:matcher
                                                                    responseClass:[OVCResponse class]
                                                                  errorModelClass:[OVCErrorModel class]
                                                             managedObjectContext:self.context];
}

- (void)tearDown {
    self.serializer = nil;
    self.context = nil;

    [super tearDown];
}

- (void)testManagedObjectModelSerialization {
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
    NSArray *objects = [self.context executeFetchRequest:fetchRequest error:nil];

    XCTAssertEqual(2U, objects.count, @"should return two objects");

    // Serialize error response (should not be persisted)

    id observer = [[NSNotificationCenter defaultCenter]
                   addObserverForName:NSManagedObjectContextObjectsDidChangeNotification
                   object:self.context
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
