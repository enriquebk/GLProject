//
//  CGVertexBufferObject.h
//  GLProject
//
//  Created by Enrique Bermudez on 24/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "CGVertex.h"

@interface CGVertexBufferObject : NSObject{ // static object == vertexbuffer (one object - abstract class)
 
}
 
@property(strong,readonly)NSString* name;//or Filename
 
@property(readonly)GLfloat* vertexData;

@property(readonly)GLubyte* indices;

@property(readonly)int frameCount;
 
@property(readonly)CGVertexType type;
 
-(id)initWithName:(NSString*)name vertexData:(GLfloat*) vertexData type:(CGVertexType) type frameCount:(int) frameCount;

-(id)initWithName:(NSString*)name vertexData:(GLfloat*) vertexData type:(CGVertexType) type frameCount:(int) frameCount indices: (GLubyte*) indices;

-(GLuint) handler;

-(GLuint*) getHandlerRef;

@end