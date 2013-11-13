//
//  CGParticle.m
//  GLProject
//
//  Created by Enrique Bermudez on 28/10/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGParticle.h"

@interface CGParticle () 

@end

@implementation CGParticle


-(id)init{
    
    if(self = [super init]){
        [self setUpValues];
    }
    return  self;
}

-(void)setUpValues{
    _timeAlive = 0;
    self.movementDirection = CC3VectorMake((double)rand() / (double)RAND_MAX, (double)rand() / (double)RAND_MAX, (double)rand() / (double)RAND_MAX);
    self.position = CC3VectorMake(0.0f,0.0f,0.0f);
    self.startPosition = CC3VectorMake(0.0f,0.0f,0.0f);
    //self.color = CCC4FMake((double)rand() / (double)RAND_MAX, (double)rand() / (double)RAND_MAX, (double)rand() / (double)RAND_MAX, 1.0f);
    self.color = rand()%2 ? CCC4FMake(0.5,0.5,0.0, 1.0f):CCC4FMake(1,0.1,0.05, 1.0f);
}

@end
