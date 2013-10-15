//
//  CGCameraNode.h
//  GLProject
//
//  Created by Enrique Bermudez on 29/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CC3GLMatrix.h"
//#import "CGNode.h"


@interface CGCamera : NSObject

@property(strong)CC3GLMatrix *porjectionMatrix;
@property(strong)CC3GLMatrix *viewMatrix;

@property(assign,nonatomic)CC3Vector  position;
@property(assign,nonatomic)CC3Vector  rotation;
@property(assign,nonatomic)CC3Vector  scale;



-(void) setCameraFrustumLeft: (GLfloat) left
                    andRight: (GLfloat) right
                   andBottom: (GLfloat) bottom
                      andTop: (GLfloat) top
                     andNear: (GLfloat) near
                      andFar: (GLfloat) far;

/**
 */
-(void)translate:(CC3Vector) aVector;

/**
 */
-(void)translateAroundLocalAxis:(CC3Vector) aVector;

/**
 */
-(void)rotate:(CC3Vector) aVector;

/**
 */
-(void)scale:(CC3Vector) aVector;

@end
