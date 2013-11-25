/* 
 * Constants
 */

// Object's texture
uniform sampler2D texture;

// Object's color
uniform mediump vec4 color;

/*
 * Pre-calculeted values 
 */

// Fragment's uv coords
varying lowp vec2 texCoordOut;


void main(void) {
    
    gl_FragColor = texture2D(Texture, TexCoordOut)*color;

}