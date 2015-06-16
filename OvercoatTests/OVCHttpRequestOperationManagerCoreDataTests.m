//
//  OVCHttpRequestOperationManagerCoreDataTests.m
//  OvercoatApp
//
//  Created by sodas on 6/15/15.
//
//

#import <XCTest/XCTest.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <Overcoat/Overcoat.h>
#import "OVCTestModel.h"

#pragma mark - TestClient

@interface OVCHTTPRequestOperationCoreDataTestClient : OVCHTTPRequestOperationManager

@end

@implementation OVCHTTPRequestOperationCoreDataTestClient

+ (Class)errorModelClass {
    return [OVCErrorModel class];
}

+ (NSDictionary *)modelClassesByResourcePath {
    return @{
             @"model/#": [OVCTestModel class],
             @"models": [OVCTestModel class]
             };
}

@end

#pragma mark - Tests

@interface OVCHttpRequestOperationManagerCoreDataTests : XCTestCase

@property (strong, nonatomic) OVCHTTPRequestOperationCoreDataTestClient *client;

@end

@implementation OVCHttpRequestOperationManagerCoreDataTests

- (void)testCoreDataSerialization {
    // Setup the Core Data stack

    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:@[bundle]];
    OVCManagedStore *store = [OVCManagedStore managedStoreWithModel:model];

    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [context setPersistentStoreCoordinator:store.persistentStoreCoordinator];

    // Observe changes in Core Data

    NSNotification * __block notification = nil;
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextObjectsDidChangeNotification
                                                                    object:context
                                                                     queue:nil
                                                                usingBlock:^(NSNotification *note) {
                                                                    notification = note;
                                                                }];

    // Setup client

    self.client = [[OVCHTTPRequestOperationCoreDataTestClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://test/v1/"]
                                 managedObjectContext:context];

    // Setup HTTP stub

    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        NSString * path = OHPathForFile(@"models.json", self.class);
        return [OHHTTPStubsResponse responseWithFileAtPath:path
                                                statusCode:200
                                                   headers:@{@"Content-Type": @"application/json"}];
    }];

    // Get models

    XCTestExpectation *completed = [self expectationWithDescription:@"completed"];
    OVCResponse * __block response = nil;
    NSError * __block error = nil;

    [self.client GET:@"models" parameters:nil completion:^(OVCResponse *r, NSError *e) {
        response = r;
        error = e;
        [completed fulfill];
    }];

    [self waitForExpectationsWithTimeout:1 handler:nil];

    XCTAssertNil(error, @"should not return an error");
    XCTAssertTrue([response.result isKindOfClass:[NSArray class]], @"should return an array of test models");
    XCTAssertTrue([[response.result firstObject] isKindOfClass:[OVCTestModel class]], @"should return an array of test models");

    NSDictionary *userInfo = [notification userInfo];
    NSSet *objects = userInfo[NSInsertedObjectsKey];

    XCTAssertEqual(2U, [objects count], @"should insert two objects");

    for (NSManagedObject *object in objects) {
        XCTAssertEqualObjects(@"TestModel", [[object entity] name], @"should insert TestModel objects");
    }
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}

@end
