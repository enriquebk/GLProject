//
//  CGEngine.h
//  GLProject
//
//  Created by Enrique Bermudez on 29/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CC3GLMatrix.h"
#import "CGObject3DNode.h"
#import "CGSceneGraph.h"
#import "CGRender.h"

@interface CGEngine : NSObject{

    CGRender* _render;
}

@property(strong)CGSceneGraph* sceneGraph;

-(id)initWithRender:(CGRender*)render;

-(void)addObject:(CGObject3DNode*)o;

-(void)removeObject:(CGObject3DNode*)o;

-(void)draw;

@end
