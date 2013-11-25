/*
 * Vertex attributes 
 */

// Vertex's position
attribute vec4 position;

// Vertex's coord uv
attribute vec2 texCoordIn;

/* 
 * Constants 
 */

// Object's transformation matrix
uniform mat4 transformationMatrix;

/*
 * Fragment shader params
 */

varying vec2 texCoordOut;

void main(void) {

    texCoordOut = texCoordIn;
    
    gl_Position = transformationMatrix  * position;
    
}
