//
//  CGSimpleShader.h
//  GLProject
//
//  Created by Enrique Bermudez on 26/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGShader.h"

#define  CGShaderParameter_SourceColor "SourceColor"

@interface CGSimpleShader : CGShader{

    GLuint _colorSlot;
}

@end
