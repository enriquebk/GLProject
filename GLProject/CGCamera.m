//
//  CGCameraNode.m
//  GLProject
//
//  Created by Enrique Bermudez on 29/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGCamera.h"

@implementation CGCamera


-(void) setCameraFrustumLeft: (GLfloat) left
                    andRight: (GLfloat) right
                   andBottom: (GLfloat) bottom
                      andTop: (GLfloat) top
                     andNear: (GLfloat) near
                      andFar: (GLfloat) far{
    
    [self.matrix populateFromFrustumLeft:left andRight:right andBottom:bottom andTop:top andNear:near andFar:far];
}
@end
