//
//  CGModel.m
//  GLProject
//
//  Created by Enrique Bermudez on 29/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGMesh.h"

@interface CGMesh (){
    
    GLuint VBOHandler;
    GLuint indicesHandler;
}

@end


@implementation CGMesh

-(id)initWithVertexData:(CGArray*)vertexData{

    self = [super init];
    
    if(self){
    
        self.frameCount = 1;
        
        [self loadIndicesData:vertexData.array capacity:vertexData.capacity];
    }
    
    return self;
}

-(id)initWithVertexData:(CGArray*)vertexData indices: (CGArray*)indices{

    self = [super init];
    
    if(self){
        
        self.frameCount = 1;
        self.indicesCount = [indices capacity];

        self.positionOffset = 3;
        self.colorOffset = 4;
        self.stride = sizeof(float)*7;
        [self loadVertexData: vertexData.array capacity:vertexData.capacity];
        [self loadIndicesData:indices.array capacity:indices.capacity];
    }
    
    return self;
}


-(void)loadVertexData:(GLfloat *)vertexData capacity:(int)cpacity{

    glGenBuffers(1, [self VBOHandlerRef] );
    glBindBuffer(GL_ARRAY_BUFFER, [self VBOHandler]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(float)*cpacity, vertexData, GL_STATIC_DRAW);
}

-(void)loadIndicesData:(GLubyte* )indices capacity:(int)cpacity{
    
    glGenBuffers(1, [self indicesHandlerRef]); // idem vertexBuffer
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, [self indicesHandler]); // idem vertexBuffer
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLubyte)*cpacity, indices, GL_STATIC_DRAW); // idem vertexBuffer
}

-(GLuint) VBOHandler{

    return VBOHandler;
}
-(GLuint*) VBOHandlerRef{

    return &VBOHandler;
}

-(GLuint) indicesHandler{

    return indicesHandler;
}

-(GLuint*) indicesHandlerRef{
    return &indicesHandler;
}

@end
