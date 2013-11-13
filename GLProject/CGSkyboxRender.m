//
//  CGSkyboxRender.m
//  GLProject
//
//  Created by Enrique Bermudez on 07/11/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGSkyboxRender.h"

#define  CGShaderParameter_position                     "Position"
#define  CGShaderParameter_ModelViewProjectionMatrix    "modelViewProjectionMatrix"
#define  CGShaderParameter_SourceColor                  "color"
#define  CGShaderParameter_TextCoord                    "TexCoordIn"
#define  CGShaderParameter_Texture                      "Texture"

@interface CGSkyboxRender (){
    
    GLuint _positionSlot;
    GLuint _texCoordSlot;
    //Globals
    GLuint _colorSlot;
    GLuint _modelViewProjectionMatrixUniform;
    
    GLuint _textureUniform;
}

@end

@implementation CGSkyboxRender


-(id)init{
    
    self = [super init];
    
    self.shader =[CGShader shaderNamed:@"SkyboxShader"];
    
    
    [self setupParameters];
    
    return self;
}

-(void)drawObject:(CGObject3D*) object withRenderer:(CGRenderer*)renderer{
    
    [super drawObject:object withRenderer:renderer];
    
  
    
  
    //Habilito las variables de vertice (los uniforms no se habilitan)
    glEnableVertexAttribArray(_positionSlot);
    glEnableVertexAttribArray(_texCoordSlot);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, object.texture.handler);
    glUniform1i(_textureUniform, 0);
    
    
    glBindBuffer(GL_ARRAY_BUFFER, [object.mesh VBOHandler]);
    
    
    // Calculate modelViewMatrix & modelViewProjectionMatrix ///
    
    CC3GLMatrix * modelMatrix = [object transformedMatrix]; //World space
    
    CC3GLMatrix * modelViewMatrix = [renderer.camera.viewMatrix copy];
    
    float* m = modelViewMatrix.glMatrix;
    
    m[12] = 0.0f;
    m[13] = 0.0f;
    m[14] = 0.0f;
    
    [modelViewMatrix multiplyByMatrix:modelMatrix];//Camera space
    
    
    CC3GLMatrix * modelViewProjectionMatrix = [renderer.camera.porjectionMatrix copy];
    [modelViewProjectionMatrix multiplyByMatrix:modelViewMatrix];
    
    
    
    glUniformMatrix4fv(_modelViewProjectionMatrixUniform, 1, 0, modelViewProjectionMatrix.glMatrix);
    
    /////////////////////////////////////////
    
    
    int frameOffset = ((object.frameIndex)*object.mesh.stride*object.mesh.vertexCount);
    
    
    // Position /////////////////////////////
    //Calls glVertexAttribPointer to feed the correct values to the two input variables for the vertex shader
    glVertexAttribPointer(_positionSlot, VBO_POSITION_SIZE, GL_FLOAT, GL_FALSE,
                          object.mesh.stride ,  (GLvoid*) (frameOffset + object.mesh.positionOffset));
    /////////////////////////////////////////
    
    // Color ///////////////////////////////
    glUniform4f(_colorSlot, object.color.r, object.color.g, object.color.b, object.color.a);
    ////////////////////////////////////////
    
    
    // TEXTURE_MAPPING ////////////////////
    glVertexAttribPointer(_texCoordSlot,VBO_UV_SIZE, GL_FLOAT, GL_FALSE,
                          object.mesh.stride,(GLvoid*) (frameOffset  + object.mesh.uvOffset));
    
    //////////////////////////////////////
    
    
    /* --- Draw --- */
        
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, [object.mesh indicesHandler]);
        
    glDrawElements(object.mesh.drawMode, object.mesh.indices.capacity ,GL_UNSIGNED_BYTE, 0);
    
    
    glDisableVertexAttribArray(_positionSlot);
    glDisableVertexAttribArray(_texCoordSlot);

    
  
    
}

-(void)setupParameters{
    
    _positionSlot = glGetAttribLocation(self.shader.handler, CGShaderParameter_position);
    _modelViewProjectionMatrixUniform = glGetUniformLocation(self.shader.handler, CGShaderParameter_ModelViewProjectionMatrix);
    _colorSlot =  glGetUniformLocation(self.shader.handler, CGShaderParameter_SourceColor);
    _texCoordSlot = glGetAttribLocation(self.shader.handler, CGShaderParameter_TextCoord);
    _textureUniform = glGetUniformLocation(self.shader.handler, CGShaderParameter_Texture);
    
}
@end
