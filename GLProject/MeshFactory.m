//
//  VBOsManager.m
//  HelloOpenGL
//
//  Created by Enrique Bermudez on 22/08/13.
//
//

#import "MeshFactory.h"
#include "MD2Loader.h"

/* Tabla de normales */
_Vec3 _anorms_table[162] = {
#include "anorms.h"
};


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
        
        int defaultStride = VBO_POSITION_SIZE +  VBO_NORMAL_SIZE + VBO_UV_SIZE;
        
        float floatsCount = defaultStride*pModeloAuxiliar->header.num_triangulos*3*pModeloAuxiliar->header.num_frames;
        
        float* vertices = (void*)malloc(sizeof(float)*floatsCount);
        
        int arrayIndex = 0;

        for(int i = 0; i< pModeloAuxiliar->header.num_frames; i++){
            
            struct Md2_frame *pframe;
            pframe = &(pModeloAuxiliar->frames[i]);
            
            
            NSLog( @"frame = %d  %@",i,[NSString stringWithUTF8String: pModeloAuxiliar->frames[i].name]);
            for( int j = 0; j< pModeloAuxiliar->header.num_triangulos; j++){
                
                struct Md2_triangle *ptri;
                struct Md2_vertex *pvert;
                
                ptri = &(pModeloAuxiliar->triangles[j]);
                
                for (int vIndex = 0; vIndex<3; vIndex++) {
                    
                    pvert = &(pframe->verts[ptri->vertex[vIndex]]);
                
                    //Position
                    vertices[arrayIndex++] = (float)((pframe->scale[2] * pvert->v[2]) + pframe->translate[2]);
                    vertices[arrayIndex++] = (float)((pframe->scale[1] * pvert->v[1]) + pframe->translate[1]);
                    vertices[arrayIndex++] = (float)((pframe->scale[0] * pvert->v[0]) + pframe->translate[0]);
                    
                    //Normals
                    
                    vertices[arrayIndex++] = _anorms_table[pvert->normalIndex][2];
                    vertices[arrayIndex++] = _anorms_table[pvert->normalIndex][1];
                    vertices[arrayIndex++] = _anorms_table[pvert->normalIndex][0];
                    

                    
                    //UV cords
                    vertices[arrayIndex++]  = (float)pModeloAuxiliar->texcoords[ptri->st[vIndex]].u / pModeloAuxiliar->header.ancho_textura;
                    vertices[arrayIndex++] = (float)pModeloAuxiliar->texcoords[ptri->st[vIndex]].v / pModeloAuxiliar->header.alto_textura;
                 }
            }
        }
        
        FreeModel (&modeloAuxiliar);
        
        m = [[CGMesh alloc]
                        initWithVertexData:
                        [[CGFloatArray alloc] initWithData:(void*)vertices
                                         withCapacity:floatsCount ]];
        
        m.frameCount =pModeloAuxiliar->header.num_frames;
        
        
        //TODO: Add missing animations
        [m.animations addObject: [[CGKeyFrameAnimation alloc] initWithName:@"Stand" initalFrame:0 finalFrame:8]];
        [m.animations addObject: [[CGKeyFrameAnimation alloc] initWithName:@"Run" initalFrame:40 finalFrame:45]];
        [m.animations addObject: [[CGKeyFrameAnimation alloc] initWithName:@"Attack" initalFrame:46 finalFrame:53]];
        [m.animations addObject: [[CGKeyFrameAnimation alloc] initWithName:@"Pain1" initalFrame:54 finalFrame:57]];
        [m.animations addObject: [[CGKeyFrameAnimation alloc] initWithName:@"Pain2" initalFrame:58 finalFrame:61]];
        
        [self addMesh:m withName:name];
    }else{
        
        NSLog(@"[ERROR] file %@.md2 not found ",name);
    }
    
    return m;
}




@end
