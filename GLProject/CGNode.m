//
//  CGNode.m
//  GLProject
//
//  Created by Enrique Bermudez on 29/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGNode.h"

@interface CGNode (){

}

@end

@implementation CGNode

-(id)init{
    self = [super init];
    if (self) {
        self.childs = [[NSMutableArray alloc] init];
        self.parent = nil;
        self.matrix = [CC3GLMatrix identity];
    }
    return self;
}

-(id)initWithParent:(CGNode*)parent{
    self = [super init];
    
    if (self) {
        self.childs = [[NSMutableArray alloc] init];
        self.parent = parent;
        self.matrix = [CC3GLMatrix identity];
        
    }
    return self;
}

- (void)addChild:(CGNode *)child{
    child.parent = self;
    [self.childs addObject:child];
}

- (CGNode *)getChildAtIndex:(int)index{
    return (index <= [self.childs count]-1)?[self.childs objectAtIndex:index]:nil;
}

-(BOOL)isLeaf{
    return [self.childs count];
}

-(void)visit{
    for (CGNode* n in self.childs) {
        [n visit];
    }
}

-(void)translate:(CC3Vector) aVector{
    [self.matrix translateBy:aVector];
}

-(void)rotate:(CC3Vector) aVector{
    [self.matrix rotateBy:aVector];
}

-(void)scale:(CC3Vector) aVector{
    [self.matrix scaleBy:aVector];
}

- (void)removeChid:(CGNode *)child{
    [self.childs removeObject:child];
}

- (void)removeChildAtIndex:(int)index{
    [self.childs removeObjectAtIndex:index];
}

-(void)removeAllChilds{
    [self.childs removeAllObjects];
}

@end
