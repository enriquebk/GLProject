//
//  CGFreewayCamera.m
//  GLProject
//
//  Created by Enrique Bermudez on 13/11/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGFreewayCamera.h"

@implementation CGFreewayCamera


-(void)rotateByX:(float)x{
     [self rotate:CC3VectorMake(x,0,0)];
}

-(void)rotateByY:(float)y{
    [self.viewMatrix rotateByX:-self.rotation.x];
    [self rotate:CC3VectorMake(0,y,0)];
    [self.viewMatrix rotateByX:self.rotation.x];
}

-(CC3GLMatrix *) getTransormedViewMatrix{
    CC3GLMatrix* vm = [super getTransormedViewMatrix];
    [vm invert];
    return vm;
}

@end
