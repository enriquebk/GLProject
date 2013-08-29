//
//  CGVertexBufferObject.m
//  GLProject
//
//  Created by Enrique Bermudez on 24/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGVertexBufferObject.h"

@interface CGVertexBufferObject (){
    
    GLuint handler;
}

@end

@implementation CGVertexBufferObject

-(GLuint) handler{
        
    return handler;
}

-(GLuint*) getHandlerRef{
    
    return &handler;
}


-(id)initWithName:(NSString*)name vertexData:(GLfloat*) vertexData type:(CGVertexType) type frameCount:(int)frameCount{
    
    self = [super init];
    if(self){
        
        memcpy(_vertexData, &vertexData, sizeof(vertexData));
        
        _frameCount = frameCount;
        _name = name;
        _type = type;
        _indices = NULL;
        
    }
    
    return self;
}

-(id)initWithName:(NSString*)name vertexData:(GLfloat*) vertexData type:(CGVertexType) type frameCount:(int)frameCount indices: (GLubyte*) indices{

    self = [super init];

    if(self){
        
        _vertexData = malloc(sizeof(vertexData));
        _indices = malloc(sizeof(indices));
        
        memcpy(_vertexData, &vertexData, sizeof(vertexData));
        memcpy(_indices, &indices, sizeof(indices));
        
        _frameCount = frameCount;
        _name = name;
        _type = type;
        _indices = indices;
    
    }

    return self;
}

- (void) dealloc
{
    free(_vertexData);
}


@end
