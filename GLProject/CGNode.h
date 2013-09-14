//
//  CGNode.h
//  GLProject
//
//  Created by Enrique Bermudez on 29/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CC3GLMatrix.h"


@class CGEngine;

@interface CGNode : NSObject

@property(strong)NSMutableArray* childs;

@property(strong)CGNode* parent;

@property(strong)CC3GLMatrix *matrix;

@property(assign)CC3Vector  position;
@property(assign)CC3Vector  rotation;
@property(assign)CC3Vector  scale;

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
-(void)visit:(CGEngine*)engine;

/**
 */
-(void)renderUsingEngine:(CGEngine*)engine;

/**
 */
-(void)translate:(CC3Vector) aVector;

/**
 */
-(void)rotate:(CC3Vector) aVector;

/**
 */
-(void)scale:(CC3Vector) aVector;

/* Update:delta propagable ? como cocos2d*/

@end
