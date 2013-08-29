//
//  CGShader.h
//  GLProject
//
//  Created by Enrique Bermudez on 24/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGRender.h"
#import "CGObject3D.h"

#define  CGShaderParameter_position "Position"
#define  CGShaderParameter_projection "Projection"
#define  CGShaderParameter_modelView "Modelview"

@class CGObject3D;
@class CGRender;

@interface CGShader : NSObject{

    GLuint _positionSlot;
    GLuint _projectionUniform;
    GLuint _modelViewUniform;
}

@property(assign)GLuint handler;

-(id)initWithVertexShader:(NSString*)vs fragmentShader:(NSString*)fs;

-(void)addParametersWithObject:(CGObject3D*) object render:(CGRender*)render;

-(void)removeParametersWithObject:(CGObject3D*) object render:(CGRender*)render;


//Overide me
-(void)setupParameters;

@end
