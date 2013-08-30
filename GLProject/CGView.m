//
//  CGView.m
//  GLProject
//
//  Created by Enrique Bermudez on 20/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGView.h"
#import "CC3GLMatrix.h"
#import "CGVertex.h"
#import "CGSimpleShader.h"
#import "CGStaticObject.h"
#import "VBOsManager.h"

@implementation CGView


// A structure to keep track of all our per-vertex information (currently just color and position)
//typedef struct {
//    float Position[3];
//    float Color[4];
//} Vertex;

// An array with all the info for each vertex
const CGVertex_PC Vertices[] = {
    {{0.5, -0.5, 0}, {1, 0, 0, 1}},
    {{0.5, 0.5, 0}, {0, 1, 0, 1}},
    {{-0.5, 0.5, 0}, {0, 0, 1, 1}},
    {{-0.5, -0.5, 0}, {0, 0, 0, 1}}
};

// An array that gives a list of triangles to create, by specifying the 3 vertices that make up each triangle
 GLubyte Indices[] = {
    0, 1, 2,
    2, 3, 0
};


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupLayer];

        render = [[CGRender alloc] initWithLayer:_eaglLayer];
        
        engine = [[CGEngine alloc] initWithRender:render];
        
        [engine draw];
        
        
        
       /* CGSimpleShader* ss = [[CGSimpleShader alloc] init];
        CGStaticObject * so = [[CGStaticObject alloc] init];
        so.shader = ss;

        so.vbo = [[VBOsManager sharedInstance] addVBO:Vertices withKey:@"model" withType:CGVertexType_PC indices:Indices];
       // [render addObject:so];
        */
       // [self render];
    }
    return self;
}

/*  To set up a view to display OpenGL content, you need to set it’s default layer to a special kind of layer called a CAEAGLLayer. The way you set the default layer is to simply overwrite the layerClass method, like you just did above. */
+ (Class)layerClass {
    return [CAEAGLLayer class];
}

/*  By default, CALayers are set to non-opaque (i.e. transparent). However, this is bad for performance reasons (especially with OpenGL), so it’s best to set this as opaque when possible.*/
- (void)setupLayer {
    _eaglLayer = (CAEAGLLayer*) self.layer;
    _eaglLayer.opaque = YES;
    
    if ([CGView isRetinaDisplay]) {
        
        // Set contentScale Factor to 2
        self.contentScaleFactor = 2.0;
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        eaglLayer.contentsScale=2;
    }
}

+ (BOOL) isRetinaDisplay
{
	int scale = 1.0;
	UIScreen *screen = [UIScreen mainScreen];
	if([screen respondsToSelector:@selector(scale)])
    scale = screen.scale;
    
	if(scale == 2.0f) return YES;
	else return NO;
}






@end
