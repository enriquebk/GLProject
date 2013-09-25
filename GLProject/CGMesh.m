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
    
    int strideFloatsCount;

}

@end


@implementation CGMesh

-(id)initWithVertexData:(CGArray*)vertexData{

    self = [super init];
    
    if(self){
        [self configureWithVertexData:vertexData];
    }
    
    return self;
}

-(id)initWithVertexData:(CGArray*)vertexData indices: (CGArray*)indices{

    self = [super init];
    
    if(self){
        
        [self configureWithVertexData:vertexData];

        _indices = indices;
        
        [self loadIndicesData:indices.array capacity:indices.capacity];
    }
    
    return self;
}

-(void)configureWithVertexData:(CGArray*)vertexData{

    self.frameCount = 1;

    _vertexData = vertexData;
    
    self.positionOffset = 3;
    self.colorOffset = 4;
    self.uvOffset = 2;
    self.normalOffset = 0;
    
    self.drawMode = GL_TRIANGLES;
    
    [self updateVertexStrideAndStride];
    
    [self loadVertexData: vertexData.array capacity:vertexData.capacity];
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

-(void)setPositionOffset:(int)positionOffset{
    _positionOffset = positionOffset;
    [self updateVertexStrideAndStride];
}

-(void)setNormalOffset:(int)normalOffset{
    _normalOffset = normalOffset;
    [self updateVertexStrideAndStride];
}

-(void)setColorOffset:(int)colorOffset{
    _colorOffset = colorOffset;
    [self updateVertexStrideAndStride];
}

-(void)setUvOffset:(int)uvOffset{
    _uvOffset = uvOffset;
    [self updateVertexStrideAndStride];
}

-(void)updateVertexStrideAndStride{

    strideFloatsCount = self.positionOffset+self.colorOffset+self.uvOffset+self.normalOffset;
    _stride = sizeof(float)*strideFloatsCount;
    _vertexCount = (self.vertexData.capacity/strideFloatsCount)/self.frameCount;
}

@end
