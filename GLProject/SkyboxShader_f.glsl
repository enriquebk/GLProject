
//'Constants'
uniform sampler2D Texture;
uniform mediump vec4 color;
//Pre-calculeted values
varying highp vec2 TexCoordOut;


void main(void) {
    
    gl_FragColor = texture2D(Texture, TexCoordOut)*color;

}