
//uniform int lightsCount; como pasar lights count?
#define MAX_LIGHTS 4

uniform mediump vec4 ambient_light_color;
uniform mediump float ambienIntensity;

uniform mediump float specularIntensity;//Shiness
uniform mediump vec4 light_specular; //Object reflected Color

//Lights
struct Light {
	mediump vec3  position;
	mediump vec4  color;
    mediump float intensity;
};

uniform int lightsCount;
uniform Light lights[MAX_LIGHTS];

//'Constants'
uniform sampler2D Texture;
uniform int TextureCount;//move to int
uniform mediump vec4 SourceColor;
//Pre-calculeted values
varying lowp vec2 TexCoordOut;

varying mediump vec4 pointPosition; //Punto en camera space
varying mediump vec3 pointNormal; //Normal en camera space


const mediump float k_shineFactor = 32.0;

void main(void) {
    
    mediump vec4 frag_diffuse;

    if(TextureCount >= 1){
        frag_diffuse = texture2D(Texture, TexCoordOut)*SourceColor;// Color del objeto
    }else{
        frag_diffuse = SourceColor;
    }
    mediump vec4 specular_factor = vec4(0.0,0.0,0.0,0.0);
    mediump vec4 diffuse_factor = vec4(0.0,0.0,0.0,0.0);
    
    ///////Lights
    
    for (int i = 0; i< lightsCount; i++) {
        
        mediump float lightIntensity = lights[i].intensity;
        
        mediump vec3 lightVector = (lights[i].position - pointPosition.xyz);
        mediump float lamberFactor  =  max( dot(normalize(lightVector), normalize(pointNormal)), 0.0 ); //Producto punto nos da el cos del angulo entere 2 vectores
        
        //Obtengo el color de la luz
        diffuse_factor = diffuse_factor + (lamberFactor * lights[i].color)* lightIntensity;// Color de la luz
        
        //Obtengo el reflejo
        mediump vec3 eye = normalize(-pointPosition.xyz);
        mediump vec3 reflection = normalize(eye + lightVector);//Forma economica de obtener el vector reflejo
        
        specular_factor = specular_factor +
        (min(max(pow(dot(reflection,normalize(pointNormal)), k_shineFactor), 0.0),1.0 )* light_specular*specularIntensity);//variable normal normalizada
        
        //TODO: Agregar disatancia despues de un tiempo q vaya iluminando menos
    }
    diffuse_factor.w = 1.0;
    
    /////////////
    

    gl_FragColor = specular_factor + frag_diffuse* (diffuse_factor + ambient_light_color*ambienIntensity);
    
}