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
    
    float direction;
    CGObject3D* floor;
    
    CGObject3D* plane;
}

@end

@implementation CGViewController


// An array with all the info for each vertex
const float Vertices[] = {
        0.5,   -0.5,    0.0,    1.0, 0.0,
        0.5,    0.5,    0.0,    1.0, 1.0,
       -0.5,    0.5,    0.0,    0.0, 1.0,
       -0.5,   -0.5,    0.0,    0.0, 0.0  };


// An array with all the info for each vertex
const float _Vertices[] = {
    0.5, -0.5, 0.0,      10.0, 0.0,
    0.5, 0.5, 0.0,        10.0, 10.0,
    -0.5, 0.5, 0.0,       0.0, 10.0,
    -0.5, -0.5, 0.0,       0.0, 0.0
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
    
    //glEnable(GL_DEPTH_TEST);
    //
    glDepthFunc(GL_LEQUAL);
    
    CGMesh* mesh = [[CGMesh alloc]
                    initWithVertexData:
                    [[CGArray alloc] initWithData:(void*)_Vertices
                                     withCapacity:5*4 /*floats per vertices * Vertices count*/]
                   // indices:
                   // [``8 initWithData:(void*)Indices withCapacity: sizeof(GLubyte)*6]
                    ];

    
    CGMesh* _mesh = [[CGMesh alloc]
                    initWithVertexData:
                    [[CGArray alloc] initWithData:(void*)_Vertices
                                     withCapacity:5*4] /*floats per vertices * Vertices count*/
                                          indices:
                      [[CGArray alloc] initWithData:(void*)Indices withCapacity: sizeof(GLubyte)*6] ];
    //_mesh.uvOffset = VBO_NULL_ELEMENT;
    
    [MeshFactory addMesh:mesh withName:@"CGMeshplane"];
    [MeshFactory addMesh:_mesh withName:@"CGMeshplane2"];
    
    
    
  //   plane = [[CGObject3D alloc] initWithMesh:[MeshFactory meshNamed:@"CGMeshplane2"]];
 //   [cgview.engine addObject:plane];
 //   [plane scale:CC3VectorMake(2, 2, 2)];
 //   [plane rotate:cc3v(-90, 0, 0)];
    //plane.mesh.drawMode = GL_TRIANGLE_FAN;
 //   plane.color = (ccColor4F){1.0f, 0.0f, 0.0f, 1.0f};
    
    floor= [[CGObject3D alloc] initWithMesh:[MeshFactory meshNamed:@"CGMeshplane"]];//init with mesh named
    [floor.textures addObject:[[TextureManager sharedInstance] textureFromFileName:@"tile_floor"]];
    floor.mesh.drawMode = GL_TRIANGLE_FAN;
    [cgview.engine addObject:floor];
   /* [floor scale:CC3VectorMake(30, 30, 30)];

    [floor rotate:cc3v(-90, 0, 0)];
    [floor scale:CC3VectorMake(30, 30, 30)];
*/
   [floor rotate:cc3v(-90, 0, 0)];

    /*Ver como hacer...*/ // optimizar matrices.. no hacer tida la muktiplicacion de marices vectores modificar lo q compete.
    GLfloat* m = floor.matrix.glMatrix;
    
    
    
    m[12] = 2.5;
    m[13] = -7.1f;
    m[14] = -2.5;
    
     [floor scale:CC3VectorMake(200, 200, 200)];
    
  //  [floor translate:cc3v(2.5, -10, -2.5)];
    
    
    
    
    
    
    //[floor scale:CC3VectorMake( 3.01, 3.01, 3.01)];
    
    
    //o= [[CGObject3D alloc] initWithMesh:[MeshFactory meshNamed:@"CGMeshplane"]];
    
    o= [[CGObject3D alloc] initWithMesh:[MeshFactory meshMD2Named:@"knight"]];
    
    [o.matrix rotateByZ:90];
    //[o.matrix rotateByY:-90];
    //[o.matrix rotateByX:70];
    
    [o scale:CC3VectorMake(0.3, 0.3, 0.3)];
    
    [o.textures addObject:[[TextureManager sharedInstance] textureFromFileName:@"knight.jpg"]];
    //[o.textures addObject:[[TextureManager sharedInstance] textureFromFileName:@"tile_floor"]];
    
   [cgview.engine addObject:o];
    

    [cgview.engine setClearColor:12.0f/255 g:183.0f/255 b:242.0f/255 a:1.0];
    
    //[o setAnimationWithName:@"Stand"];
    [o setAnimationWithName:@"Run"];
    
    direction =1.0f;
    
    
    [ cgview.engine.camera translate:CC3VectorMake(0,-2,0)];
    
    [self runLoop];
}


- (void)runLoop {
    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)render:(CADisplayLink*)displayLink {
    
    [cgview.engine clear];
    
   // [floor translate:cc3v(0.01, 0, 0.01)];
   //  [floor rotate:cc3v(-1, 0, 1)];
    
   // [floor rotate:cc3v(1, 0, 0)];
    
   // [floor scale:CC3VectorMake( 1.01, 1.01, 1.01)];
    
    [self hadleEvents:displayLink];
    
    //TODO: Clase que maneje las animaciones (Animation manager) por objeto; (animation completation)
    
    float pers = o.animationCompletePercentage;
    
   
    if([o.currentAnimation.name isEqualToString:@"Run"]){
        pers    += direction*0.015f;
        if(pers >1.0f){
            pers = 0.0f;
        }
    }else if([o.currentAnimation.name isEqualToString:@"Stand"]){
        pers    += direction*0.01f;
        if(direction == 1.0f && o.currentAnimation.finalFrame == o.frameIndex){
            direction = -1.0f;
            pers    += direction*0.02f;
        }
        if(direction == -1.0f && o.currentAnimation.initialFrame == o.frameIndex &&pers <0.0f ){
            direction = 1.0f;
            pers    = 0.0f;
        }
    }
    
  //  [plane rotate:cc3v(1,2 , 4)];
    
   // NSLog(@"%f",pers);
   
   
    
    // [o.matrix rotateBy:cc3v(1,2 , 4)];
    
     //[o translate:cc3v(0 ,0.1 , 0)];
   
    o.animationCompletePercentage = pers;
    
    [cgview.engine render];
}


//TODO: La rotacion de la camara anda mal (modificar pipeline? p*v*m*p?)
- (void)hadleEvents:(CADisplayLink*)displayLink{

    if(rotUp || rotDown || rotLeft || rotRight ){
        
        CC3Vector p = cgview.engine.camera.position;
        CC3Vector r = cgview.engine.camera.rotation;
        
        [ cgview.engine.camera translate:CC3VectorMake(
                                                       -cgview.engine.camera.position.x,
                                                       -cgview.engine.camera.position.y,
                                                       -cgview.engine.camera.position.z)];
        
        if(rotUp || rotDown ){
        
            //Respect the rotation YXZ order
            
            [ cgview.engine.camera.viewMatrix rotateByY:-cgview.engine.camera.rotation.y];
        
            [ cgview.engine.camera rotate:CC3VectorMake(rotUp?-1:1,0,0)];
            
            [ cgview.engine.camera.viewMatrix rotateByY:r.y];

        
        }else if(rotLeft || rotRight ){
            
            [ cgview.engine.camera rotate:CC3VectorMake(0,rotLeft?-1:1,0)];
            
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
