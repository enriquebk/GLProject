//
//  CGRender.h
//  GLProject
//
//  Created by Enrique Bermudez on 24/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CC3GLMatrix.h"
#import "CGObject3D.h"

@class CGObject3D;

@interface CGRender : NSObject{
    
}


-(id)initWithLayer:(CAEAGLLayer*)layer;

-(void)addObject:(CGObject3D*)o;

-(void)removeObject:(CGObject3D*)o;

-(void)render;

-(void)clear;

-(void)setClearColor: (GLfloat)r g:(GLfloat)g b:(GLfloat)b a:(GLfloat)a;

@end


