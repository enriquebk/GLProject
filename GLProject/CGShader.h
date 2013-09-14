//
//  CGShader.h
//  GLProject
//
//  Created by Enrique Bermudez on 24/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGEngine.h"


@class CGObject3D;
@class CGEngine;

@interface CGShader : NSObject{

}

@property(assign)GLuint handler;

/* */
-(id)initWithVertexShader:(NSString*)vs fragmentShader:(NSString*)fs;

/* Overide me */
-(void)drawObject:(CGObject3D*) object usingEngine:(CGEngine*)engine;

/* */
+ (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType;

@end
