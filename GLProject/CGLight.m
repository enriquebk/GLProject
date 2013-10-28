//
//  CGLightNode.m
//  GLProject
//
//  Created by Enrique Bermudez on 29/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGLight.h"

@implementation CGLight

-(id)init{
    
    self = [super init];
    if(self){
        _active = true;
        _unAffectedObjects = [[NSMutableArray alloc] init];
        _color = ccc3(255, 255 , 255);
        _intensity = 1.0;
    }
    return self;
}


@end
