//
//  CGNode.h
//  GLProject
//
//  Created by Enrique Bermudez on 29/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CC3GLMatrix.h"

@class CGRenderer;

#pragma mark -
#pragma mark Protocol CGDrawableNode

/**
 */
@protocol CGDrawableNode <NSObject>

@required

-(void)drawWithRenderer:(CGRenderer *)renderer;

@end

#pragma mark -
#pragma mark CGNode

@interface CGNode : NSObject

@property(strong)NSMutableArray* childs;

@property(strong)CGNode* parent;

@property(strong)CC3GLMatrix *matrix;

@property(assign,nonatomic)CC3Vector  position; //TODO: GET WORLD SPACE POSITION
@property(assign,nonatomic)CC3Vector  rotation;
@property(assign,nonatomic)CC3Vector  scale;

/**
 */
-(id)initWithParent:(CGNode*)parent;

/**
 */
- (void)addChild:(CGNode *)child;

/**
 */
- (CGNode*)getChildAtIndex:(int)index;

/**
 */
- (void)removeChid:(CGNode *)child;

/**
 */
- (void)removeChildAtIndex:(int)index;

/**
 */
-(void)removeAllChilds;

/**
 */
-(BOOL)isLeaf;

/**
 */
-(void)translate:(CC3Vector) aVector;

/**
 */
-(void)translateAroundLocalAxis:(CC3Vector) aVector;

/**
 */
-(void)rotate:(CC3Vector) aVector;

/**
 */
-(void)scale:(CC3Vector) aVector;

/**
 *  Returns the node's matrix applying parent's transformations.
 *
 *  @return A copy of the node's matrix with the parent's transformations.
 */
-(CC3GLMatrix *)transformedMatrix;

@end

