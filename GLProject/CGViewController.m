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
#import "CGParticleSystem.h"

#import "CGSimpleRenderProgram.h"

@interface CGViewController (){

    CGView * cgview;
    CGRenderer* renderer;
    float pos;
    CGObject3D* knight;
    
    float direction;
    CGObject3D* floor;
    
    CGObject3D* plane;
    
    CGLight* light;
    
    double currentTime;
	double renderTime;
    double frameTimestamp;
    
    CGParticleSystem* particleSystem;

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
    
    renderer = cgview.renderer;
    
    /*
    CGMesh* mesh = [[CGMesh alloc]
                    initWithVertexData:
                    [[  alloc] initWithData:(void*)Vertices
                                     withCapacity:8*4]];
    mesh.drawMode = GL_TRIANGLE_FAN;
    [MeshFactory addMesh:mesh withName:@"CGMeshplane"];
    floor= [[CGObject3D alloc] initWithMesh:[MeshFactory meshNamed:@"CGMeshplane"]];*/
    
    
    floor = [CGObject3D plane];
    
    [floor setTexture: [[TextureManager sharedInstance] textureFromFileName:@"grassTexture.jpg"]];
    [floor rotate:cc3v(-90, 0, 0)];
    [floor translate:cc3v(2.5, -7.1, -2.5)];
    [floor scale:CC3VectorMake(200, 200, 200)];
    floor.textureScale = 10.0f;
    [renderer addObject:floor];

    
    knight= [CGObject3D MD2ObjectNamed:@"knight"];

    [knight setTexture:[[TextureManager sharedInstance] textureFromFileName:@"knight.jpg"]];
    [knight rotate:cc3v(0, 0, 90)];
    [knight scale:CC3VectorMake(0.3, 0.3, 0.3)];
    //[knight setAnimationWithName:@"Stand"];
    [knight setAnimationWithName:@"Run"];
    //knight.color = (ccColor4F){1,0,1,0.5};
    knight.specularFactor = 1.0f;
    [renderer addObject:knight];
    //[knight translate:CC3VectorMake(0.0, 10, 0.0)];
    /*
     CGObject3D* w = [[CGObject3D alloc] initWithMesh:[MeshFactory meshMD2Named:@"weapon"]];
     [o addChild:w];
     [cgview.renderer addObject:w];
     */
    
    light = [[CGLight alloc] init];
    light.intensity = 0.7f;
    [light translate:cc3v(0, 10, 0)];
    [renderer addLight:light];
    
    
    CGLight* light2= [[CGLight alloc] init];
    light2.intensity = 1.9f;
    [light2 translate:cc3v(0, 10, 2)];
    light2.color = ccc3(255, 0,10);
    [renderer addLight:light2];

    //[light.unAffectedObjects addObject:floor];
    //light.color = ccGREEN ;
    //light.intensity = 0.4;
    
    renderer.ambientLightIntensity = 0.1f;

    floor.specularFactor = 0.2;
    //floor.lightAffected = NO;
   // [light.unAffectedObjects addObject: floor];
    //floor.renderProgram = [[CGSimpleRenderProgram alloc]init];
    
    
    [renderer setClearColor:12.0f/255 g:183.0f/255 b:242.0f/255 a:1.0];
    [renderer.camera translate:CC3VectorMake(0,-2,0)];
    
    direction =1.0f;

    CGObject3D* sky = [CGObject3D plane];
    [sky setTexture: [[TextureManager sharedInstance] textureFromFileName:@"SkyBox-Clouds-front.png"]];
    [sky translate:cc3v(0.0,-5.0, -40)];
    [sky scale:cc3v(150,150 , 150)];
    [sky rotate:cc3v(0,0 , 180)];
    [renderer addObject:sky];
    sky.lightAffected = NO;
    //sky.renderProgram = [[CGSimpleRenderProgram alloc]init];
    
    particleSystem = [[CGParticleSystem alloc] init];
    [particleSystem startEmission];
    [particleSystem translate:CC3VectorMake(0, 10, 0)];
    [renderer addNode:particleSystem];
    
    
    [self runLoop];
}


- (void)runLoop {
    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    frameTimestamp = CACurrentMediaTime();
}

- (void)render:(CADisplayLink*)displayLink {
    
    
    currentTime = CFAbsoluteTimeGetCurrent();
    renderTime = (currentTime - frameTimestamp);
    
	frameTimestamp = currentTime;
    
    [renderer clear];
    
    [self hadleEvents:displayLink];
    
    
    [particleSystem update:renderTime];
    
    // ANIMATION STUFF ////////////////////////
    //TODO: Clase que maneje las animaciones (Animation manager) por objeto; (animation completation)
    
    float pers = knight.animationCompletePercentage;

    
    if([knight.currentAnimation.name isEqualToString:@"Run"]){
        pers    += 0.3f*renderTime;
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
    [particleSystem translate:cc3v(0.00, 0.0, -0.1)];
    
    ////////////////////////////////////////////////////
    [cgview.renderer render];
}


- (void)hadleEvents:(CADisplayLink*)displayLink{

    if(rotUp || rotDown || rotLeft || rotRight ){
        
        float rotation = 50.0f*renderTime;
        
        CC3Vector p = renderer.camera.position;
        CC3Vector r = renderer.camera.rotation;
        
        [renderer.camera translate:CC3VectorMake(
                                                       -cgview.renderer.camera.position.x,
                                                       -cgview.renderer.camera.position.y,
                                                       -cgview.renderer.camera.position.z)];
        if(rotUp || rotDown ){
        
            //Respect the rotation YXZ order
            
            [renderer.camera.viewMatrix rotateByY:-cgview.renderer.camera.rotation.y];
        
            [renderer.camera rotate:CC3VectorMake(rotUp?-rotation:rotation,0,0)];
            
            [renderer.camera.viewMatrix rotateByY:r.y];

        
        }else if(rotLeft || rotRight ){
            
            [renderer.camera rotate:CC3VectorMake(0,rotLeft?-rotation:rotation,0)];
            
        }
        
        [renderer.camera translate:CC3VectorMake( p.x, p.y, p.z)];
    }

    float movement = 10.0f*renderTime;
    
    if(moveBwd || moveFwd){
        [renderer.camera translate:CC3VectorMake(0, 0, moveFwd?movement:-movement)];
    }
    
    if(moveRight || moveLeft){
        [renderer.camera translate:CC3VectorMake(moveRight?-movement:movement,0, 0)];
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
