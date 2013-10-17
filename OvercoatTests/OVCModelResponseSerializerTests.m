//
//  OVCModelResponseSerializerTests.m
//  Overcoat
//
//  Created by guille on 09/10/13.
//  Copyright (c) 2013 Guillermo Gonzalez. All rights reserved.
//

#import "TestModel.h"

@interface OVCModelResponseSerializerTests : SenTestCase

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
    STAssertNotNil(data, @"should return the encoded data");
    
    OVCModelResponseSerializer *serializer = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    STAssertNotNil(serializer, @"should decode a serializer");
    STAssertEquals(serializer.modelClass, self.serializer.modelClass, @"modelClass should be encoded correctly");
    STAssertEqualObjects(serializer.responseKeyPath, self.serializer.responseKeyPath, @"responseKeyPath should be encoded correctly");
}

- (void)testCopying {
    OVCModelResponseSerializer *serializer = [self.serializer copy];
    STAssertEquals(serializer.modelClass, self.serializer.modelClass, @"modelClass should be copied");
    STAssertEqualObjects(serializer.responseKeyPath, self.serializer.responseKeyPath, @"responseKeyPath should be copied");
}

- (void)testSingleModelObjectSerialization {
    TestModel *object = [self.serializer responseObjectForResponse:self.response data:self.data error:NULL];
    
    TestModel *expectedObject = [TestModel testModelWithFirstName:@"Bruce" lastName:@"Wayne"];
    STAssertEqualObjects(object, expectedObject, nil);
}

- (void)testMultipleModelObjectSerialization {
    self.serializer.responseKeyPath = @"data.objects";
    NSArray *objects = [self.serializer responseObjectForResponse:self.response data:self.data error:NULL];
    
    NSArray *expectedObjects = @[
            [TestModel testModelWithFirstName:@"Tony" lastName:@"Stark"],
            [TestModel testModelWithFirstName:@"Bruce" lastName:@"Banner"],
    ];
    STAssertEqualObjects(objects, expectedObjects, nil);
}

- (void)testSerializationWithoutModelClass {
    self.serializer.modelClass = nil;
    id object = [self.serializer responseObjectForResponse:self.response data:self.data error:NULL];
    
    NSDictionary *expectedObject = @{
            @"first_name": @"Bruce",
            @"last_name": @"Wayne"
    };
    STAssertEqualObjects(object, expectedObject, nil);
}

@end
