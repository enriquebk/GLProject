//
//  CGObject3DNode.m
//  GLProject
//
//  Created by Enrique Bermudez on 29/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGObject3DNode.h"

/* Other implementation: A node may have an entity like ObjectEntiy LightEntity..*/
@implementation CGObject3DNode

-(void)visit{
    
    [self draw];
    
    [super visit];
}

-(void)draw{

}

@end
