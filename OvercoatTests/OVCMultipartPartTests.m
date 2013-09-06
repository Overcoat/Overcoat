//
//  OVCMultipartPartTests.m
//  Overcoat
//
//  Created by guille on 13/05/13.
//  Copyright (c) 2013 Guillermo Gonzalez. All rights reserved.
//

@interface OVCMultipartPartTests : SenTestCase

@property (strong, nonatomic) OVCMultipartPart *part;

@end

@implementation OVCMultipartPartTests

- (void)setUp {
    [super setUp];

    self.part = [OVCMultipartPart partWithData:[@"Some data" dataUsingEncoding:NSUTF8StringEncoding]
                                          name:@"blob"
                                          type:@"text/plain"
                                      filename:@"blob.txt"];
}

- (void)tearDown {
    self.part = nil;

    [super tearDown];
}

- (void)testPartCreation {
    STAssertNotNil(self.part, @"Object should be created properly", nil);
}

- (void)testPartHasData {
    STAssertEqualObjects(self.part.data, [@"Some data" dataUsingEncoding:NSUTF8StringEncoding], nil);
}

- (void)testPartHasName {
    STAssertEqualObjects(self.part.name, @"blob", nil);
}

- (void)testPartHasType {
    STAssertEqualObjects(self.part.type, @"text/plain", nil);
}

- (void)testPartHasFilename {
    STAssertEqualObjects(self.part.filename, @"blob.txt", nil);
}

@end
