//
//  GTRepository+Tags.m
//  Wingman
//
//  Created by Sam Symons on 23/03/12.
//  Copyright (c) 2012 Polar Bear Farm. All rights reserved.
//

#import "GTRepository+Tags.h"
#import "GTReference.h"
#import "GTObject.h"
#import "GTBranch.h"

@implementation GTRepository (Tags)

- (NSArray *)allTagNamesWithError:(NSError **)error
{
    NSString *tagPrefix = @"refs/tags/";
    NSArray *referenceNames = [self referenceNamesWithError:error];
    
    if (error && *error)
    {
        return nil;
    }
    
    NSMutableArray *filteredReferenceNames = [NSMutableArray array];
    
    for (NSString *refName in referenceNames) {
        if ([refName hasPrefix:tagPrefix]) {
            NSString *formattedRefName = [refName stringByReplacingOccurrencesOfString:tagPrefix withString:@""];
            [filteredReferenceNames addObject:formattedRefName];
        }
    }
    
    return [NSArray arrayWithArray:filteredReferenceNames];
}

- (NSArray *)allTagsWithError:(NSError **)error
{
    NSString *tagPrefix = @"refs/tags/";
    NSArray *referenceNames = [self referenceNamesWithError:error];
    
    if (error && *error)
    {
        return nil;
    }
    
    NSMutableArray *filteredReferenceNames = [NSMutableArray array];
    
    for (NSString *refName in referenceNames) {
        if ([refName hasPrefix:tagPrefix]) {
            NSString *formattedRefName = [refName stringByReplacingOccurrencesOfString:tagPrefix withString:@""];
            [filteredReferenceNames addObject:formattedRefName];
        }
    }
    
    NSMutableArray *tags = [NSMutableArray array];
    for (NSString *refName in filteredReferenceNames)
    {
        GTReference *ref = [GTReference referenceByLookingUpReferencedNamed:refName inRepository:self error:error]; // referenceByLookingUpRef:refName inRepo:self error:error];
        
        if ((error && *error) || !ref)
        {
            continue;
        }
        
        GTObject *tag = [self lookupObjectByOid:(git_oid *)ref.oid objectType:GTObjectTypeAny error:error];
        
        if ((error && *error) || !tag)
        {
            continue;
        }
        
        [tags addObject:tag];
    }
    
    return [NSArray arrayWithArray:filteredReferenceNames];
}

- (NSArray *)allTagsAsBranchesWithError:(NSError **)error
{
    NSString *tagPrefix = @"refs/tags/";
    NSArray *referenceNames = [self referenceNamesWithError:error];
    
    if (error && *error)
    {
        return nil;
    }
    
    NSMutableArray *tagBranches = [NSMutableArray array];
    
    for (NSString *refName in referenceNames) {
        if ([refName hasPrefix:tagPrefix]) {
            GTReference *ref = [GTReference referenceByLookingUpReferencedNamed:refName inRepository:self error:error];
            GTBranch *tagBranch = [[GTBranch alloc] initWithReference:ref repository:self];
            
            [tagBranches addObject:tagBranch];
        }
    }
    
    return [NSArray arrayWithArray:tagBranches];
}

@end
