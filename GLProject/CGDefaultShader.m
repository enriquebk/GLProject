//
//  CGDefaultShader.m
//  GLProject
//
//  Created by Enrique Bermudez on 09/09/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGDefaultShader.h"

#define  CGShaderParameter_position "Position"
#define  CGShaderParameter_projection "Projection"
#define  CGShaderParameter_modelView "Modelview"
#define  CGShaderParameter_SourceColor "SourceColor"

@interface CGDefaultShader (){
   
    GLuint _positionSlot;
    GLuint _projectionUniform;
    GLuint _modelViewUniform;
    GLuint _colorSlot;
}

@end


@implementation CGDefaultShader


-(id)init{

    self = [self initWithVertexShader:@"SimpleVertex" fragmentShader:@"SimpleFragment"];
    
    [self setupParameters];
    
    return self;
}

-(void)drawObject:(CGObject3D*) object usingEngine:(CGEngine*)engine{
    
    glUseProgram(self.handler);
    
    glEnableVertexAttribArray(_colorSlot);
    glEnableVertexAttribArray(_positionSlot);
    glEnableVertexAttribArray(_projectionUniform);
    glEnableVertexAttribArray(_modelViewUniform);
    
    glUniformMatrix4fv(_modelViewUniform, 1, 0, object.matrix.glMatrix);
    
    glUniformMatrix4fv(_projectionUniform, 1, 0, engine.sceneGraph.camera.matrix.glMatrix);
    
    //Calls glVertexAttribPointer to feed the correct values to the two input variables for the vertex shader – the Position and SourceColor attributes.
    
    glVertexAttribPointer(_positionSlot, object.mesh.positionOffset, GL_FLOAT, GL_FALSE,
                          object.mesh.stride , 0);
    glVertexAttribPointer(_colorSlot, object.mesh.colorOffset, GL_FLOAT, GL_FALSE,
                          object.mesh.stride,(GLvoid*) (sizeof(float) * 3));
    
    
    glDrawElements(GL_TRIANGLES, object.mesh.indicesCount ,GL_UNSIGNED_BYTE, 0);
    
    
    glDisableVertexAttribArray(_colorSlot);
    glDisableVertexAttribArray(_positionSlot);
    glDisableVertexAttribArray(_projectionUniform);
    glDisableVertexAttribArray(_modelViewUniform);
    
}

-(void)setupParameters{
    
    _positionSlot = glGetAttribLocation(self.handler, CGShaderParameter_position);
    _projectionUniform = glGetUniformLocation(self.handler, CGShaderParameter_projection);
    _modelViewUniform = glGetUniformLocation(self.handler,  CGShaderParameter_modelView);
    _colorSlot = glGetAttribLocation(self.handler, CGShaderParameter_SourceColor); 
    
}

@end
