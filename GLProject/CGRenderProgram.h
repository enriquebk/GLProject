//
//  CGRenderProgram.h
//  GLProject
//
//  Created by Enrique Bermudez on 17/10/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGRenderer.h"
#import "CGShader.h"


@class CGObject3D;
@class CGRenderer;
@class CGShader;

@interface CGRenderProgram : NSObject 

@property(strong)CGShader* shader;

/* Override me */
-(void)drawObject:(CGObject3D*) object withRenderer:(CGRenderer*)renderer;

@end
