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
    
    _frameCount = 1;

    _vertexData = vertexData;
    
    self.positionOffset = 0;
    self.normalOffset = VBO_NULL_ELEMENT;
    self.uvOffset = sizeof(float) * (VBO_POSITION_SIZE);
    
    self.drawMode = GL_TRIANGLES;
    
    [self updateVertexStrideAndStride];
    
    [self loadVertexData: vertexData.array capacity:vertexData.capacity];
    
    _animations = [[NSMutableArray alloc] init];
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

-(void)setUvOffset:(int)uvOffset{
    _uvOffset = uvOffset;
    [self updateVertexStrideAndStride];
}


-(void)setFrameCount:(int)frameCount{
    _frameCount = frameCount;
    [self updateVertexStrideAndStride];
}

-(void)updateVertexStrideAndStride{

    strideFloatsCount = ((self.positionOffset!=VBO_NULL_ELEMENT)?VBO_POSITION_SIZE:0) +
                        ((self.uvOffset!=VBO_NULL_ELEMENT)?VBO_UV_SIZE:0) +
                        ((self.normalOffset!=VBO_NULL_ELEMENT)?VBO_NORMAL_SIZE:0);
    
    _stride = sizeof(float)*strideFloatsCount;
    _vertexCount = (strideFloatsCount!=0)?((self.vertexData.capacity/strideFloatsCount)/self.frameCount):0;
}

-(bool)isAnimated{
    return (self.animations)?([self.animations count]>0?TRUE:FALSE):FALSE;
}

@end
