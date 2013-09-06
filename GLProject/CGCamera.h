//
//  CGCameraNode.h
//  GLProject
//
//  Created by Enrique Bermudez on 29/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGNode.h"


@interface CGCamera : CGNode

-(void) setCameraFrustumLeft: (GLfloat) left
                    andRight: (GLfloat) right
                   andBottom: (GLfloat) bottom
                      andTop: (GLfloat) top
                     andNear: (GLfloat) near
                      andFar: (GLfloat) far;


@end
