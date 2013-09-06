//
//  CGObject3DNode.h
//  GLProject
//
//  Created by Enrique Bermudez on 29/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGNode.h"
#import "CGMesh.h"
#import "CGShader.h"
#import "CGTexture.h"

@class CGShader;


@interface CGObject3D : CGNode


@property(strong)CGMesh* mesh;

@property(strong)CGShader* shaderProgram;

@property(strong)NSMutableArray* textures;

-(id) initWithMesh:(CGMesh*)mesh;

-(void) setTexture:(CGTexture*)texture;

@end
