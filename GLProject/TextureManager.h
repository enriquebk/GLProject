//
//  TextureManager.h
//  HelloOpenGL
//
//  Created by Enrique Bermudez on 22/08/13.
//
//

#import <Foundation/Foundation.h>
#import "CGTexture.h"
#include <OpenGLES/ES2/gl.h>

@interface TextureManager : NSObject{
    
    NSMutableDictionary * textures;
}

+(id)sharedInstance;

- (CGTexture*)textureFromFileName:(NSString *)fileName;

@end
