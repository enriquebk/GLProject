//
//  CGEngine.h
//  GLProject
//
//  Created by Enrique Bermudez on 24/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CC3GLMatrix.h"
#import "CGObject3D.h"
#import "CGLight.h"
#import "CGSceneGraph.h"

@class CGObject3D;
@class CGSceneGraph;

@interface CGEngine : NSObject{
    
}

@property(strong)CGSceneGraph* sceneGraph;

-(id)initWithLayer:(CAEAGLLayer*)layer;

-(void)addObject:(CGObject3D*)o;

-(void)removeObject:(CGObject3D*)o;


-(void)addLight:(CGLight*)l;

-(void)addLight:(CGLight*)l withParent:(CGNode*)parent;

-(void)removeLight:(CGLight*)l;


-(void)render;

-(void)clear;

-(void)setClearColor: (GLfloat)r g:(GLfloat)g b:(GLfloat)b a:(GLfloat)a;

@end


