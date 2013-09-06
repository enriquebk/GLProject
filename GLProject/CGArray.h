//
//  CGFloatArray.h
//  GLProject
//
//  Created by Enrique Bermudez on 05/09/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGArray : NSObject // TODO: make a float array and a unsigned array in the same file..


/**
 * Initialises an CGArray for a given data with a specified capacity.
 * @param array The raw array of data.
 * @param capacity The initial capacity (nuber of obejcts) of the array.
 */
- (id) initWithData:(void *)array withCapacity:(unsigned int)capacity;

/**
 * Returns the raw array of data.
 * @return The raw array of data.
 */
- (void *) array;

/**
 * Returns the number of elements in the array.
 * @return The number of elements in the array.
 */
- (unsigned int) capacity;

@end
