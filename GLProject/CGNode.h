//
//  CGNode.h
//  GLProject
//
//  Created by Enrique Bermudez on 29/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGNode.h"
#import "CC3GLMatrix.h"

@interface CGNode : NSObject

@property(strong)NSMutableArray* childs;

@property(strong)CGNode* parent;

@property(strong)CC3GLMatrix *matrix;

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
-(void)visit;

/**
 */
-(void)translate:(CC3Vector) aVector;

/**
 */
-(void)rotate:(CC3Vector) aVector;

/**
 */
-(void)scale:(CC3Vector) aVector;

@end
