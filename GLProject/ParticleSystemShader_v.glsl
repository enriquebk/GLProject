
attribute vec4 Position;
attribute vec4 sourceColor;

uniform mat4 viewMatrix;
uniform mat4 viewProjectionMatrix;

varying vec4 outColor;

void main(void) {
    vec4 cameraSpacePosition = viewMatrix  * Position;
    float d = length(cameraSpacePosition.xyz);
    gl_PointSize = 500.0*(1.0/(d*0.5 +d*d*0.001)); //Size in pixels

    outColor = sourceColor;
    
    gl_Position = viewProjectionMatrix  * Position;
}
