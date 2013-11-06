//
//  CGFloatArray.h
//  GLProject
//
//  Created by Enrique Bermudez on 05/09/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGArray : NSObject

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

/**
 * Returns the size in bytes of an element in the array.
 * Override this method in order to change the data type of the array.
 * @return The size in bytes of an element in the array.
 */
- (int) elementsSize;

@end

@interface CGFloatArray : CGArray

@end
