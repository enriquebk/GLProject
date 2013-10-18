//
//  CGObject3DNode.h
//  GLProject
//
//  Created by Enrique Bermudez on 29/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGNode.h"
#import "CGMesh.h"
#import "CGRenderProgram.h"
#import "CGTexture.h"

@class CGRenderProgram;


@interface CGObject3D : CGNode


@property(assign)ccColor4F color;

@property(strong)CGMesh* mesh;

@property(strong)CGRenderProgram* renderProgram;

-(id) initWithMesh:(CGMesh*)mesh;


#pragma mark -
#pragma mark Texture stuff

@property(strong)NSMutableArray* textures;

-(void) setTexture:(CGTexture*)texture;


#pragma mark -
#pragma mark Animation stuff


-(void)setAnimationWithName:(NSString*)animationName;

@property(strong)CGKeyFrameAnimation* currentAnimation;

@property(nonatomic, assign)float animationCompletePercentage;

@property(assign)int    nextFrameOffSet;

@property(assign)int    frameIndex;

@property(assign)float  frameFactor;


@end
