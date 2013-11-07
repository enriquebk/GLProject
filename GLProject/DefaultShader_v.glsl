
//#define LIGHT_ON

// Vertex's attributes
attribute vec4 Position;
attribute vec3 vertexNormal;
uniform float kf_factor;
attribute vec4 nextFramePosition;
attribute vec3 nextFrameNormal;

//Texture stuff
attribute vec2 TexCoordIn;
uniform float textureScale;
varying vec2 TexCoordOut; //Fragment shader params


uniform mat4 modelViewProjectionMatrix;
uniform mat4 modelViewMatrix;

#ifdef LIGHT_ON
varying vec4 pointPosition; //Punto en camera space
varying vec3 pointNormal;//Normal en camera space
#endif

void main(void) {

    vec4 vertexPos = mix(Position, nextFramePosition, kf_factor);
    vertexPos.w = 1.0;    //Make sure w is exactly 1.0

#ifdef LIGHT_ON
    pointNormal = mix(vertexNormal, nextFrameNormal, kf_factor);
    pointPosition = modelViewMatrix*vertexPos;
    pointNormal = mat3(modelViewMatrix)*pointNormal;//Operamos solo con xyz para no contemlar la trasalacion y asi no deformar el vector//TODO normalizar
#endif
    gl_Position = modelViewProjectionMatrix  * vertexPos;
    
    TexCoordOut = TexCoordIn*textureScale;
    
}
