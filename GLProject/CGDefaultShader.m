//
//  CGDefaultShader.m
//  GLProject
//
//  Created by Enrique Bermudez on 09/09/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGDefaultShader.h"
#import "CGTexture.h"

#define  CGShaderParameter_position         "Position"
#define  CGShaderParameter_projection       "modelViewProjectionMatrix"
#define  CGShaderParameter_SourceColor      "SourceColor"
#define  CGShaderParameter_TextCoord        "TexCoordIn"
#define  CGShaderParameter_Texture          "Texture"
#define  CGShaderParameter_NextFramePos     "nextFramePosition"
#define  CGShaderParameter_KeyframeFactor   "kf_factor"
#define  CGShaderParameter_TextureEnable    "TextureCount"

@interface CGDefaultShader (){
    
    GLuint _positionSlot;
    GLuint _texCoordSlot;
    GLuint _nextFramePosSlot;
    
    
    //Globals
    GLuint _colorSlot;
    GLuint _keyframeFactor;
    GLuint _projectionUniform;
    GLuint _textureUniform;
    GLuint _textureEnableUniform;
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
    
    //Habilito las variables de vertice (los uniforms no se habilitan)
    glEnableVertexAttribArray(_positionSlot);
    glEnableVertexAttribArray(_texCoordSlot);
    glEnableVertexAttribArray(_nextFramePosSlot);
    
    if ([object.textures count]>0) {
        CGTexture* t = [object.textures objectAtIndex:0];
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, t.handler);
        glUniform1i(_textureUniform, 0);
    }
    
    glBindBuffer(GL_ARRAY_BUFFER, [object.mesh VBOHandler]);
    
    CC3GLMatrix * _modelViewMatrix = [engine.camera.viewMatrix copy];//TODO: Optimizar...
    [_modelViewMatrix multiplyByMatrix:object.matrix];
    CC3GLMatrix * _modelViewProjectionMatrix = [engine.camera.porjectionMatrix copy];
    [_modelViewProjectionMatrix multiplyByMatrix:_modelViewMatrix];
    
    
    glUniformMatrix4fv(_projectionUniform, 1, 0, _modelViewProjectionMatrix.glMatrix);
    
    int frameOffset = ((object.frameIndex)*object.mesh.stride*object.mesh.vertexCount);
    
    
    // Position /////////////////////////////
    //Calls glVertexAttribPointer to feed the correct values to the two input variables for the vertex shader – the Position and SourceColor attributes.
    glVertexAttribPointer(_positionSlot, VBO_POSITION_SIZE, GL_FLOAT, GL_FALSE,
                          object.mesh.stride ,  (GLvoid*) (frameOffset + object.mesh.positionOffset));
    ////////////////////////////////////////
    
    
    // Color ///////////////////////////////
    glUniform4f(_colorSlot, object.color.r, object.color.g, object.color.b, object.color.a);
    ////////////////////////////////////////
    
    
    // TEXTURE_MAPPING ////////////////////
    if ([object.textures count]>0) {
        glUniform1f(_textureEnableUniform, [object.textures count]);
        glVertexAttribPointer(_texCoordSlot,VBO_UV_SIZE, GL_FLOAT, GL_FALSE,
                            object.mesh.stride,(GLvoid*) (frameOffset  + object.mesh.uvOffset));
    }else{
        glUniform1f(_textureEnableUniform, 0);
        glVertexAttribPointer(_texCoordSlot,1, GL_FLOAT, GL_FALSE,
                              1,(GLvoid*) (0));
    }
    //////////////////////////////////////
    
    
    // KEYFRAME_ANIMATION ////
    int nextFrameOffset = (object.mesh.frameCount>1?object.nextFrameOffSet:0);

    glVertexAttribPointer(_nextFramePosSlot, VBO_POSITION_SIZE,
                              GL_FLOAT, GL_FALSE,  object.mesh.stride  ,
                              (GLvoid*) ((object.frameIndex+nextFrameOffset)* object.mesh.stride*(object.mesh.vertexCount) ));

    glUniform1f(_keyframeFactor, (object.mesh.frameCount>1)?object.frameFactor:0.0f);
    //////////////////////////
    
    
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
    glDisableVertexAttribArray(_nextFramePosSlot);
}

-(void)setupParameters{
    
    _positionSlot = glGetAttribLocation(self.handler, CGShaderParameter_position);
    _projectionUniform = glGetUniformLocation(self.handler, CGShaderParameter_projection);
     
    _colorSlot =  glGetUniformLocation(self.handler, CGShaderParameter_SourceColor);
    _nextFramePosSlot= glGetAttribLocation(self.handler, CGShaderParameter_NextFramePos);
    _keyframeFactor = glGetUniformLocation(self.handler, CGShaderParameter_KeyframeFactor);
    
    _texCoordSlot = glGetAttribLocation(self.handler, CGShaderParameter_TextCoord);
    _textureUniform = glGetUniformLocation(self.handler, CGShaderParameter_Texture);
    _textureEnableUniform = glGetUniformLocation(self.handler, CGShaderParameter_TextureEnable);
}

@end
