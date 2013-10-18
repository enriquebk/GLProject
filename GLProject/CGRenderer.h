//
//  CGRenderer.h
//  GLProject
//
//  Created by Enrique Bermudez on 24/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CC3GLMatrix.h"
#import "CGObject3D.h"
#import "CGLight.h"
#import "CGCamera.h"

@class CGObject3D;
@class CGSceneGraph;

@interface CGRenderer : NSObject{ //TODO:rename => renderer
    
}

@property(strong)NSMutableArray* lights;

@property(strong)NSMutableArray* displayList;

@property(strong) CGCamera* camera;

@property(assign)GLuint currentShaderHandler;


-(id)initWithLayer:(CAEAGLLayer*)layer;

-(void)addObject:(CGObject3D*)o;

-(void)removeObject:(CGObject3D*)o;


-(void)addLight:(CGLight*)l;

-(void)removeLight:(CGLight*)l;


-(void)render;

-(void)clear;

-(void)setClearColor: (GLfloat)r g:(GLfloat)g b:(GLfloat)b a:(GLfloat)a;

@end


