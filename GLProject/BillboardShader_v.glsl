
attribute vec4 Position;
//Texture stuff
attribute vec2 TexCoordIn;
varying vec2 TexCoordOut;

uniform mat4 modelProjectionMatrix;

void main(void) {

    gl_Position = modelProjectionMatrix  * (Position) ;
    
    TexCoordOut = TexCoordIn;
    
}
