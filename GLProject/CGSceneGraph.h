//
//  CGSceneGraph.h
//  GLProject
//
//  Created by Enrique Bermudez on 29/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGNode.h"
#import "CGCameraNode.h"

@interface CGSceneGraph : NSObject

@property(strong) CGNode* root;

@property(strong) CGCameraNode* camera;

@end
