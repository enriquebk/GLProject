//
//  CGRenderer.h
//  GLProject
//
//  Created by Enrique Bermudez on 24/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CC3GLMatrix.h"
#import "CGObject3D.h"
#import "CGLight.h"
#import "CGCamera.h"

@class CGObject3D;
@class CGSceneGraph;

@interface CGRenderer : NSObject{ 
    
}

/**
 * Contains all the drawable nodes of the scene.
 */
@property(strong)NSMutableArray* displayList;

/**
 * Contains all the light in the scene.
 */
@property(strong)NSMutableArray* lights;

/**
 */
@property(strong) CGCamera* camera;

/**
 */
@property(assign)GLuint currentShaderHandler;

/**
 *  Background light color
 */
@property(assign)ccColor3B ambientLightColor;

/**
 *  Background level of light;
 */
@property(assign)float ambientLightIntensity;


/**
 *  Initializes the renderer.
 *  @param layer -.
 */
-(id)initWithLayer:(CAEAGLLayer*)layer;


/**
 *  Adds an object to the displayList.
 *  @param object Object to be added.
 */
-(void)addObject:(CGObject3D*)object;


/**
 *  Removess an object from the displayList.
 *  @param object Object to be removed.
 */
-(void)removeObject:(CGObject3D*)object;


/**
 *  Adds a node to the displayList.
 *  @param node Node to be added.
 */
-(void)addNode:(CGNode<CGDrawableNode>*)node;


/**
 *  Adds a node to the displayList.
 *  @param node Node to be added.
 */
-(void)removeNode:(CGNode<CGDrawableNode>*)node;


/**
 *  Adds a light to the render.
 *  @param light Light to be added.
 */
-(void)addLight:(CGLight*)light;


/**
 *  Adds a light to the render.
 *  @param light Light to be added.
 */
-(void)removeLight:(CGLight*)light;


/**
 *  Renders all the nodes in the displayList.
 */
-(void)render;

/**
 *  This function must be always called before the render function. 
 *  Clears the color buffer and the depht buffer.
 */
-(void)clear;

/**
 *  Sets clear color
 *  @param r Red chanel.
 *  @param g Green chanel.
 *  @param b Blue chanel.
 *  @param o Alpha chanel.
 */
-(void)setClearColor: (GLfloat)r g:(GLfloat)g b:(GLfloat)b a:(GLfloat)a;

/**
 *
 */
-(EAGLContext*)getGLContext;

@end


