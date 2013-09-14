//
//  VBOsManager.h
//  HelloOpenGL
//
//  Created by Enrique Bermudez on 22/08/13.
//
//

#import <Foundation/Foundation.h>
#import "CGMesh.h"


@interface MeshFactory : NSObject {
    
    
}

@property(strong)NSMutableDictionary * meshes;

+(MeshFactory* )sharedInstance;

+(CGMesh*) meshNamed: (NSString*)name;

+(CGMesh*) meshMD2Named: (NSString*)name;

+(void) addMesh:(CGMesh*)m withName:(NSString*)name;

//+(CGMesh*) meshOBJNamed: (NSString*)name;

@end
