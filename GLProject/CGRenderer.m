//
//  CGRenderer.m
//  GLProject
//
//  Created by Enrique Bermudez on 24/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGRenderer.h"
#import "CGUtils.h"


@interface CGRenderer (){
    
    EAGLContext* _context;
    GLuint _colorRenderBuffer;
    GLuint _depthRenderBuffer;
    
}

@property(strong)CAEAGLLayer* layer;

@end

@implementation CGRenderer


-(id)initWithLayer:(CAEAGLLayer*)layer{
    
    self = [super init];
    
    if(self){
        
        self.layer = layer;
        
        self.ambientLightColor = ccc3(255,255,255);
        self.ambientLightIntensity = 1.0;
        
        float h = 4.0f * self.layer.frame.size.height / self.layer.frame.size.width;
        self.camera  = [[CGCamera alloc] init];        
        [self.camera setCameraFrustumLeft:-2 andRight:2 andBottom:-h/2 andTop:h/2 andNear:3 andFar:200];
        [self.camera translate:CC3VectorMake(0, 0, -20)];
        
        [self setupContext];
        [self setupDepthBuffer];
        [self setupRenderBufferWithDrawable:self.layer];
        [self setupFrameBuffer];
        
        
        float d = (([CGUtils isRetinaDisplay])?0.5f:1.0f);
        glViewport(0, 0, layer.frame.size.width/d , layer.frame.size.height/d );
        
        self.displayList = [[NSMutableArray alloc] init];
        self.lights = [[NSMutableArray alloc] init];
        
        // Enable depth buffer
        glEnable(GL_DEPTH_TEST);
        
        // Enable back face culling
       glEnable(GL_CULL_FACE);
        
    }
    
    return self;
}


/*  To do anything with OpenGL, you need to create an EAGLContext, and set the current context to the newly created context.
 An EAGLContext manages all of the information iOS needs to draw with OpenGL. It’s similar to how you need a Core Graphics context to do anything with Core Graphics.
 */
- (void)setupContext {
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    _context = [[EAGLContext alloc] initWithAPI:api];
    
    
    // When you create a context, you specify what version of the API you want to use. Here, you specify that you want to use OpenGL ES 2.0.
    
    if (!_context) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        exit(1);
    }
    
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
}

/*  Create a render buffer, which is an OpenGL object that stores the rendered image to present to the screen
 */
- (void)setupRenderBufferWithDrawable:(id<EAGLDrawable>)drawble {
   
    glGenRenderbuffers(1, &_colorRenderBuffer);//Create a new render buffer object. This returns a unique integer for the the render buffer (we store it here in _colorRenderBuffer). Sometimes you’ll see this unique integer referred to as an “OpenGL name.”
    
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);// Call glBindRenderbuffer to tell OpenGL “whenever I refer to GL_RENDERBUFFER, I really mean _colorRenderBuffer.”
    
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:drawble];//Finally, allocate some storage for the render buffer. The EAGLContext you created earlier has a method you can use for this called renderbufferStorage.
}

/*  A frame buffer is an OpenGL object that contains a render buffer, and some other buffers you’ll learn about later such as a depth buffer, stencil buffer, and accumulation buffer.*/
- (void)setupFrameBuffer {
    GLuint framebuffer;
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    //The first two steps for creating a frame buffer is very similar to creating a render buffer – it uses the glGen and glBind like you’ve seen before, just ending with “Framebuffer/s” instead of “Renderbuffer/s”.
    
    
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                              GL_RENDERBUFFER, _colorRenderBuffer);// It lets you attach the render buffer you created earlier to the frame buffer’s GL_COLOR_ATTACHMENT0 slot.
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
}

- (void)setupDepthBuffer {
    glGenRenderbuffers(1, &_depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.layer.frame.size.width*([CGUtils isRetinaDisplay]?2:1), self.layer.frame.size.height*([CGUtils isRetinaDisplay]?2:1));
}

-(void)render{
    
   /* self.displayList = [[NSMutableArray alloc] initWithArray:[self.displayList sortedArrayUsingSelector:@selector(compareBeforeRender:)]];
*/
    
    for (CGNode<CGDrawableNode>* n in self.displayList) {
        [n drawWithRenderer:self];
    }
    
    [_context presentRenderbuffer:GL_RENDERBUFFER];//Call a method on the OpenGL context to present the render/color buffer to the UIView’s layer!
}

-(void)setClearColor: (GLfloat)r g:(GLfloat)g b:(GLfloat)b a:(GLfloat)a{
    
    glClearColor(r, g, b, a);//Call glClearColor to specify the RGB and alpha (transparency) values to use when clearing the screen.
    
}

- (NSComparisonResult)defaultSortSelector: (NSString*) aString;
{

}

-(void)clear{
    
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);//Call glClear to actually perform the clearing. Remember that there can be different types of buffers, such as the render/color buffer we’re displaying, and others we’re not using yet such as depth or stencil buffers. Here we use the GL_COLOR_BUFFER_BIT to specify what exactly to clear – in this case, the current render/color buffer.
}


-(void)addNode:(CGNode<CGDrawableNode>*)node{
    
    [self.displayList addObject:node];
}

-(void)removeNode:(CGNode<CGDrawableNode>*)node{
    
    [self.displayList removeObject:node];
}

-(void)addObject:(CGObject3D*)object{
    
    [self.displayList addObject:object];
}

-(void)removeObject:(CGObject3D*)object{
    
    [self.displayList removeObject:object];
}

-(void)addLight:(CGLight*)light{
    [self.lights addObject:light];
}

-(void)removeLight:(CGLight*)light{
    [self.lights removeObject:light];
}

-(EAGLContext*)getGLContext{
    return _context;
}

@end

