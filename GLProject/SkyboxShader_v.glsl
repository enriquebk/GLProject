

attribute vec4 Position;

//Texture stuff
attribute vec2 TexCoordIn;

varying vec2 TexCoordOut; //Fragment shader params

uniform mat4 modelViewProjectionMatrix;

void main(void) {

    gl_Position = modelViewProjectionMatrix  * Position;
    
    TexCoordOut = TexCoordIn;
    
}
