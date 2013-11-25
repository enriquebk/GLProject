//
//  MeshFactory.h
//  CGRender 
//
//  Created by Enrique Bermudez on 22/08/13.
//
//

#import <Foundation/Foundation.h>
#import "CGMesh.h"


@interface MeshFactory : NSObject

/**
 * Contains all the stored meshes.
 */
@property(strong)NSMutableDictionary * meshes;

/**
 * MeshFactory static instance.
 * 
 * @return The static instance.
 */
+(MeshFactory* )sharedInstance;

/**
 * Gets a mesh stored with a given key. If the mesh was not
 * stored the [code]name[/code] is taken as a filename and it's
 * loaded and stored in the [code]meshes[/code] NSMutableDictionary
 * with the filename as the key.
 *
 * @param name key of the mesh.
 * @return The mesh. If there is no mesh stored in the code]meshes[/code] NSMutableDictionary
 *  with the given key or there is no file with that filename the method will return nill.
 */
+(CGMesh*) meshNamed: (NSString*)name;

/**
 * Adds a mesh with a given key.
 *
 * @param mesh The mesh.
 * @param name key of the mesh.
 */
+(void) addMesh:(CGMesh*)mesh withName:(NSString*)name;







//Remove:
+(CGMesh*) meshMD2Named: (NSString*)name;// remove
//+(CGMesh*) meshOBJNamed: (NSString*)name;

@end
