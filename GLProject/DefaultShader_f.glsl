
#define LIGHT_ON

#define LIGHTS_COUNT 1


uniform lowp vec4 ambient_light_color;
uniform lowp float ambienIntensity;

uniform lowp float specularIntensity;//Shiness
uniform lowp vec4 light_specular; //Object reflected Color

#ifdef LIGHT_ON

//Lights
struct Light {
	lowp vec3  position;
	lowp vec4  color;
    lowp float intensity;
};

uniform Light lights[LIGHTS_COUNT];

varying lowp vec4 pointPosition; //Punto en camera space
varying lowp vec3 pointNormal; //Normal en camera space

const lowp float k_shineFactor = 32.0;
#endif


//'Constants'
uniform sampler2D Texture;
uniform mediump vec4 color;
//Pre-calculeted values
varying lowp vec2 TexCoordOut;


void main(void) {
    
    

    
#ifdef LIGHT_ON
    
    lowp vec4 frag_diffuse= texture2D(Texture, TexCoordOut)*color;// Color del objeto

    lowp vec4 specular_factor = vec4(0.0,0.0,0.0,0.0);
    lowp vec4 diffuse_factor = vec4(0.0,0.0,0.0,0.0);
    
    ///////Lights
    
    lowp vec3 normal = normalize(pointNormal);
    
    for (int i = 0; i< LIGHTS_COUNT; i++) {
        
        lowp float lightIntensity = lights[i].intensity;
        
        lowp vec3 lightVector = (lights[i].position - pointPosition.xyz);
        lowp float lamberFactor  =  max( dot(normalize(lightVector), normal), 0.0 ); //Producto punto nos da el cos del angulo entere 2 vectores
        
        //Obtengo el color de la luz
        diffuse_factor = diffuse_factor + (lamberFactor * lights[i].color)* lightIntensity;// Color de la luz
        
        //Obtengo el reflejo
        lowp vec3 eye = normalize(-pointPosition.xyz);
        lowp vec3 reflection = normalize(eye + lightVector);//Forma economica de obtener el vector reflejo
        
        specular_factor = specular_factor +
        (min(max(pow(dot(reflection,normal), k_shineFactor), 0.0),1.0 )* light_specular*specularIntensity);//variable normal normalizada
        
        //TODO: Agregar disatancia despues de un tiempo q vaya iluminando menos
    }
    diffuse_factor.w = 1.0;
    
    /////////////
    
     gl_FragColor = specular_factor + frag_diffuse* (diffuse_factor + ambient_light_color*ambienIntensity);
#else
    
    gl_FragColor = texture2D(Texture, TexCoordOut)*color;
#endif


    
}