

attribute vec4 Position;
uniform float kf_factor;
attribute vec4 nextFramePosition;

//Texture stuff
attribute vec2 TexCoordIn;
uniform float textureScale;
varying vec2 TexCoordOut; //Fragment shader params

uniform mat4 modelViewProjectionMatrix;

void main(void) {

    vec4 vertexPos = mix(Position, nextFramePosition, kf_factor);
    vertexPos.w = 1.0;    //Make sure w is exactly 1.0

    gl_Position = modelViewProjectionMatrix  * vertexPos;
    
    TexCoordOut = TexCoordIn*textureScale;
    
}
