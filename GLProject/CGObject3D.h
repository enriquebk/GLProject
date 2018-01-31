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

@property(strong)CGMesh* mesh;

@property(strong)CGRenderProgram* renderProgram;

-(id) initWithMesh:(CGMesh*)mesh;


#pragma mark -
#pragma mark Texture stuff

@property(strong)CGTexture* texture;

@property(assign)float textureScale;


#pragma mark -
#pragma mark Material stuff


@property(assign)bool lightAffected;

/*
 * Specular reflection, the shine of polished or metallic surfaces (value between 0.0 - 1.0).
 */
@property(assign)float specularFactor;

/*
 * Specular reflection color.
 */
@property(assign)ccColor3B specularColor;

/**
 *  Object's color
 */
@property(assign)ccColor4F color;

#pragma mark -
#pragma mark Animation stuff

-(void)setAnimationWithName:(NSString*)animationName;

@property(strong)CGKeyFrameAnimation* currentAnimation;

@property(nonatomic, assign)float animationCompletePercentage;

@property(assign)int    nextFrameOffSet;

@property(assign)int    frameIndex;

@property(assign)float  frameFactor;


#pragma mark -
#pragma mark Object from 3D Format

+ (CGObject3D*) MD2ObjectNamed:(NSString*) filename;

//+ (CGObject3D*) waveFontObjectNamed:(NSString*) filename;

#pragma mark -
#pragma mark Primitives

+ (CGObject3D*) plane;
+ (CGObject3D*) cube;
//+ (CGObject3D*) sphere;

@end
