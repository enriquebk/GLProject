//
//  CGObject3D.h
//  GLProject
//
//  Created by Enrique Bermudez on 24/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGVertexBufferObject.h"
#import "CGTexture.h"
#import "CGShader.h"
#import "CGRender.h"
#import "CC3GLMatrix.h"

@class CGShader;
@class CGRender;

@interface CGObject3D : NSObject{

    
}

@property(strong)CC3GLMatrix *modelViewMatrix;

@property(strong)CGTexture* texture;

@property(strong)CGShader* shader;

@property(assign)BOOL visible;

@property(assign)int currentFrame;

@property(readonly)CGVertexType vertexType;

-(void)drawInRender:(CGRender*)render;


-(void)draw __attribute__((unavailable("You should always override this")));

@end
