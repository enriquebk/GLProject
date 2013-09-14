//
//  CGView.h
//  GLProject
//
//  Created by Enrique Bermudez on 20/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#import "CGEngine.h"


@interface CGView : UIView{

    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;
    GLuint _colorRenderBuffer;

    GLuint _positionSlot;
    GLuint _colorSlot;
    
    CGEngine* engine;
    
    //matrix
    GLuint _projectionUniform;
    GLuint _modelViewUniform;
    float _currentRotation;
}


-(CGEngine*) engine;


@end
