//
//  CGLightNode.h
//  GLProject
//
//  Created by Enrique Bermudez on 29/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGNode.h"

@interface CGLight : CGNode

@property(assign)ccColor3B color;

@property BOOL active;

@property float intensity;

@property(strong)NSMutableArray* unAffectedObjects;

@end
