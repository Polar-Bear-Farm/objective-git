//
//  GTRepository+Tags.h
//  Wingman
//
//  Created by Sam Symons on 23/03/12.
//  Copyright (c) 2012 Polar Bear Farm. All rights reserved.
//

#import "GTRepository.h"

@interface GTRepository (Tags)

- (NSArray *)allTagNamesWithError:(NSError **)error;
- (NSArray *)allTagsWithError:(NSError **)error;
- (NSArray *)allTagsAsBranchesWithError:(NSError **)error;

@end
