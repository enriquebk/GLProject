//
//  CGDefaultRenderProgram.h
//  GLProject
//
//  Created by Enrique Bermudez on 17/10/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGRenderProgram.h"

@interface CGDefaultRenderProgram : CGRenderProgram


-(void)setBlendFuncSourceFactor:(GLenum)sourceFactor destinationFactor:(GLenum) destinationFactor;

@end
