//
//  CGEngine.m
//  GLProject
//
//  Created by Enrique Bermudez on 29/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGEngine.h"

@implementation CGEngine

-(id)initWithRender:(CGRender*)render{
    
    self = [super init];
    
    if(self){
        
        _render = render;
        self.sceneGraph = [[CGSceneGraph alloc] init];
        float h = 4.0f * _render.layer.frame.size.height / _render.layer.frame.size.width;
        [self.sceneGraph.camera setCameraFrustumLeft:-2 andRight:2 andBottom:-h/2 andTop:h/2 andNear:1 andFar:10];
        [self.sceneGraph.camera translate:CC3VectorMake(0, 0, -2)];
        
    }
    
    return self;
}

-(void)addObject:(CGObject3DNode*)o{
    
    [self.sceneGraph.root addChild:o];
}

-(void)removeObject:(CGObject3DNode*)o{
    
    [self.sceneGraph.root removeChid:o];
}

-(void)draw{

    [_render setClearColor:0.0 g:0.8 b:0.2 a:1.0];
    
    [_render clear];
    
    [_render render];
}

@end
