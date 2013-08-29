//
//  CGRender.h
//  GLProject
//
//  Created by Enrique Bermudez on 24/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGObject3D.h"
#import "CC3GLMatrix.h"

@class CGObject3D;

@interface CGRender : NSObject{
    
    EAGLContext* _context;
    GLuint _colorRenderBuffer;
    
    NSMutableArray* objects;
}


@property(strong)CC3GLMatrix *projection;

-(id)initWithLayer:(CAEAGLLayer*)layer;

-(void)addObject:(CGObject3D*)o;

-(void)removeObject:(CGObject3D*)o;

-(void)render;

-(void)setClearColor: (GLfloat)r g:(GLfloat)g b:(GLfloat)b a:(GLfloat)a;

-(void)clear;

-(void)setViewPortX:(int)x y:(int)y width:(int)w height:(int)h;

-(void) setCameraFrustumLeft: (GLfloat) left
					   andRight: (GLfloat) right
					  andBottom: (GLfloat) bottom
						 andTop: (GLfloat) top
						andNear: (GLfloat) near
                      andFar: (GLfloat) far;

-(void)tranlateCamera:(CC3Vector) aVector;

-(void)rotateCamera: (CC3Vector) aVector;


@end
