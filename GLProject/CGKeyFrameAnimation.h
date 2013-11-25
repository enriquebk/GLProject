//
//  CGKeyFrameAnimation.h
//  GLProject
//
//  Created by Enrique Bermudez on 01/10/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Class that contains all the data needed to render a keyframe animation.
 */
@interface CGKeyFrameAnimation : NSObject

/**
 *  First animation frame
 */
@property(assign, readonly) int initialFrame;

/**
 *  Last animation frame
 */
@property(assign, readonly) int finalFrame;

/**
 * Animation's name.
 */
@property(strong, readonly) NSString* name;

/**
 * Initialaizes a keyframe animation
 * @param name
 * @param initialFrame
 * @param finalName
 * @return The animation.
 */
-(id)initWithName: (NSString*) name initalFrame:(int) initialFrame finalFrame:(int) finalName;

@end
