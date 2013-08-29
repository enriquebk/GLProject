//
//  TextureManager.h
//  HelloOpenGL
//
//  Created by Enrique Bermudez on 22/08/13.
//
//

#import <Foundation/Foundation.h>
#import "CGTexture.h"

@interface TextureManager : NSObject{
    
    NSDictionary * textures;
}

+(id)sharedInstance;

- (CGTexture*)textureFromFileName:(NSString *)fileName;

@end
