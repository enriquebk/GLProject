//
//  CGDefaultRenderProgram.m
//  GLProject
//
//  Created by Enrique Bermudez on 17/10/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGDefaultRenderProgram.h"
#import "CGTexture.h"

#define  CGDefaultShaderKey    @"DefaultShader"

#define  CGShaderParameter_position                     "Position"
#define  CGShaderParameter_ModelViewProjectionMatrix    "modelViewProjectionMatrix"
#define  CGShaderParameter_ModelViewMatrix               "modelViewMatrix"
#define  CGShaderParameter_ViewMatrix                    "viewMatrix"
#define  CGShaderParameter_SourceColor                  "SourceColor"
#define  CGShaderParameter_TextCoord                    "TexCoordIn"
#define  CGShaderParameter_Texture                      "Texture"
#define  CGShaderParameter_NextFramePos                 "nextFramePosition"
#define  CGShaderParameter_KeyframeFactor               "kf_factor"
#define  CGShaderParameter_TextureEnable                "TextureCount"
#define  CGShaderParameter_TextureScale                 "textureScale"

@interface CGDefaultRenderProgram (){
    
    GLuint _positionSlot;
    GLuint _nextFramePosSlot;
    GLuint _normalSlot;
    GLuint _nextFrameNormalSlot;
    GLuint _texCoordSlot;
    
    
    //Globals
    GLuint _colorSlot;
    GLuint _keyframeFactor;
    GLuint _modelViewProjectionMatrixUniform;
    
    GLuint _modelViewMatrixUniform;
    GLuint _viewMatrixUniform;
    
    GLuint _textureUniform;
    GLuint _textureScaleUniform;
    GLuint _textureEnableUniform;
    
    GLenum _blendFuncSourcefactor;
    GLenum _blendFuncDestinationfactor;
    
    GLuint _lightPositionLocation[CGDefaultRenderProgram_max_lights];
    GLuint _lightColorLocation[CGDefaultRenderProgram_max_lights];
    GLuint _lightIntensityLocation[CGDefaultRenderProgram_max_lights];
    
    GLuint _ambientLightIntensity;
    GLuint _lightsCount;
    GLuint _ambientLightColor;
    GLuint _specularFactor;
    GLuint _specularColor;
    
}

@end

@implementation CGDefaultRenderProgram


-(id)init{
    
    self = [super init];
    
    self.shader = [CGShader shaderNamed:CGDefaultShaderKey];

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
    glEnableVertexAttribArray(_normalSlot);
    glEnableVertexAttribArray(_nextFrameNormalSlot);
    glEnableVertexAttribArray(_nextFramePosSlot);
    
    if ([object.textures count]>0) {
        CGTexture* t = [object.textures objectAtIndex:0];
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, t.handler);
        glUniform1i(_textureUniform, 0);
    }
    
    glBindBuffer(GL_ARRAY_BUFFER, [object.mesh VBOHandler]);
    
    
    // Calculate modelViewMatrix & modelViewProjectionMatrix ///
    
    CC3GLMatrix * modelMatrix = [object transformedMatrix];
    CC3GLMatrix * modelViewMatrix = [renderer.camera.viewMatrix copy];
    [modelViewMatrix multiplyByMatrix:modelMatrix];
    
    glUniformMatrix4fv(_modelViewMatrixUniform, 1, 0,modelViewMatrix.glMatrix);
    
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
    
    // Normals /////////////////////////////
    //Calls glVertexAttribPointer to feed the correct values to the two input variables for the vertex shader
    glVertexAttribPointer(_normalSlot, VBO_NORMAL_SIZE, GL_FLOAT, GL_FALSE,
                          object.mesh.stride ,  (GLvoid*) (frameOffset + object.mesh.normalOffset));
    /////////////////////////////////////////
    
    
    // Color ///////////////////////////////
    glUniform4f(_colorSlot, object.color.r, object.color.g, object.color.b, object.color.a);
    ////////////////////////////////////////
    
    
    // TEXTURE_MAPPING ////////////////////
    if ([object.textures count]>0) {
        glUniform1i(_textureEnableUniform, [object.textures count]);
        glVertexAttribPointer(_texCoordSlot,VBO_UV_SIZE, GL_FLOAT, GL_FALSE,
                              object.mesh.stride,(GLvoid*) (frameOffset  + object.mesh.uvOffset));
    }else{
        glUniform1i(_textureEnableUniform, 0);
        glVertexAttribPointer(_texCoordSlot,1, GL_FLOAT, GL_FALSE,
                              1,(GLvoid*) (0));
    }
    //////////////////////////////////////
    
    glUniform1f(_textureScaleUniform, object.textureScale);
    
    
    // KEYFRAME_ANIMATION ////
    
    if (!object.mesh.indices) {
        int nextFrameOffset = (object.mesh.frameCount>1?object.nextFrameOffSet:0);
        //Next frame position and normal
        glVertexAttribPointer(_nextFramePosSlot, VBO_POSITION_SIZE,
                          GL_FLOAT, GL_FALSE,  object.mesh.stride  ,
                          (GLvoid*) ((object.frameIndex+nextFrameOffset)* object.mesh.stride*(object.mesh.vertexCount) ));
        glVertexAttribPointer(_nextFrameNormalSlot, VBO_NORMAL_SIZE,
                              GL_FLOAT, GL_FALSE,  object.mesh.stride  ,
                              (GLvoid*) ((object.frameIndex+nextFrameOffset)* object.mesh.stride*(object.mesh.vertexCount)
                                         + object.mesh.normalOffset));
    
        glUniform1f(_keyframeFactor, (object.mesh.frameCount>1)?object.frameFactor:0.0f);
    }else{
        
        //Keyframe animation not supported for elements array
        int nextFrameOffset = 0;
        glVertexAttribPointer(_nextFramePosSlot, VBO_POSITION_SIZE,
                              GL_FLOAT, GL_FALSE,  object.mesh.stride  ,
                              (GLvoid*) ((object.frameIndex+nextFrameOffset)* object.mesh.stride*(object.mesh.vertexCount) ));
        
        glVertexAttribPointer(_nextFrameNormalSlot, VBO_NORMAL_SIZE,
                              GL_FLOAT, GL_FALSE,  object.mesh.stride  ,
                              (GLvoid*) ((object.frameIndex+nextFrameOffset)* object.mesh.stride*(object.mesh.vertexCount)
                                         + object.mesh.normalOffset));
        
        glUniform1f(_keyframeFactor,0.0f);
    }
    //////////////////////////
    
    // Lights ////////////////
    
    glUniform1f(_specularFactor,object.specularFactor);
    glUniform1f(_specularFactor,object.specularFactor);
    glUniform1f(_ambientLightIntensity,renderer.ambientLightIntensity ); //remove and stay with color?
    glUniform4f(_ambientLightColor, renderer.ambientLightColor.r/255.0f, renderer.ambientLightColor.g/255.0f,
                renderer.ambientLightColor.b/255.0f, 1.0f);
    glUniform4f(_specularColor, object.specularColor.r/255.0f, object.specularColor.g/255.0f, object.specularColor.b/255.0f, 1.0f);
    
    
    int lightIndex = 0;
    int lcount = 0;
    
    for (CGLight* l in [renderer lights]) {
        
        if(![l.unAffectedObjects containsObject:object]){
        
            lcount++;
        
            CC3GLMatrix * lightModelMatrix = [l transformedMatrix];
            CC3GLMatrix * lightModelViewMatrix = [renderer.camera.viewMatrix copy];
            [lightModelViewMatrix multiplyByMatrix:lightModelMatrix];
            
            GLfloat* m = lightModelViewMatrix.glMatrix;
            
            //Lights position in camera space
            glUniform3f(_lightPositionLocation[lightIndex],m[12],m[13],m[14]);
            
            glUniform4f(_lightColorLocation[lightIndex], l.color.r/255.0f,l.color.g/255.0f,l.color.b/255.0f, 1.0f);
            
            glUniform1f(_lightIntensityLocation[lightIndex], l.intensity);
                
         }
        
        if (lightIndex >= CGDefaultRenderProgram_max_lights-1) {
            break;
        }else{
            lightIndex ++;
        }
    }
    
    glUniform1i(_lightsCount, lcount);
    
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
    
    _positionSlot = glGetAttribLocation(self.shader.handler, CGShaderParameter_position);
    _modelViewProjectionMatrixUniform = glGetUniformLocation(self.shader.handler, CGShaderParameter_ModelViewProjectionMatrix);
    
    _modelViewMatrixUniform = glGetUniformLocation(self.shader.handler, CGShaderParameter_ModelViewMatrix);
    _viewMatrixUniform = glGetUniformLocation(self.shader.handler, CGShaderParameter_ViewMatrix);
    
    _colorSlot =  glGetUniformLocation(self.shader.handler, CGShaderParameter_SourceColor);
    _nextFramePosSlot= glGetAttribLocation(self.shader.handler, CGShaderParameter_NextFramePos);
    _keyframeFactor = glGetUniformLocation(self.shader.handler, CGShaderParameter_KeyframeFactor);
    
    _texCoordSlot = glGetAttribLocation(self.shader.handler, CGShaderParameter_TextCoord);
    _textureUniform = glGetUniformLocation(self.shader.handler, CGShaderParameter_Texture);
    _textureEnableUniform = glGetUniformLocation(self.shader.handler, CGShaderParameter_TextureEnable);
    
    _textureScaleUniform = glGetUniformLocation(self.shader.handler, CGShaderParameter_TextureScale);
 
    _normalSlot = glGetAttribLocation(self.shader.handler, "vertexNormal");
    
    
    _nextFrameNormalSlot = glGetAttribLocation(self.shader.handler,"nextFrameNormal");
    
    //Lights
    for (int i = 0; i < CGDefaultRenderProgram_max_lights; i++) {
        
		NSString * lightIndex = [NSString stringWithFormat:@"lights[%i].", i];
		
        _lightPositionLocation[i] =glGetUniformLocation(self.shader.handler,
                                                        [NSString stringWithFormat:@"%@position", lightIndex].UTF8String);
        _lightColorLocation[i] =glGetUniformLocation(self.shader.handler,
                                                        [NSString stringWithFormat:@"%@color", lightIndex].UTF8String);
        _lightIntensityLocation[i] = glGetUniformLocation(self.shader.handler,
                                                          [NSString stringWithFormat:@"%@intensity", lightIndex].UTF8String);
	}
    
    _ambientLightIntensity = glGetUniformLocation(self.shader.handler, "ambienIntensity");
    _ambientLightColor = glGetUniformLocation(self.shader.handler, "ambient_light_color");
    _lightsCount = glGetUniformLocation(self.shader.handler, "lightsCount");
    _specularFactor = glGetUniformLocation(self.shader.handler, "specularIntensity");
    _specularColor = glGetUniformLocation(self.shader.handler, "light_specular");

}

-(void)setBlendFuncSourceFactor:(GLenum)sourceFactor destinationFactor:(GLenum) destinationFactor{
    _blendFuncSourcefactor = sourceFactor;
    _blendFuncDestinationfactor = destinationFactor;
}

@end