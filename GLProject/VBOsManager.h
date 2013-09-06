//
//  VBOsManager.h
//  HelloOpenGL
//
//  Created by Enrique Bermudez on 22/08/13.
//
//

#import <Foundation/Foundation.h>
#import "CGVertexBufferObject.h"
#import "CGVertex.h"


@interface VBOsManager : NSObject {
    
    NSDictionary * VBOs;
}

+(id)sharedInstance;

-(CGVertexBufferObject*) VBOFromFile: (NSString*)filename; //Discriminate from extension

-(CGVertexBufferObject*) VBOFromKey: (NSString*)key;

-(CGVertexBufferObject*) addVBO:(GLfloat*)data withKey:(NSString*)key
                       withType:(CGVertexType) type;

-(CGVertexBufferObject*) addVBO:(GLfloat*)data withKey:(NSString*)key
                       withType:(CGVertexType) type indices:(GLvoid*)indices;

@end
