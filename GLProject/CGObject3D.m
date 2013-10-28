//
//  CGObject3DNode.m
//  GLProject
//
//  Created by Enrique Bermudez on 29/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGObject3D.h"
#import "CGDefaultRenderProgram.h"
#import "MeshFactory.h"

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
        _renderProgram = [[CGDefaultRenderProgram alloc] init];
        _textures = [[NSMutableArray alloc]init];
        _frameIndex = 0;
        _frameFactor = 0.0f;
        _nextFrameOffSet = 1;
        _color = CCC4FMake(1.0f, 1.0f, 1.0f, 1.0f);
        _textureScale =  1.0f;
        _specularFactor = 0.5f;
        _specularColor = ccc3(255, 255, 255);
    }
    
    return self;
}

-(void)drawWithRenderer:(CGRenderer *)renderer{
    
    [self.renderProgram drawObject:self withRenderer:renderer];
}

-(void) setTexture:(CGTexture*)texture{
    [self.textures insertObject:texture atIndex:0];
}

-(void)setAnimationCompletePercentage:(float)animationCompletePercentage{

    _frameIndex = floorf( _currentAnimation.initialFrame + ((float)(_currentAnimation.finalFrame + 1 - _currentAnimation.initialFrame))*(animationCompletePercentage));
    
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


+ (CGObject3D*) MD2ObjectNamed:(NSString*) filename{

    return [[CGObject3D alloc] initWithMesh:[MeshFactory meshMD2Named:filename]];
}

+ (CGObject3D*) plane{
 
    CGMesh* planeMesh = [MeshFactory meshNamed:@"CGPlane"];
    
    if(!planeMesh){
        const float vertexs[] = {
        //       position              normal       uv coords
        //    x      y       z      x    y    z      u    v
             0.5,  -0.5,   0.0,    0.0, 0.0, 1.0,   1.0, 0.0,
             0.5,   0.5,   0.0,    0.0, 0.0, 1.0,   1.0, 1.0,
            -0.5,   0.5,   0.0,    0.0, 0.0, 1.0,   0.0, 1.0,
            -0.5,  -0.5,   0.0,    0.0, 0.0, 1.0,   0.0, 0.0  };

        GLubyte indices[] = {
            0, 1, 2,
            2, 3, 0
        };
        int indicesCount = 6;
        int vertexsCount = 4;
        int floatsPerVertex = 8;
        int vertexDataFloatsCount = floatsPerVertex*vertexsCount;
        
        CGFloatArray* vertexData = [[CGFloatArray alloc] initWithData:(void*)vertexs withCapacity:vertexDataFloatsCount];
        
        CGFloatArray* indexData = [[CGFloatArray alloc] initWithData:(void*)indices withCapacity: indicesCount];
        
        planeMesh = [[CGMesh alloc] initWithVertexData: vertexData indices: indexData];
        
        planeMesh.drawMode = GL_TRIANGLE_FAN;
    }

    return [[CGObject3D alloc] initWithMesh:planeMesh];
}

+ (CGObject3D*) box{

    NSLog(@"method + (CGObject3D*) box - unimplemented");
    
    return nil;
}

@end
