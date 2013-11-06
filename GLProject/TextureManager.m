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
    
    UIImage * img = [UIImage imageNamed:fileName]; //TODO: remoce image named
    
    // 1
    CGImageRef imageRef = img.CGImage;
    if (!imageRef) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }
    
    // 2
    size_t width = [self nearestPowerOf2: CGImageGetWidth(imageRef)];
    size_t height = [self nearestPowerOf2:CGImageGetHeight(imageRef)];
    
    void * spriteData =  malloc(width*height*4);
    
    [self copyImage:img toRawData:spriteData width:width height:height];
    
    // 4
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    
    /* Texture parameters */
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    /* *** */
    
    free(spriteData);
    
    texture = [[CGTexture alloc] init];
    texture.filename = fileName;
    texture.handler = texName;
    
    [textures setValue:texture forKey:fileName];
    
    return texture;
    
}


- (unsigned int) nearestPowerOf2:(unsigned int)value {
	unsigned int i;
	unsigned int po2Value = value;
	if ((po2Value != 1) && (po2Value & (po2Value - 1))) {
		i = 1;
		while (i < po2Value) {
			i *= 2;
		}
		po2Value = i;
	}
	return po2Value;
}

- (void) copyImage:(UIImage *)image toRawData:(void *)data width:(unsigned int)width height:(unsigned int)height {
	unsigned int imageWidth = CGImageGetWidth(image.CGImage);
	unsigned int imageHeight = CGImageGetHeight(image.CGImage);
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
	CGContextRef context = CGBitmapContextCreate(data, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
	CGColorSpaceRelease(colorSpace);
	CGContextClearRect(context, CGRectMake(0, 0, width, height));
	CGContextTranslateCTM(context, 0, height - imageHeight);
	CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
	CGContextRelease(context);
}

@end
