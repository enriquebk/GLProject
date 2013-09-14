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

@interface CGViewController (){

    CGView * cgview;
    float pos;
    CGObject3D* o;
}

@end

@implementation CGViewController


// An array with all the info for each vertex
const float Vertices[] = {
    0.5, -0.5, 0.0,     1.0, 0.0, 0.0, 1.0,
    0.5, 0.5, 0.0,      0.0, 1.0, 0.0, 1.0,
    -0.5, 0.5, 0.0,     0.0, 0.0, 1.0, 1.0,
    -0.5, -0.5, 0.0,    0.0, 0.0, 0.0, 1.0
};
//TODO: manage structures.. like Vertice...

// An array that gives a list of triangles to create, by specifying the 3 vertices that make up each triangle
GLubyte Indices[] = {
    0, 1, 2,
    2, 3, 0
};


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
}

-(void)viewWillAppear:(BOOL)animated{

    
    cgview = [[CGView alloc] initWithFrame:self.glView.frame];
    [self.glView addSubview:cgview];
    
    
    
    CGMesh* mesh = [[CGMesh alloc]
                    initWithVertexData:
                    [[CGArray alloc] initWithData:(void*)Vertices withCapacity:7*4 ]
                    indices:
                    [[CGArray alloc] initWithData:(void*)Indices withCapacity: sizeof(GLubyte)*6]];
    
    [MeshFactory addMesh:mesh withName:@"CGMeshplane"];
    
    o= [[CGObject3D alloc] initWithMesh:[MeshFactory meshNamed:@"CGMeshplane"]];
    
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
    
    [cgview.engine render];
}



- (IBAction)upAction:(id)sender {

    [ cgview.engine.sceneGraph.camera translate:CC3VectorMake(0, 0, 0.5)];
}

- (IBAction)downAction:(id)sender {

    [ cgview.engine.sceneGraph.camera translate:CC3VectorMake(0,  0,-0.5)];
}

- (IBAction)leftAction:(id)sender {
     [ cgview.engine.sceneGraph.camera translate:CC3VectorMake(0.5,0,0)];
}

- (IBAction)rightAction:(id)sender {
    
    [ cgview.engine.sceneGraph.camera translate:CC3VectorMake(-0.5,0,0)];
}

- (IBAction)rotLAction:(id)sender {
    
    CC3Vector p = cgview.engine.sceneGraph.camera.position;
    
    [ cgview.engine.sceneGraph.camera translate:CC3VectorMake(
                                            -cgview.engine.sceneGraph.camera.position.x,
                                            -cgview.engine.sceneGraph.camera.position.y,
                                            -cgview.engine.sceneGraph.camera.position.z)];
    
    [ cgview.engine.sceneGraph.camera rotate:CC3VectorMake(-10,0,0)];
    [ cgview.engine.sceneGraph.camera translate:CC3VectorMake(
                                             p.x,
                                             p.y,
                                             p.z)];
}

- (IBAction)rotRAction:(id)sender {
    
    CC3Vector p = cgview.engine.sceneGraph.camera.position;
    
    [ cgview.engine.sceneGraph.camera translate:CC3VectorMake(
                                                              -cgview.engine.sceneGraph.camera.position.x,
                                                              -cgview.engine.sceneGraph.camera.position.y,
                                                              -cgview.engine.sceneGraph.camera.position.z)];
    
    [ cgview.engine.sceneGraph.camera rotate:CC3VectorMake(10,0,0)];
    [ cgview.engine.sceneGraph.camera translate:CC3VectorMake(
                                                              p.x,
                                                              p.y,
                                                              p.z)];
}
@end
