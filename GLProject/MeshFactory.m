//
//  VBOsManager.m
//  HelloOpenGL
//
//  Created by Enrique Bermudez on 22/08/13.
//
//

#import "MeshFactory.h"
#include "MD2Loader.h"

@implementation MeshFactory

static MeshFactory* _meshFactory;

- (id)init{

    self = [super init];
    
    
    if(self){
        self.meshes = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

+(MeshFactory* )sharedInstance{
    
    if(!_meshFactory){
        _meshFactory = [[MeshFactory alloc] init];
    }
    
    return _meshFactory;
}


+(CGMesh*) meshNamed: (NSString*)name{

    return  [[MeshFactory sharedInstance].meshes  objectForKey:name];
}

+(void) addMesh:(CGMesh*)m withName:(NSString*)name{
    [[MeshFactory sharedInstance].meshes setObject:m forKey:name];
}

+(CGMesh*) meshMD2Named: (NSString*)name{
    
    CGMesh* m = [MeshFactory meshNamed:name];
    
    if(m){
        return m;
    }
    
    struct Md2_model modeloAuxiliar;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"md2"];
    
    if(readMd2File([filePath UTF8String], &modeloAuxiliar)){
        
        
        struct Md2_model *pModeloAuxiliar = &modeloAuxiliar;
        
        int defaultStride = 9;
        
        float floatsCount =defaultStride*pModeloAuxiliar->header.num_triangulos*3*pModeloAuxiliar->header.num_frames;
        
        float* vertices = (void*)malloc(sizeof(float)*floatsCount);
        
        int arrayIndex = 0;

        for(int i = 0; i< pModeloAuxiliar->header.num_frames; i++){
            
            struct Md2_frame *pframe;
            pframe = &(pModeloAuxiliar->frames[i]);
            
            for( int j = 0; j< pModeloAuxiliar->header.num_triangulos; j++){
                
                struct Md2_triangle *ptri;
                struct Md2_vertex *pvert;
                
                ptri = &(pModeloAuxiliar->triangles[j]);
                
                for (int vIndex = 0; vIndex<3; vIndex++) {
                    
                    pvert = &(pframe->verts[ptri->vertex[vIndex]]);
                
                //Position
                    vertices[arrayIndex++] = (float)pvert->v[0];
                    vertices[arrayIndex++] = (float)pvert->v[1];
                    vertices[arrayIndex++] = (float)pvert->v[2];
                //color
                    vertices[arrayIndex++] = 1.0f;
                    vertices[arrayIndex++] = 1.0f;
                    vertices[arrayIndex++] = 1.0f;
                    vertices[arrayIndex++] = 1.0f;
                //UV cords
                    vertices[arrayIndex++]  = (float)pModeloAuxiliar->texcoords[ptri->st[vIndex]].u / pModeloAuxiliar->header.ancho_textura;
                    vertices[arrayIndex++] = (float)pModeloAuxiliar->texcoords[ptri->st[vIndex]].v / pModeloAuxiliar->header.alto_textura;
                 }
            }
        }
        
        FreeModel (&modeloAuxiliar);
        
        m = [[CGMesh alloc]
                        initWithVertexData:
                        [[CGArray alloc] initWithData:(void*)vertices
                                         withCapacity:floatsCount ]];
        m.frameCount =pModeloAuxiliar->header.num_frames;
        
    }
    return m;
}




@end
