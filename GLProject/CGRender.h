//
//  CGRender.h
//  GLProject
//
//  Created by Enrique Bermudez on 24/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGSceneGraph.h"


#import "CGObject3D.h"
#import "CC3GLMatrix.h"
#import "CGObject3DNode.h"


@class CGObject3D;

@interface CGRender : NSObject{//Renderer le da independencia de la plataforma 
    
    EAGLContext* _context;
    GLuint _colorRenderBuffer;
    
    //REMOVE:
    NSMutableArray* objects;
}

@property(strong)CGSceneGraph* sceneGraph;
@property(strong)CAEAGLLayer* layer;

-(id)initWithLayer:(CAEAGLLayer*)layer;

-(void)render;

-(void)clear;

-(void)setClearColor: (GLfloat)r g:(GLfloat)g b:(GLfloat)b a:(GLfloat)a;



//REMOVE:

@property(strong)CC3GLMatrix *projection;





@end
