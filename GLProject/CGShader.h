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
-(id)initWithVertexShaderSource:(NSString*)vs fragmentShaderSource:(NSString*)fs;

/* */
+ (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType;

/* */
+ (GLuint)compileShaderSource:(NSString*)source withType:(GLenum)shaderType;

+ (CGShader*)shaderNamed:(NSString*)shaderFiles;

+ (CGShader*)shaderWithvertexSource:(NSString*)vs withFragmentSource:(NSString*)fs;

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
