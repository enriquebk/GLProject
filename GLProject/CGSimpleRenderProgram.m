//
//  CGSimpleRenderProgram.m
//  GLProject
//
//  Created by Enrique Bermudez on 06/11/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

//

#import "CGSimpleRenderProgram.h"
#import "CGTexture.h"

#define  CGDefaultShaderKey    @"DefaultShader"

#define  CGShaderParameter_position                     "Position"
#define  CGShaderParameter_ModelViewProjectionMatrix    "modelViewProjectionMatrix"
#define  CGShaderParameter_SourceColor                  "color"
#define  CGShaderParameter_TextCoord                    "TexCoordIn"
#define  CGShaderParameter_Texture                      "Texture"
#define  CGShaderParameter_NextFramePos                 "nextFramePosition"
#define  CGShaderParameter_KeyframeFactor               "kf_factor"
#define  CGShaderParameter_TextureEnable                "TextureCount"
#define  CGShaderParameter_TextureScale                 "textureScale"

@interface CGSimpleRenderProgram (){
    
    GLuint _positionSlot;
    GLuint _nextFramePosSlot;

    GLuint _texCoordSlot;
    
    
    //Globals
    GLuint _colorSlot;
    GLuint _keyframeFactor;
    GLuint _modelViewProjectionMatrixUniform;
    
    GLuint _textureUniform;
    GLuint _textureScaleUniform;
    
    GLenum _blendFuncSourcefactor;
    GLenum _blendFuncDestinationfactor;

    //GLuint _ambientLightIntensity;
    
}

@end

@implementation CGSimpleRenderProgram


-(id)init{
    
    self = [super init];

    self.shader =[CGShader shaderNamed:@"SimpleShader"];
    
    [self setBlendFuncSourceFactor:GL_SRC_ALPHA destinationFactor:GL_ONE_MINUS_SRC_ALPHA];
    
    [self setupParameters];
    
    return self;
}

-(void)drawObject:(CGObject3D*) object withRenderer:(CGRenderer*)renderer{
    
    [super drawObject:object withRenderer:renderer];
    
    glEnable(GL_BLEND);
    glBlendFunc(_blendFuncSourcefactor, _blendFuncDestinationfactor);
    
    //Habilito las variables de vertice (los uniforms no se habilitan)
    glEnableVertexAttribArray(_positionSlot);
    glEnableVertexAttribArray(_texCoordSlot);
    glEnableVertexAttribArray(_nextFramePosSlot);
    
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, object.texture.handler);
    glUniform1i(_textureUniform, 0);
    
    
    glBindBuffer(GL_ARRAY_BUFFER, [object.mesh VBOHandler]);
    
    
    // Calculate modelViewMatrix & modelViewProjectionMatrix ///
    
    CC3GLMatrix * modelMatrix = [object transformedMatrix]; //World space
    
    CC3GLMatrix * modelViewMatrix = [renderer.camera.viewMatrix copy];
    
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
    
    glUniform1f(_textureScaleUniform, object.textureScale);
    
    
    // KEYFRAME_ANIMATION ////
    
    if (!object.mesh.indices) {
        int nextFrameOffset = (object.mesh.frameCount>1?object.nextFrameOffSet:0);
        //Next frame position and normal
        glVertexAttribPointer(_nextFramePosSlot, VBO_POSITION_SIZE,
                              GL_FLOAT, GL_FALSE,  object.mesh.stride  ,
                              (GLvoid*) ((object.frameIndex+nextFrameOffset)* object.mesh.stride*(object.mesh.vertexCount) ));
        
        glUniform1f(_keyframeFactor, (object.mesh.frameCount>1)?object.frameFactor:0.0f);
        
    }else{
        
        //Keyframe animation not supported for elements array
        int nextFrameOffset = 0;
        glVertexAttribPointer(_nextFramePosSlot, VBO_POSITION_SIZE,
                              GL_FLOAT, GL_FALSE,  object.mesh.stride  ,
                              (GLvoid*) ((object.frameIndex+nextFrameOffset)* object.mesh.stride*(object.mesh.vertexCount) ));
        
        glUniform1f(_keyframeFactor,0.0f);
    }
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
    glDisable(GL_BLEND);
    
}

-(void)setupParameters{
    
    _positionSlot = glGetAttribLocation(self.shader.handler, CGShaderParameter_position);
    _modelViewProjectionMatrixUniform = glGetUniformLocation(self.shader.handler, CGShaderParameter_ModelViewProjectionMatrix);
  
    _colorSlot =  glGetUniformLocation(self.shader.handler, CGShaderParameter_SourceColor);
    _nextFramePosSlot= glGetAttribLocation(self.shader.handler, CGShaderParameter_NextFramePos);
    _keyframeFactor = glGetUniformLocation(self.shader.handler, CGShaderParameter_KeyframeFactor);
    
    _texCoordSlot = glGetAttribLocation(self.shader.handler, CGShaderParameter_TextCoord);
    _textureUniform = glGetUniformLocation(self.shader.handler, CGShaderParameter_Texture);

    _textureScaleUniform = glGetUniformLocation(self.shader.handler, CGShaderParameter_TextureScale);
    
}

-(void)setBlendFuncSourceFactor:(GLenum)sourceFactor destinationFactor:(GLenum) destinationFactor{
    _blendFuncSourcefactor = sourceFactor;
    _blendFuncDestinationfactor = destinationFactor;
}

@end
