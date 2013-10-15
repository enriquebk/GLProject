//
//  CGFloatArray.m
//  GLProject
//
//  Created by Enrique Bermudez on 05/09/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGArray.h"

@interface CGArray (){
    
    void* _array;
    unsigned int _capacity;
}

@end


@implementation CGArray


- (id) initWithData:(void *)array withCapacity:(unsigned int)capacity{
    self = [super init];
    
    _array = malloc(capacity*sizeof(float));
    memcpy( _array, array, capacity*sizeof(float));
    _capacity = capacity;
    
    return self;
}

- (void *) array{

    return _array;
}

- (unsigned int) capacity{

    return _capacity;
}


@end
