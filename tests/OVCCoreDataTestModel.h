//
//  OVCCoreDataTestModel.h
//  Overcoat
//
//  Created by sodas on 11/11/15.
//
//

#import <Foundation/Foundation.h>
#import <MTLManagedObjectAdapter/MTLManagedObjectAdapter.h>
#import "OVCTestModel.h"

@interface OVCManagedTestModel : OVCTestModel <MTLManagedObjectSerializing>

@end

@interface OVCManagedAlternativeModel : OVCAlternativeModel <OVCManagedObjectSerializingContainer>

@property (copy, nonatomic, readonly) NSArray<OVCManagedTestModel *> *objects;

@end
