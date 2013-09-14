//
//  VBOsManager.m
//  HelloOpenGL
//
//  Created by Enrique Bermudez on 22/08/13.
//
//

#import "MeshFactory.h"

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

+(CGMesh*) meshMD2Named: (NSString*)name{
    
    CGMesh* m = [MeshFactory meshNamed:name];
    
    if(m){
        return m;
    }
    
    //Load MD2
    
    return m;
}


+(void) addMesh:(CGMesh*)m withName:(NSString*)name{
    [[MeshFactory sharedInstance].meshes setObject:m forKey:name];
}



@end
