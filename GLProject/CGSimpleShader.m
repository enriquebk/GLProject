//
//  CGSimpleShader.m
//  GLProject
//
//  Created by Enrique Bermudez on 26/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGSimpleShader.h"
#import "CGStaticObject.h"

@implementation CGSimpleShader

-(id)init{

    self = [super initWithVertexShader:@"SimpleVertex" fragmentShader:@"SimpleFragment"];
    
    //if(self){}
    
    return self;
}


-(void)setupParameters{

    [super setupParameters];
    
     _colorSlot = glGetAttribLocation(self.handler, CGShaderParameter_SourceColor);
}

-(void)addParametersWithObject:(CGObject3D*) object render:(CGRender*)render{
    
    if(object.vertexType != CGVertexType_PC){
        NSLog(@"Unable to run shader");
        return;
    }
    
    glEnableVertexAttribArray(_colorSlot);
    
    [super addParametersWithObject:object render:render];
    
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE,
                          sizeofVertexType(object.vertexType), (GLvoid*) (sizeof(float) * 3));    
}

-(void)removeParametersWithObject:(CGObject3D*) object render:(CGRender*)render{
    
    glDisableVertexAttribArray(_colorSlot);
    
    [super removeParametersWithObject:object render:render];
    
}

@end
