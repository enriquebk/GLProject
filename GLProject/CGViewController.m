//
//  CGViewController.m
//  GLProject
//
//  Created by Enrique Bermudez on 20/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGViewController.h"
#import "CGView.h"
#import "CGObject3D.h"
#import "MeshFactory.h"
#import "TextureManager.h"

@interface CGViewController (){

    CGView * cgview;
    float pos;
    CGObject3D* knight;
    
    float direction;
    CGObject3D* floor;
    
    CGObject3D* plane;
    
    CGLight* light;
}

@end

@implementation CGViewController


// An array with all the info for each vertex
const float Vertices[] = {
    0.5,  -0.5,   0.0,    0.0, 0.0, 1.0,   10.0, 0.0,
    0.5,   0.5,   0.0,    0.0, 0.0, 1.0,   10.0, 10.0,
    -0.5,   0.5,   0.0,    0.0, 0.0, 1.0,   0.0, 10.0,
    -0.5,  -0.5,   0.0,    0.0, 0.0, 1.0,   0.0, 0.0  };
//TODO: manage structures.. like Vertice...
GLubyte Indices[] = {
    0, 1, 2,
    2, 3, 0
};


- (void)viewDidLoad
{
    rotUp = false;
    rotDown  = false;
    rotRight = false;
    rotLeft = false;
    
    [super viewDidLoad];
    
    cgview =[[CGView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.glView addSubview:cgview];
    
    /*
    CGMesh* mesh = [[CGMesh alloc]
                    initWithVertexData:
                    [[CGFloatArray alloc] initWithData:(void*)Vertices
                                     withCapacity:8*4]];
    mesh.drawMode = GL_TRIANGLE_FAN;
    [MeshFactory addMesh:mesh withName:@"CGMeshplane"];
    floor= [[CGObject3D alloc] initWithMesh:[MeshFactory meshNamed:@"CGMeshplane"]];*/
    
    
    floor = [CGObject3D plane];
    
    [floor setTexture: [[TextureManager sharedInstance] textureFromFileName:@"tile_floor"]];
    [floor rotate:cc3v(-90, 0, 0)];
    [floor translate:cc3v(2.5, -7.1, -2.5)];
    [floor scale:CC3VectorMake(200, 200, 200)];
    floor.textureScale = 10.0f;
    [cgview.renderer addObject:floor];

    
    knight= [CGObject3D MD2ObjectNamed:@"knight"];

    [knight setTexture:[[TextureManager sharedInstance] textureFromFileName:@"knight.jpg"]];
    [knight rotate:cc3v(0, 0, 90)];
    [knight scale:CC3VectorMake(0.3, 0.3, 0.3)];
    //[knight setAnimationWithName:@"Stand"];
    [knight setAnimationWithName:@"Run"];
    //knight.color = (ccColor4F){1,0,1,0.5};
    [cgview.renderer addObject:knight];

    /*
     CGObject3D* w = [[CGObject3D alloc] initWithMesh:[MeshFactory meshMD2Named:@"weapon"]];
     [o addChild:w];
     [cgview.renderer addObject:w];
     */
    
    light = [[CGLight alloc] init];
    [light translate:cc3v(0, 10, 0)];
    [cgview.renderer addLight:light];

    //light.color = ccGREEN ;
    //light.intensity = 0.4;
   cgview.renderer.ambientLightIntensity = 0.7f;

    floor.specularFactor = 0.4;
    
    
    [cgview.renderer setClearColor:12.0f/255 g:183.0f/255 b:242.0f/255 a:1.0];
    [cgview.renderer.camera translate:CC3VectorMake(0,-2,0)];
    
    direction =1.0f;
    
    
    [self runLoop];
}


- (void)runLoop {
    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)render:(CADisplayLink*)displayLink {
    
    [cgview.renderer clear];
    
    [self hadleEvents:displayLink];
    
    
    // ANIMATION STUFF ////////////////////////
    //TODO: Clase que maneje las animaciones (Animation manager) por objeto; (animation completation)
    
    float pers = knight.animationCompletePercentage;
    
    if([knight.currentAnimation.name isEqualToString:@"Run"]){
        pers    += 0.015f;
        if(pers >1.0f){
            pers = 0.0f;
        }
    }else if([knight.currentAnimation.name isEqualToString:@"Stand"]){
        pers    += direction*0.01f;
        if(direction == 1.0f && knight.currentAnimation.finalFrame == knight.frameIndex){
            direction = -1.0f;
            pers    += direction*0.02f;
        }
        if(direction == -1.0f && knight.currentAnimation.initialFrame == knight.frameIndex &&pers <0.0f ){
            direction = 1.0f;
            pers    = 0.0f;
        }
    }
    
    knight.animationCompletePercentage = pers;
   [light translate:cc3v(0.00, 0.0, 0.1)];
    
    ////////////////////////////////////////////////////
    [cgview.renderer render];
}


//TODO: La rotacion de la camara anda mal (modificar pipeline? p*v*m*p?)
- (void)hadleEvents:(CADisplayLink*)displayLink{

    if(rotUp || rotDown || rotLeft || rotRight ){
        
        CC3Vector p = cgview.renderer.camera.position;
        CC3Vector r = cgview.renderer.camera.rotation;
        
        [ cgview.renderer.camera translate:CC3VectorMake(
                                                       -cgview.renderer.camera.position.x,
                                                       -cgview.renderer.camera.position.y,
                                                       -cgview.renderer.camera.position.z)];
        
        if(rotUp || rotDown ){
        
            //Respect the rotation YXZ order
            
            [ cgview.renderer.camera.viewMatrix rotateByY:-cgview.renderer.camera.rotation.y];
        
            [ cgview.renderer.camera rotate:CC3VectorMake(rotUp?-1:1,0,0)];
            
            [ cgview.renderer.camera.viewMatrix rotateByY:r.y];

        
        }else if(rotLeft || rotRight ){
            
            [ cgview.renderer.camera rotate:CC3VectorMake(0,rotLeft?-1:1,0)];
            
        }
        
        [ cgview.renderer.camera translate:CC3VectorMake( p.x, p.y, p.z)];
    }

    if(moveBwd || moveFwd){
        [ cgview.renderer.camera translate:CC3VectorMake(0, 0, moveFwd?0.1:-0.1)];
    }
    
    if(moveRight || moveLeft){
        [ cgview.renderer.camera translate:CC3VectorMake(moveRight?-0.1:0.1,0, 0)];
    }
}


- (IBAction)rotUpTouchUp:(id)sender {rotUp = false;}
- (IBAction)rotUpTouchDown:(id)sender {rotUp = true;}

- (IBAction)rotDownTouchUp:(id)sender{rotDown = false;}
- (IBAction)rotDownTouchDown:(id)sender{rotDown = true;}

- (IBAction)rotRightTouchUp:(id)sender{rotRight = false;}
- (IBAction)rotRightTouchDown:(id)sender{rotRight = true;}

- (IBAction)rotLeftTouchUp:(id)sender{rotLeft = false;}
- (IBAction)rotLeftTouchDown:(id)sender{rotLeft = true;}

- (IBAction)moveUpTouchUp:(id)sender{moveFwd = false;}
- (IBAction)moveUpTouchDown:(id)sender{moveFwd = true;}

- (IBAction)moveDownTouchUp:(id)sender{moveBwd = false;}
- (IBAction)moveDownTouchDown:(id)sender{moveBwd = true;}

- (IBAction)moveRightTouchUp:(id)sender{moveRight = false;}
- (IBAction)moveRightTouchDown:(id)sender{moveRight = true;}

- (IBAction)moveLeftTouchUp:(id)sender{moveLeft = false;}
- (IBAction)moveLeftTouchDown:(id)sender{moveLeft = true;}

@end
