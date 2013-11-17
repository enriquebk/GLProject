//
//  CGSkybox.m
//  GLProject
//
//  Created by Enrique Bermudez on 07/11/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGSkybox.h"
#import "CGObject3D.h"
#import "TextureManager.h"
#import "CGSkyboxRender.h"

@interface CGSkybox (){

    CGObject3D* face1;
    CGObject3D* face2;
    CGObject3D* face3;
    CGObject3D* face4;
    CGObject3D* face5;
    CGObject3D* face6;
    
    CGSkyboxRender* skyboxRender;
}

@end

@implementation CGSkybox

-(id)init{
    
    if(self = [super init]){
        
        skyboxRender  = [[CGSkyboxRender alloc] init];
        
        float size = 100;
        float scale = size + 0.2;
        
        face1 = [CGObject3D plane];
        [face1 setTexture: [[TextureManager sharedInstance] textureFromFileName:@"skyrender0001.png"]];
        [face1 translate:cc3v(0.0,0.0, -size/2)];
        [face1 scale:cc3v(scale,scale , scale)];
        [face1 rotate:cc3v(0,0 , 0)];
        
        face2 = [CGObject3D plane];
        [face2 setTexture: [[TextureManager sharedInstance] textureFromFileName:@"skyrender0002.png"]];
        [face2 translate:cc3v(-size/2,0.0, 0)];
        [face2 scale:cc3v(scale,scale , scale)];
        [face2 rotate:cc3v(0,90, 0)];
        
        face3 = [CGObject3D plane];
        [face3 setTexture: [[TextureManager sharedInstance] textureFromFileName:@"skyrender0005.png"]];
        [face3 translate:cc3v(size/2,0.0, 0)];
        [face3 scale:cc3v(scale,scale , scale)];
        [face3 rotate:cc3v(0,-90, 0)];
        
        face4 = [CGObject3D plane];
        [face4 setTexture: [[TextureManager sharedInstance] textureFromFileName:@"skyrender0006.png"]];
        [face4 translate:cc3v(0,-size/2, 0)];
        [face4 scale:cc3v(scale,scale , scale)];
        [face4 rotate:cc3v(-90,0, -90)];
        
        face5 = [CGObject3D plane];
        [face5 setTexture: [[TextureManager sharedInstance] textureFromFileName:@"skyrender0003.png"]];
        [face5 translate:cc3v(0,size/2, 0)];
        [face5 scale:cc3v(scale,scale , scale)];
        [face5 rotate:cc3v(90,0, 90)];
        
        face6 = [CGObject3D plane];
        [face6 setTexture: [[TextureManager sharedInstance] textureFromFileName:@"skyrender0004.png"]];
        [face6 translate:cc3v(0,0.0, size/2)];
        [face6 scale:cc3v(scale,scale , scale)];
        [face6 rotate:cc3v(0,180, 0)];
        
        
    }
    return  self;
}

-(void)setColor:(ccColor4F) color{

    face1.color = color;
    face2.color = color;
    face3.color = color;
    face4.color = color;
    face5.color = color;
    face6.color = color;
}

-(void)drawWithRenderer:(CGRenderer *)renderer{

    
    [skyboxRender drawObject:face1 withRenderer:renderer];
    [skyboxRender drawObject:face2 withRenderer:renderer];
    [skyboxRender drawObject:face3 withRenderer:renderer];
    [skyboxRender drawObject:face4 withRenderer:renderer];
    [skyboxRender drawObject:face5 withRenderer:renderer];
    [skyboxRender drawObject:face6 withRenderer:renderer];
    
    glClear (GL_DEPTH_BUFFER_BIT);
    
     //[renderer.getGLContext presentRenderbuffer:GL_RENDERBUFFER];
}

-(NSComparisonResult)compareBeforeRender:(CGNode*)node{
    
    return NSOrderedAscending;
}


@end
