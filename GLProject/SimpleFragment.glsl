
//Pre-calculeted values
varying lowp vec4 DestinationColor;
varying lowp vec2 TexCoordOut;

//'Constants'
uniform sampler2D Texture;
uniform lowp float TextureCount;

void main(void) {
    
    if(TextureCount >= 1.0){
        gl_FragColor = DestinationColor * texture2D(Texture, TexCoordOut);
    }else{
        gl_FragColor = DestinationColor;
    }
}