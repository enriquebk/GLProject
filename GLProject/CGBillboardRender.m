//
//  CGBillboardRender.m
//  GLProject
//
//  Created by Enrique Bermudez on 13/11/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGBillboardRender.h"
#import "CGTexture.h"

#define  CGDefaultShaderKey    @"DefaultShader"

#define  CGShaderParameter_position                     "Position"
#define  CGShaderParameter_ModelProjectionMatrix        "modelProjectionMatrix"
#define  CGShaderParameter_SourceColor                  "color"
#define  CGShaderParameter_TextCoord                    "TexCoordIn"
#define  CGShaderParameter_Texture                      "Texture"


@interface CGBillboardRender (){
    
    GLuint _positionSlot;
    GLuint _texCoordSlot;
    
    
    //Globals
    GLuint _colorSlot;
    GLuint _modelProjectionMatrixUniform;
    
    GLuint _textureUniform;

    
}

@end

@implementation CGBillboardRender


-(id)init{
    
    self = [super init];
    
    self.shader =[CGShader shaderNamed:@"BillboardShader"];
    
    [self setupParameters];
    
    return self;
}

-(void)drawObject:(CGObject3D*) object withRenderer:(CGRenderer*)renderer{
    
    [super drawObject:object withRenderer:renderer];
    
    glDisable(GL_DEPTH_TEST);
     glBlendFunc( GL_SRC_ALPHA ,GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    
    //Habilito las variables de vertice (los uniforms no se habilitan)
    glEnableVertexAttribArray(_positionSlot);
    glEnableVertexAttribArray(_texCoordSlot);
    
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, object.texture.handler);
    glUniform1i(_textureUniform, 0);
    
    
    glBindBuffer(GL_ARRAY_BUFFER, [object.mesh VBOHandler]);
    
    
    // Calculate modelViewMatrix & modelViewProjectionMatrix ///
    
    CC3GLMatrix * modelMatrix = [object transformedMatrix]; //World space
    
   // [modelMatrix rotateBy:cc3v(-renderer.camera.rotation.x,-renderer.camera.rotation.y,-renderer.camera.rotation.z)];
    
    [modelMatrix rotateBy:cc3v(renderer.camera.rotation.x,renderer.camera.rotation.y,renderer.camera.rotation.z)];
    
    CC3GLMatrix * modelViewMatrix = [renderer.camera  getTransormedViewMatrix];
    
    [modelViewMatrix multiplyByMatrix:modelMatrix];//Camera space
    
    CC3GLMatrix * modelViewProjectionMatrix = [renderer.camera.porjectionMatrix copy];
    [modelViewProjectionMatrix multiplyByMatrix:modelViewMatrix];
    
    glUniformMatrix4fv(_modelProjectionMatrixUniform, 1, 0, modelViewProjectionMatrix.glMatrix);
    
    ///////////////////////////////////////////////////

    
    int frameOffset = 0;
    
    
    // Position /////////////////////////////
    //Calls glVertexAttribPointer to feed the correct values to the two input variables for the vertex shader
    glVertexAttribPointer(_positionSlot, VBO_POSITION_SIZE, GL_FLOAT, GL_FALSE,
                          object.mesh.stride ,  (GLvoid*) (frameOffset + object.mesh.positionOffset));
    /////////////////////////////////////////
    
    // Color ///////////////////////////////
   // glUniform4f(_colorSlot, object.color.r, object.color.g, object.color.b, object.color.a);
    glUniform4f(_colorSlot, object.color.r, 0.6,0.0, object.color.a);
    ////////////////////////////////////////
    
    
    // TEXTURE_MAPPING ////////////////////
    glVertexAttribPointer(_texCoordSlot,VBO_UV_SIZE, GL_FLOAT, GL_FALSE,
                          object.mesh.stride,(GLvoid*) (frameOffset  + object.mesh.uvOffset));
    
    //////////////////////////////////////
    
    /* --- Draw --- */
    
    if (object.mesh.indices) {
        
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, [object.mesh indicesHandler]);
        
        glDrawElements(object.mesh.drawMode, object.mesh.indices.capacity ,GL_UNSIGNED_BYTE, 0);
    }else{
        
        if(object.frameIndex<object.mesh.frameCount){
            glDrawArrays(object.mesh.drawMode, 0, (object.mesh.vertexCount));
        }else{
            NSLog(@"[ERROR] current frame is %d and total frame count is %d",object.frameIndex,object.mesh.frameCount);
        }
    }
    /* --- --- --- */
    
    glDisableVertexAttribArray(_positionSlot);
    glDisableVertexAttribArray(_texCoordSlot);
    glDisable(GL_BLEND);
    
    // Enable depth buffer
    glEnable(GL_DEPTH_TEST);
    
}

-(void)setupParameters{
    
    _positionSlot = glGetAttribLocation(self.shader.handler, CGShaderParameter_position);
    _modelProjectionMatrixUniform = glGetUniformLocation(self.shader.handler, CGShaderParameter_ModelProjectionMatrix);
    
    _colorSlot =  glGetUniformLocation(self.shader.handler, CGShaderParameter_SourceColor);

    _texCoordSlot = glGetAttribLocation(self.shader.handler, CGShaderParameter_TextCoord);
    _textureUniform = glGetUniformLocation(self.shader.handler, CGShaderParameter_Texture);

    
}

@end
