//
//  OVCModelResponseSerializerTests.m
//  Overcoat
//
//  Created by guille on 01/02/14.
//  Copyright (c) 2014 Guillermo Gonzalez. All rights reserved.
//

#import "TestModel.h"

@interface OVCModelResponseSerializerTests : XCTestCase

@property (strong, nonatomic) OVCModelResponseSerializer *serializer;
@property (strong, nonatomic) NSHTTPURLResponse *response;
@property (strong, nonatomic) NSData *data;

@end

@implementation OVCModelResponseSerializerTests

- (void)setUp {
    [super setUp];
    
    self.serializer = [OVCModelResponseSerializer serializerWithModelClass:TestModel.class
                                                           responseKeyPath:@"data.object"];
    self.response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"http://test"]
                                                statusCode:200
                                               HTTPVersion:@"1.1"
                                              headerFields:@{@"Content-Type": @"text/json"}];
    
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"testResponse"
                                                                    ofType:@"json"];
    self.data = [NSData dataWithContentsOfFile:path];
}

- (void)tearDown {
    self.serializer = nil;
    self.response = nil;
    self.data = nil;
    
    [super tearDown];
}

- (void)testCoding {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.serializer];
    XCTAssertNotNil(data, @"should return the encoded data");
    
    OVCModelResponseSerializer *serializer = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    XCTAssertNotNil(serializer, @"should decode a serializer");
    XCTAssertEqual(self.serializer.modelClass, serializer.modelClass, @"modelClass should be encoded correctly");
    XCTAssertEqualObjects(self.serializer.responseKeyPath, serializer.responseKeyPath, @"responseKeyPath should be encoded correctly");
}

- (void)testCopying {
    OVCModelResponseSerializer *serializer = [self.serializer copy];
    XCTAssertEqual(self.serializer.modelClass, serializer.modelClass, @"modelClass should be copied");
    XCTAssertEqualObjects(self.serializer.responseKeyPath, serializer.responseKeyPath, @"responseKeyPath should be copied");
}

- (void)testSingleModelObjectSerialization {
    TestModel *object = [self.serializer responseObjectForResponse:self.response data:self.data error:NULL];
    TestModel *expectedObject = [TestModel testModelWithFirstName:@"Bruce" lastName:@"Wayne"];
    XCTAssertEqualObjects(expectedObject, object, @"");
}

- (void)testMultipleModelObjectSerialization {
    self.serializer.responseKeyPath = @"data.objects";
    NSArray *objects = [self.serializer responseObjectForResponse:self.response data:self.data error:NULL];
    
    NSArray *expectedObjects = @[
        [TestModel testModelWithFirstName:@"Tony" lastName:@"Stark"],
        [TestModel testModelWithFirstName:@"Bruce" lastName:@"Banner"],
    ];
    XCTAssertEqualObjects(expectedObjects, objects, @"");
}

- (void)testSerializationWithoutModelClass {
    self.serializer.modelClass = nil;
    id object = [self.serializer responseObjectForResponse:self.response data:self.data error:NULL];
    
    NSDictionary *expectedObject = @{
        @"first_name": @"Bruce",
        @"last_name": @"Wayne"
    };
    XCTAssertEqualObjects(expectedObject, object, @"");
}

@end
