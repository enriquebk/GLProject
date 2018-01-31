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
#import "CGBillboardRender.h"
#import "CGSkybox.h"
#import "CGFreewayCamera.h"

@interface CGViewController (){

    CGView * cgview;
    CGRenderer* renderer;
    
    CGObject3D* knight;
    CGObject3D* floor;
    CGObject3D* plane;
    
    CGLight* light;
    
    double currentTime;
	double renderTime;
    double frameTimestamp;
    
    CGSkybox * skybox;
    
    CGParticleSystem* particleSystem1;
    CGParticleSystem* particleSystem2;
    CGParticleSystem* particleSystem3;
    CGParticleSystem* particleSystem4;
    
    bool iluminated;
}

@end

@implementation CGViewController

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
    
    //Default value
    iluminated = YES;

    renderer.ambientLightIntensity = 0.7f;
    [renderer setClearColor:12.0f/255 g:183.0f/255 b:242.0f/255 a:1.0];
    
    [self setupScene];
    
    [self runLoop];
}

- (void)setupScene{
    
    //Setup skybox and floor
    
    skybox = [[CGSkybox alloc] init];
    [renderer addNode:skybox];
    
    floor = [CGObject3D plane];
    
    [floor setTexture: [[TextureManager sharedInstance] textureFromFileName:@"grassTexture.jpg"]];
    [floor rotate:cc3v(-90, 0, 0)];
    [floor translate:cc3v(2.5, 0.0, -2.5)];
    [floor scale:CC3VectorMake(1000, 1000, 1000)];
    floor.textureScale = 40.0f;
    floor.specularFactor = 0.01;
    [renderer addObject:floor];
    
    //Setup trees
    
    for (int i = 0; i<8; i++) {
        
        CGObject3D* tree = [CGObject3D plane];
        
        [tree setTexture: [[TextureManager sharedInstance] textureFromFileName:@"Tree2.png"]];
        [tree translate:cc3v(-120 + 40.0*i, 10.0, -180.0)];
        int rand = RandomUInt()%20;
        [tree scale:cc3v(45.0+rand,45.0+rand,45.0+rand)];
        tree.renderProgram = [[CGBillboardRender alloc] init];
        [renderer addObject:tree];
    }
    
    for (int i = 0; i<8; i++) {
        
        CGObject3D* tree = [CGObject3D plane];
        
        [tree setTexture: [[TextureManager sharedInstance] textureFromFileName:@"Tree2.png"]];
        [tree translate:cc3v(-180 , 10.0, -140.0 + 40.0*i)];
        int rand = RandomUInt()%20;
        [tree scale:cc3v(45.0+rand,45.0+rand,45.0+rand)];
        tree.renderProgram = [[CGBillboardRender alloc] init];
        [renderer addObject:tree];
    }
    
    for (int i = 0; i<8; i++) {
        
        CGObject3D* tree = [CGObject3D plane];
        
        [tree setTexture: [[TextureManager sharedInstance] textureFromFileName:@"Tree2.png"]];
        [tree translate:cc3v(180 , 10.0, -140.0 + 40.0*i)];
        int rand = RandomUInt()%20;
        [tree scale:cc3v(45.0+rand,45.0+rand,45.0+rand)];
        tree.renderProgram = [[CGBillboardRender alloc] init];
        [renderer addObject:tree];
    }
    
    for (int i = 0; i<8; i++) {
        
        CGObject3D* tree = [CGObject3D plane];
        
        [tree setTexture: [[TextureManager sharedInstance] textureFromFileName:@"Tree2.png"]];
        [tree translate:cc3v(-180 + 40.0*i, 10.0, 180.0)];
        int rand = RandomUInt()%20;
        [tree scale:cc3v(45.0+rand,45.0+rand,45.0+rand)];
        tree.renderProgram = [[CGBillboardRender alloc] init];
        [renderer addObject:tree];
    }
    
    //Setup Knight
    
    knight= [CGObject3D MD2ObjectNamed:@"knight"];
    
    [knight setTexture:[[TextureManager sharedInstance] textureFromFileName:@"knight.jpg"]];
    [knight rotate:cc3v(0, 0, 90)];
    [knight scale:CC3VectorMake(0.3, 0.3, 0.3)];
    [knight translate:cc3v(0, 7.13, 0)];
    [knight setAnimationWithName:@"Run"];
    knight.specularFactor = 0.7;
    [renderer addObject:knight];
    
    light = [[CGLight alloc] init];
    [light translate:cc3v(0,16,13)];
    [renderer addLight:light];
    light.intensity = 0.3f;
    
    floor.lightAffected = NO;
    
    // Add a small shadow to the knight
    CGObject3D* shadow = [CGObject3D plane];
    
    [shadow setTexture: [[TextureManager sharedInstance] textureFromFileName:@"Shadow.png"]];
    [shadow rotate:cc3v(-90, 0, 0)];
    [shadow translate:cc3v(0.0, 0.06, 0.0)];
    [shadow scale:CC3VectorMake(9, 9, 9)];
    shadow.color = (ccColor4F){1,1,1,0.6};
    shadow.lightAffected = NO;
    [renderer addObject:shadow];
    
    //Setup boxes and particles systems
    
    CGObject3D* box = [CGObject3D cube];
    [box setTexture: [[TextureManager sharedInstance] textureFromFileName:@"tile_floor.png"]];
    [box translate:CC3VectorMake(15, 1, -15)];
    [box scale:CC3VectorMake(2, 2, 2)];
    [renderer addObject:box];
    
    particleSystem1 = [[CGParticleSystem alloc] init];
    [particleSystem1 startEmission];
    [particleSystem1 translate:CC3VectorMake(15, 2.5, -15)];
    [renderer addNode:particleSystem1];
    
    CGObject3D* box2 = [CGObject3D cube];
    [box2 setTexture: [[TextureManager sharedInstance] textureFromFileName:@"tile_floor.png"]];
    [box2 translate:CC3VectorMake(15, 1, 15)];
    [box2 scale:CC3VectorMake(2, 2, 2)];
    [renderer addObject:box2];
    
    particleSystem2 = [[CGParticleSystem alloc] init];
    [particleSystem2 startEmission];
    [particleSystem2 translate:CC3VectorMake(15, 2.5, 15)];
    [renderer addNode:particleSystem2];
    
    CGObject3D* box3 = [CGObject3D cube];
    [box3 setTexture: [[TextureManager sharedInstance] textureFromFileName:@"tile_floor.png"]];
    [box3 translate:CC3VectorMake(-15, 1, -15)];
    [box3 scale:CC3VectorMake(2, 2, 2)];
    [renderer addObject:box3];
    
    particleSystem3 = [[CGParticleSystem alloc] init];
    [particleSystem3 startEmission];
    [particleSystem3 translate:CC3VectorMake(-15, 2.5, -15)];
    [renderer addNode:particleSystem3];
    
    CGObject3D* box4 = [CGObject3D cube];
    [box4 setTexture: [[TextureManager sharedInstance] textureFromFileName:@"tile_floor.png"]];
    [box4 translate:CC3VectorMake(-15, 1, 15)];
    [box4 scale:CC3VectorMake(2, 2, 2)];
    [renderer addObject:box4];
    
    particleSystem4 = [[CGParticleSystem alloc] init];
    [particleSystem4 startEmission];
    [particleSystem4 translate:CC3VectorMake(-15, 2.5, 15)];
    [renderer addNode:particleSystem4];
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
    
    
    [particleSystem1 update:renderTime];
    [particleSystem2 update:renderTime];
    [particleSystem3 update:renderTime];
    [particleSystem4 update:renderTime];
    
    // ANIMATION STUFF ////////////////////////
    
    double pers = knight.animationCompletePercentage;
    
    if([knight.currentAnimation.name isEqualToString:@"Run"]){
        pers    += 0.3f*renderTime;
        if(pers >=1.0f){
            pers = 0.0f;
        }
    }
    
    knight.animationCompletePercentage = (float)pers;
    
    [cgview.renderer render];
}


- (void)hadleEvents:(CADisplayLink*)displayLink{

    if(rotUp || rotDown || rotLeft || rotRight ){
        
        float rotation = 50.0f*renderTime;
        
        if(rotUp || rotDown ){
        
            //Rotation YXZ order

            [(CGFreewayCamera*)renderer.camera rotateByX:rotUp?rotation:-rotation];
        
        }else if(rotLeft || rotRight ){
            
            [(CGFreewayCamera*)renderer.camera rotateByY:rotLeft?rotation:-rotation];
        }
    }

    float movement = 10.0f*renderTime;
    
    if(moveBwd || moveFwd){
        [renderer.camera translate:CC3VectorMake(0, 0, moveFwd?-movement:movement)];
    }
    
    if(moveRight || moveLeft){
        [renderer.camera translate:CC3VectorMake(moveRight?movement:-movement,0, 0)];
    }
}

- (IBAction)changeIlumination:(id)sender {
    
    if(iluminated){
    
        renderer.ambientLightIntensity = 0.4f;
        [skybox setColor:(ccColor4F){0.5,0.5,0.5,1.0}];
        floor.lightAffected = YES;
    }else{
        
        renderer.ambientLightIntensity = 0.7f;
        [skybox setColor:(ccColor4F){1.0,1.0,1.0,1.0}];
        floor.lightAffected = NO;
    }
    
    iluminated = !iluminated;
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
