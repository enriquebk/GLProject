//
//  CGObject3DNode.m
//  GLProject
//
//  Created by Enrique Bermudez on 29/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGObject3D.h"


@interface CGMesh (){
    
    int currentFrame;
    float deltaFrame;
}

@end

/* Other implementation: A node may have an entity like ObjectEntiy LightEntity..*/
@implementation CGObject3D

-(id)initWithMesh:(CGMesh*)mesh{

    self = [super init];
    
    if(self){
        _mesh = mesh;
    
        _shaderProgram = [[CGShader alloc] init];
    }
    
    return self;
}

-(void)render:(CGRender *)render{
                  
    //[self.shaderProgram drawObject:self inRender:render];
}

-(void) setTexture:(CGTexture*)texture{
    [self.textures insertObject:texture atIndex:0];
}

@end
