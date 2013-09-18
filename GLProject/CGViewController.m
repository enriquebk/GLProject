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
    CGObject3D* o;
}

@end

@implementation CGViewController


// An array with all the info for each vertex
const float Vertices[] = {
    0.5, -0.5, 0.0,     1.0, 0.0, 0.0, 1.0,  1.0, 0.0,
    0.5, 0.5, 0.0,      0.0, 1.0, 0.0, 1.0,  1.0, 1.0,
    -0.5, 0.5, 0.0,     0.0, 0.0, 1.0, 1.0,  0.0, 1.0,
    -0.5, -0.5, 0.0,    0.0, 0.0, 0.0, 1.0,   0.0, 0.0
};

//TODO: manage structures.. like Vertice...

// An array that gives a list of triangles to create, by specifying the 3 vertices that make up each triangle
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
    
    
    CGMesh* mesh = [[CGMesh alloc]
                    initWithVertexData:
                    [[CGArray alloc] initWithData:(void*)Vertices
                                     withCapacity:9*4 /*floats per vertices * Vertices count*/]];
               //     indices:
               //     [[CGArray alloc] initWithData:(void*)Indices withCapacity: sizeof(GLubyte)*6]];
    
    [MeshFactory addMesh:mesh withName:@"CGMeshplane"];
    
    o= [[CGObject3D alloc] initWithMesh:[MeshFactory meshNamed:@"CGMeshplane"]];
    
    [o.textures addObject:[[TextureManager sharedInstance] textureFromFileName:@"tile_floor.png"]];
    
    
    [cgview.engine addObject:o];
    
    [self runLoop];
}


- (void)runLoop {
    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)render:(CADisplayLink*)displayLink {
    
    [o rotate:CC3VectorMake(0, 0, -1)];
    
    [cgview.engine setClearColor:0.0 g:0.8 b:0.2 a:1.0];
    
    [cgview.engine clear];
    
    [self hadleEvents:displayLink];
    
    [cgview.engine render];
}

- (void)hadleEvents:(CADisplayLink*)displayLink{

    if(rotUp || rotDown || rotLeft || rotRight ){
        
        CC3Vector p = cgview.engine.camera.position;
        CC3Vector r = cgview.engine.camera.rotation;
        
        [ cgview.engine.camera translate:CC3VectorMake(
                                                       -cgview.engine.camera.position.x,
                                                       -cgview.engine.camera.position.y,
                                                       -cgview.engine.camera.position.z)];
        
        if(rotUp || rotDown ){
        
            [ cgview.engine.camera.matrix rotateByY:-cgview.engine.camera.rotation.y];
            
            [ cgview.engine.camera rotate:CC3VectorMake(rotUp?-1:1,0,0)];
            
            [ cgview.engine.camera.matrix rotateByY:r.y];
        
        }else if(rotLeft || rotRight ){
            
            [ cgview.engine.camera.matrix rotateByX:-cgview.engine.camera.rotation.x];
            
            [ cgview.engine.camera rotate:CC3VectorMake(0,rotLeft?-1:1,0)];
            
            [ cgview.engine.camera.matrix rotateByX:r.x];
        }
        
        [ cgview.engine.camera translate:CC3VectorMake(
                                                       p.x,
                                                       p.y,
                                                       p.z)];
    
        
    }

    if(moveBwd || moveFwd){
        [ cgview.engine.camera translate:CC3VectorMake(0, 0, moveFwd?0.1:-0.1)];
    }
    
    if(moveRight || moveLeft){
        [ cgview.engine.camera translate:CC3VectorMake(moveRight?-0.1:0.1,0, 0)];
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
