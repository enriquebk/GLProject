//
//  CGObject3DNode.m
//  GLProject
//
//  Created by Enrique Bermudez on 29/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGObject3D.h"
#import "CGDefaultShader.h"

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
        _shaderProgram = [[CGDefaultShader alloc] init];
        _textures = [[NSMutableArray alloc]init];
        _frameIndex = 0;
    }
    
    return self;
}

-(void)renderUsingEngine:(CGEngine *)engine{
    
    [self.shaderProgram drawObject:self usingEngine:engine];
}

-(void) setTexture:(CGTexture*)texture{
    [self.textures insertObject:texture atIndex:0];
}

@end
