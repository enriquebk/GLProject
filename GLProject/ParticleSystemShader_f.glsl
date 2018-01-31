
uniform sampler2D Texture;
varying lowp vec4 outColor;

void main(void) {
    gl_FragColor  = texture2D(Texture, gl_PointCoord)*outColor;
}
