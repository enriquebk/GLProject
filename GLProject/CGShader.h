//
//  CGShader.h
//  GLProject
//
//  Created by Enrique Bermudez on 24/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGRenderer.h"


@class CGObject3D;
@class CGRenderer;


/*
 *
 */
@interface CGShader : NSObject{

}

@property(assign)GLuint handler;

/* */
-(id)initWithVertexShader:(NSString*)vs fragmentShader:(NSString*)fs;

/* */
+ (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType;

/* */
//+ (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType precompildedMacros:(NSString*)macros;

/* TODO: Explain... */
+ (CGShader*)shaderNamed:(NSString*)shaderFiles;



@end

/*
 *
 */
@interface CGShaderManager : NSObject


@property(strong)NSMutableDictionary* shaders;

-(CGShader*) shaderWithKey: (NSString*)key;

-(void) addShader:(CGShader*) shader WithKey: (NSString*)key;

+(id)sharedInstance;

@end
