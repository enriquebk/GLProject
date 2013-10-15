
// Vertex's attributes
attribute vec4 Position;
attribute vec2 TexCoordIn;
attribute vec4 nextFramePosition;

//'Constants'
uniform vec4 SourceColor;
uniform float kf_factor;
uniform mat4 modelViewProjectionMatrix;

//Fragment shader params
varying vec2 TexCoordOut;
varying vec4 DestinationColor;


void main(void) {
    
    DestinationColor = SourceColor;
    
    vec4 vertexPos;
    
    if(kf_factor != 0.0){
        vertexPos = mix(Position, nextFramePosition, kf_factor);
        vertexPos.w = 1.0;    //Make sure w is exactly 1.0
    }else{
        vertexPos = Position;
    }
    
    gl_Position = modelViewProjectionMatrix  * vertexPos;//Renombrar projection to PVMmatriz
    TexCoordOut = TexCoordIn; 
}