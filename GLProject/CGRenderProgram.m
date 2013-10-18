//
//  CGRenderProgram.m
//  GLProject
//
//  Created by Enrique Bermudez on 17/10/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGRenderProgram.h"

@implementation CGRenderProgram

-(void)drawObject:(CGObject3D*) object withRenderer:(CGRenderer*)renderer{
    
    if(self.shader.handler != renderer.currentShaderHandler ){
        glUseProgram(self.shader.handler);
    }
}

@end
