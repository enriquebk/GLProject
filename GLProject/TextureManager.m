//
//  TextureManager.m
//  HelloOpenGL
//
//  Created by Enrique Bermudez on 22/08/13.
//
//

#import "TextureManager.h"

@implementation TextureManager


static TextureManager* textureManager;

- (id)init{
    
    self = [super init];
    
    
    if(self){
        textures = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

+(id)sharedInstance{
    
    if(!textureManager){
        textureManager = [[TextureManager alloc] init];
    }
    
    return textureManager;
}

- (CGTexture*)textureFromFileName:(NSString *)fileName {
    
    
    CGTexture* texture = [textures objectForKey:fileName];
    if(texture){
        return texture;
    }
    
    // 1
    CGImageRef imageRef = [UIImage imageNamed:fileName].CGImage; //todo: remove image named
    if (!imageRef) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }
    
    // 2
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    
    CGContextRef imageContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4, CGImageGetColorSpace(imageRef), kCGImageAlphaPremultipliedLast);
    
    // 3
    CGContextDrawImage(imageContext, CGRectMake(0, 0, width, height), imageRef);
    
    CGContextRelease(imageContext);
    
    // 4
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    
    /* Texture propertys */
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    /* *** */
    
    free(spriteData);
    
    texture = [[CGTexture alloc] init];
    texture.filename = fileName;
    texture.handler = texName;
    
    [textures setValue:texture forKey:fileName];
    
    return texture;
    
}


@end
