//
//  CGObject3D.m
//  GLProject
//
//  Created by Enrique Bermudez on 24/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGObject3D.h"

@implementation CGObject3D


- (id)init{
    
    self = [super init];
    
    if(self){
        self.visible = YES;
        self.currentFrame = 0;
        self.modelViewMatrix = [CC3GLMatrix identity];
    }
    
    return self;
}


-(void)draw{
    //glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]),
    //               GL_UNSIGNED_BYTE, 0);
    
}

-(void)drawInRender:(CGRender*)render {

    
    // Calls glUseProgram to tell OpenGL to actually use this program when given vertex info.
    glUseProgram(self.shader.handler); //Puedo cambiar el programa que usa opengl para renderizar

    [self.shader addParametersWithObject:self render:render];
    
    [self performSelector:@selector(draw) withObject:nil];
    
    [self.shader removeParametersWithObject:self render:render];

}

@end
