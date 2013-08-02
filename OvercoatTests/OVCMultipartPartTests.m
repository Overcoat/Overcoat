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

    self.part = [[OVCMultipartPart alloc] init];
}

- (void)tearDown {
    self.part = nil;

    [super tearDown];
}

- (void)testPartCreation {
    STAssertNotNil(self.part, @"Object should be created properly", nil);
}

- (void)testInitWithData {
    NSData *data = [@"Some data" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *name = @"blob";
    NSString *type = @"text/plain";
    NSString *filename = @"blob.txt";

    OVCMultipartPart *part = [[OVCMultipartPart alloc] initWithData:data name:name type:type filename:filename];

    STAssertEqualObjects(part.data, data, nil);
    STAssertEqualObjects(part.name, name, nil);
    STAssertEqualObjects(part.type, type, nil);
    STAssertEqualObjects(part.filename, filename, nil);
}

- (void)testHash {
    NSData *data = [@"Some data" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *name = @"blob";
    NSString *type = @"text/plain";
    NSString *filename = @"blob.txt";

    NSUInteger hash = [data hash];
    hash ^= [name hash];
    hash ^= [type hash];
    hash ^= [filename hash];

    OVCMultipartPart *part = [[OVCMultipartPart alloc] initWithData:data name:name type:type filename:filename];

    STAssertEquals([part hash], hash, nil);
}

- (void)testIsEqual {
    OVCMultipartPart *part1 = [[OVCMultipartPart alloc] initWithData:[@"Some data" dataUsingEncoding:NSUTF8StringEncoding]
                                                                name:@"text"
                                                                type:@"text/plain"
                                                            filename:@"sample.txt"];
    OVCMultipartPart *part2 = [[OVCMultipartPart alloc] initWithData:[@"Some data" dataUsingEncoding:NSUTF8StringEncoding]
                                                                name:@"text"
                                                                type:@"text/plain"
                                                            filename:@"sample.txt"];
    STAssertEqualObjects(part1, part2, @"part1 and part2 should be equal");

    part2.name = @"text2";

    STAssertFalse([part1 isEqual:part2], @"part1 and part2 should be NOT equal");
}

@end
