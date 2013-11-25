//
//  CGParticle.h
//  GLProject
//
//  Created by Enrique Bermudez on 28/10/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CC3GLMatrix.h"

@interface CGParticle : NSObject

/**
 */
@property float timeAlive;

/**
 */
@property CC3Vector movementDirection;//remove?

/**
 */
@property CC3Vector startPosition;

/**
 */
@property CC3Vector position;

/**
 */
@property ccColor4F color;

/**
 */
@property float size;

@end
