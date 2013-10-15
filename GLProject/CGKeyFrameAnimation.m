//
//  CGKeyFrameAnimation.m
//  GLProject
//
//  Created by Enrique Bermudez on 01/10/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGKeyFrameAnimation.h"

@implementation CGKeyFrameAnimation

-(id)initWithName: (NSString*) name initalFrame:(int) initialFrame finalFrame:(int) finalName{

    self = [super init];
    
    if(self){
        _name = name;
        _initialFrame = initialFrame;
        _finalFrame = finalName;
    }
    return self;
}

@end
