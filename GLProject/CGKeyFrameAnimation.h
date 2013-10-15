//
//  CGKeyFrameAnimation.h
//  GLProject
//
//  Created by Enrique Bermudez on 01/10/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGKeyFrameAnimation : NSObject

@property(assign, readonly) int initialFrame;

@property(assign, readonly) int finalFrame;

@property(strong, readonly) NSString* name;

-(id)initWithName: (NSString*) name initalFrame:(int) initialFrame finalFrame:(int) finalName;

@end
