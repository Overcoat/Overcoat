//
//  OVCQueryTests.m
//  Overcoat
//
//  Created by guille on 13/05/13.
//  Copyright (c) 2013 Guillermo Gonzalez. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "OVCQuery.h"
#import "OVCMultipartPart.h"
#import "TestModel.h"

@interface OVCQueryTests : SenTestCase

@property (strong, nonatomic) OVCQuery *query;

@end

@implementation OVCQueryTests

- (void)setUp {
    [super setUp];

    self.query = [[OVCQuery alloc] init];
}

- (void)tearDown {
    self.query = nil;

    [super tearDown];
}

- (void)testQueryCreation {
    STAssertNotNil(self.query, @"Query should be created properly.");
}

- (void)testTransformBlockWithModelClass {
    NSDictionary *response = @{
            @"data" : @{
                    @"object" : @{
                            @"first_name" : @"Bruce",
                            @"last_name" : @"Wayne"
                    },
                    @"objects" : @[
                            @{@"first_name" : @"Tony", @"last_name" : @"Stark"},
                            @{@"first_name" : @"Bruce", @"last_name" : @"Banner"},
                    ]
            }
    };

    OVCTransformBlock block = [OVCQuery transformBlockWithModelClass:[TestModel class] objectKeyPath:@"data.object"];
    TestModel *model = block(response);

    STAssertTrue([model isKindOfClass:[TestModel class]], @"Block should return a TestModel instance.");
    STAssertEqualObjects(model, [TestModel testModelWithFirstName:@"Bruce" lastName:@"Wayne"], nil);

    block = [OVCQuery transformBlockWithModelClass:[TestModel class] objectKeyPath:@"data.objects"];
    NSArray *models = block(response);

    STAssertTrue([models isKindOfClass:[NSArray class]], @"Block should return an array.");

    NSArray *expectedModels = @[
            [TestModel testModelWithFirstName:@"Tony" lastName:@"Stark"],
            [TestModel testModelWithFirstName:@"Bruce" lastName:@"Banner"],
    ];
    STAssertEqualObjects(models, expectedModels, nil);
}

- (void)testTransformBlockWithModelClassAndNilKeyPath {
    NSDictionary *object = @{
            @"first_name" : @"Bruce",
            @"last_name" : @"Wayne"
    };

    OVCTransformBlock block = [OVCQuery transformBlockWithModelClass:[TestModel class] objectKeyPath:nil];
    TestModel *model = block(object);

    STAssertTrue([model isKindOfClass:[TestModel class]], @"Block should return a TestModel instance.");
    STAssertEqualObjects(model, [TestModel testModelWithFirstName:@"Bruce" lastName:@"Wayne"], nil);

    NSArray *objects = @[
            @{@"first_name" : @"Tony", @"last_name" : @"Stark"},
            @{@"first_name" : @"Bruce", @"last_name" : @"Banner"},
    ];

    NSArray *models = block(objects);

    STAssertTrue([models isKindOfClass:[NSArray class]], @"Block should return an array.");

    NSArray *expectedModels = @[
            [TestModel testModelWithFirstName:@"Tony" lastName:@"Stark"],
            [TestModel testModelWithFirstName:@"Bruce" lastName:@"Banner"],
    ];
    STAssertEqualObjects(models, expectedModels, nil);
}

- (void)testQueryWithMethodAndPath {
    OVCQuery *query = [OVCQuery queryWithMethod:OVCQueryMethodDelete path:@"/user/101"];

    STAssertEquals(query.method, OVCQueryMethodDelete, nil);
    STAssertEqualObjects(query.path, @"/user/101", nil);
    STAssertNil(query.parameters, nil);
    STAssertNil(query.parts, nil);
    STAssertNil(query.transformBlock, nil);
}

- (void)testQueryWithMethodPathAndParameters {
    OVCQuery *query = [OVCQuery queryWithMethod:OVCQueryMethodPut path:@"/update" parameters:@{
            @"status" : @"hello!"
    }];

    STAssertEquals(query.method, OVCQueryMethodPut, nil);
    STAssertEqualObjects(query.path, @"/update", nil);
    STAssertEqualObjects(query.parameters, @{@"status" : @"hello!"}, nil);
    STAssertNil(query.parts, nil);
    STAssertNil(query.transformBlock, nil);
}

- (void)testQueryWithMethodPathAndModelClass {
    OVCQuery *query = [OVCQuery queryWithMethod:OVCQueryMethodGet path:@"/user/101" modelClass:[TestModel class]];

    STAssertEquals(query.method, OVCQueryMethodGet, nil);
    STAssertEqualObjects(query.path, @"/user/101", nil);
    STAssertNil(query.parameters, nil);
    STAssertNil(query.parts, nil);
    STAssertNotNil(query.transformBlock, nil);
}

- (void)testQueryWithMethodPathParametersAndModelClass {
    OVCQuery *query = [OVCQuery queryWithMethod:OVCQueryMethodGet path:@"/contacts" parameters:@{
            @"name" : @"pepito"
    }
                                     modelClass:[TestModel class]];

    STAssertEquals(query.method, OVCQueryMethodGet, nil);
    STAssertEqualObjects(query.path, @"/contacts", nil);
    STAssertEqualObjects(query.parameters, @{@"name" : @"pepito"}, nil);
    STAssertNil(query.parts, nil);
    STAssertNotNil(query.transformBlock, nil);
}

- (void)testInitWithMethod {
    OVCQueryMethod method = OVCQueryMethodPost;
    NSString *path = @"/example";
    NSDictionary *parameters = @{
            @"foo" : @"bar"
    };

    OVCQuery *query = [[OVCQuery alloc] initWithMethod:method path:path parameters:parameters transformBlock:^id(NSNumber *number) {
        return [number stringValue];
    }];

    STAssertEquals(query.method, method, nil);
    STAssertEqualObjects(query.path, path, nil);
    STAssertEqualObjects(query.parameters, parameters, nil);
    STAssertNotNil(query.transformBlock, nil);
    STAssertEqualObjects(query.transformBlock(@42), @"42", nil);
}

- (void)testAddMultipartData {
    OVCMultipartPart *part1 = [[OVCMultipartPart alloc] initWithData:[@"Foo" dataUsingEncoding:NSUTF8StringEncoding]
                                                                name:@"foo" type:@"text/plain" filename:@"foo.txt"];

    [self.query addMultipartData:part1.data withName:part1.name type:part1.type filename:part1.filename];

    STAssertTrue([self.query.parts containsObject:part1], @"query.parts should contain part1");

    OVCMultipartPart *part2 = [[OVCMultipartPart alloc] initWithData:[@"Bar" dataUsingEncoding:NSUTF8StringEncoding]
                                                                name:@"bar" type:@"text/plain" filename:@"bar.txt"];
    [self.query addMultipartData:part2.data withName:part2.name type:part2.type filename:part2.filename];

    STAssertTrue([self.query.parts containsObject:part1], @"query.parts should contain part1 after adding part2");
    STAssertTrue([self.query.parts containsObject:part2], @"query.parts should contain part2");
}

@end
