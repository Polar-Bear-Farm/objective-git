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

@implementation GTRepository (Tags)

- (NSArray*)allTagsWithError:(NSError**)error
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
            NSString *formattedRefName = [refName stringByReplacingOccurrencesOfString:@"refs/tags/" withString:@""];
            [filteredReferenceNames addObject:formattedRefName];
        }
    }
    
    /*
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
     */
    
    return [NSArray arrayWithArray:filteredReferenceNames];
}

@end
