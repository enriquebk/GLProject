//
//  CGSceneGraph.m
//  GLProject
//
//  Created by Enrique Bermudez on 29/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGSceneGraph.h"

@implementation CGSceneGraph

-(id)init{
    self = [super init];
    if (self) {
        self.root = [[CGNode alloc] init];
        self.camera = [[CGCamera alloc] init]; 
    }
    return self;
}

-(void)renderSceneUsingEngine:(CGEngine*)engine{

    [self.root visit:engine];
}

@end
