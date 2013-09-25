

#ifndef MD2LOADER_H
#define MD2LOADER_H


typedef float _Vec3[3];

//basado en  md2.c de David HENRY

struct Md2_header
{
    int ident;
    int version;
    
    int ancho_textura;
    int alto_textura;
    
    int framesize;
	
    int num_texturas;
    
    int num_vertices;
    //numero de coordenadas de texturas
    int num_uv;
    //numero de triangulos
    int num_triangulos;
    
    //numeros de comandos gl
    int num_glcmds;
    //cantidad de cuadros del modelo
    int num_frames;
    
    //desplazamientos necesarios para ubicar los datos
    int desplazamiento_texturas;
    int desplazamiento_st;
    int desplazamiento_triangulos;
    int desplazamiento_frames;
    int desplazamiento_glcmds;
    int desplazamiento_end;
};

/* Texture name */
struct Md2_textura
{
    //nobre de la textura.
    char name[64];
};

/* Texture coords */
struct Md2_texCoord
{
    short u;
    short v;
};

/* Triangle info */
struct Md2_triangle
{
    // vertices del triangulo
    unsigned short vertex[3];
    // coordenadas de textura del vertice
    unsigned short st[3];
};

/* Compressed vertex */
struct Md2_vertex
{
    //x, y, z
    unsigned char v[3];
    //indice de la nomral dentro de anomrs.h
    unsigned char normalIndex;
};

/* Model frame */
struct Md2_frame
{
    //transforamciones al frame
    _Vec3 scale;
    _Vec3 translate;
    
    //nombre del fame
    char name[16];
    
    //vertices del fame
    struct Md2_vertex *verts;
};

/* comandos gl (no importa) */
struct Md2_glcmd
{
    float s;
    float t;
    int index;
};

/* MD2 model structure */
struct Md2_model
{
    struct Md2_header header;
    
    struct Md2_textura *texturas;
    struct Md2_texCoord *texcoords;
    struct Md2_triangle *triangles;
    
    //frames del modelo
    struct Md2_frame *frames;
    
    //comandos gl(no importa)
    int *glcmds;
    
    //id de la textura
    unsigned int tex_id;
};


int readMd2File (const char *filename, struct Md2_model *modelo);

void FreeModel (struct Md2_model *modelo);

#endif 
