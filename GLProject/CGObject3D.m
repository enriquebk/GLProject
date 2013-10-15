//
//  CGObject3DNode.m
//  GLProject
//
//  Created by Enrique Bermudez on 29/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGObject3D.h"
#import "CGDefaultShader.h"

@interface CGMesh (){
    
    int currentFrame;
    float deltaFrame;
}

@end


@implementation CGObject3D

-(id)initWithMesh:(CGMesh*)mesh{

    self = [super init];
    
    if(self){
        _mesh = mesh;
        _shaderProgram = [[CGDefaultShader alloc] init];
        _textures = [[NSMutableArray alloc]init];
        _frameIndex = 0;
        _frameFactor = 0.0f;
        _nextFrameOffSet = 1;
        _color = (ccColor4F){1.0,1.0,1.0,1.0};
    }
    
    return self;
}

-(void)renderUsingEngine:(CGEngine *)engine{
    
    [self.shaderProgram drawObject:self usingEngine:engine];
}

-(void) setTexture:(CGTexture*)texture{
    [self.textures insertObject:texture atIndex:0];
}

-(void)setAnimationCompletePercentage:(float)animationCompletePercentage{

    _frameIndex = _currentAnimation.initialFrame + ((float)(_currentAnimation.finalFrame + 1 - _currentAnimation.initialFrame))*(animationCompletePercentage);
    
    _frameFactor = fabsf((float)(_frameIndex-_currentAnimation.initialFrame) - (_currentAnimation.finalFrame + 1 - _currentAnimation.initialFrame)*animationCompletePercentage);

    if(_frameIndex==_currentAnimation.finalFrame){
        _nextFrameOffSet = (_currentAnimation.initialFrame-_currentAnimation.finalFrame);
    }else{
        _nextFrameOffSet = 1;
    }

    _animationCompletePercentage = animationCompletePercentage;
}

-(void)setAnimationWithName:(NSString*)animationName{

    for (CGKeyFrameAnimation* animation in self.mesh.animations) {
        if([animation.name isEqual:animationName]){
            self.currentAnimation = animation;
            return;
        }
    }
    
    NSLog(@"[Error] Animation with name %@ was not found",animationName);
}


@end
