//
//  CGCameraNode.m
//  GLProject
//
//  Created by Enrique Bermudez on 29/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGCamera.h"

@implementation CGCamera

-(id)init{
    self = [super init];
    if (self) {
        self.porjectionMatrix = [CC3GLMatrix identity];
        self.viewMatrix = [CC3GLMatrix identity];
    }
    return self;
}

-(void) setCameraFrustumLeft: (GLfloat) left
                    andRight: (GLfloat) right
                   andBottom: (GLfloat) bottom
                      andTop: (GLfloat) top
                     andNear: (GLfloat) near
                      andFar: (GLfloat) far{
    
    
    [self.porjectionMatrix populateFromFrustumLeft:left andRight:right andBottom:bottom andTop:top andNear:near andFar:far];
}

-(void)translate:(CC3Vector) aVector{
    [self.viewMatrix translateBy:aVector];
    
    _position.x+=aVector.x;
    _position.y+=aVector.y;
    _position.z+=aVector.z;
}

-(void)translateAroundLocalAxis:(CC3Vector) aVector{
    NSLog(@"TODO: Unimplemented method translateAroundLocalAxis:");
}

//Warning: This rotation will affects the viewMatrix so it wont work as the node rotation...
-(void)rotate:(CC3Vector) aVector{
    [self.viewMatrix rotateBy:aVector];
    
    _rotation.x+=aVector.x;
    _rotation.y+=aVector.y;
    _rotation.z+=aVector.z;
}

-(void)scale:(CC3Vector) aVector{
    [self.viewMatrix scaleBy:aVector];
    
    _scale.x+=aVector.x;
    _scale.y+=aVector.y;
    _scale.z+=aVector.z;
}

-(void)setPosition:(CC3Vector)position{
    NSLog(@"TODO: Unimplemented method setPosition:");
}

-(void)setRotation:(CC3Vector)position{
    NSLog(@"TODO: Unimplemented method setRotation:");
}

-(void)setScale:(CC3Vector)position{
    NSLog(@"TODO: Unimplemented method setScale:");
}

-(CC3GLMatrix *) getTransormedViewMatrix{
    CC3GLMatrix* vm = [self.viewMatrix copy];
    //[vm invert];
    return vm;
}

@end
