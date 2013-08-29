//
//  CGRender.m
//  GLProject
//
//  Created by Enrique Bermudez on 24/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGRender.h"
#import "CGView.h"

@implementation CGRender


-(id)initWithLayer:(CAEAGLLayer*)layer{

    self = [super init];
    
    if(self){
    
        self.projection = [CC3GLMatrix matrix];
        float h = 4.0f * layer.frame.size.height / layer.frame.size.width;
        [self.projection populateFromFrustumLeft:-2 andRight:2 andBottom:-h/2 andTop:h/2 andNear:1 andFar:10];
        [self.projection translateBy:CC3VectorMake(0, 0, -2)];
        
        [self setupContext];
        [self setupRenderBufferWithDrawable:layer];
        [self setupFrameBuffer];
        
        objects = [[NSMutableArray alloc] init];
        
        [self setViewPortX:0 y:0 width:layer.frame.size.width height:layer.frame.size.height];
       // glViewport(0, 0, layer.frame.size.width, layer.frame.size.height);
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
}

-(void)addObject:(CGObject3D*)o{

    [objects addObject:o];
}

-(void)removeObject:(CGObject3D*)o{

    [objects removeObject:o];
}

-(void)render{

    for (CGObject3D* o in objects) {
        if(o.visible){
            [o drawInRender:self];
        }
    }
    
    [_context presentRenderbuffer:GL_RENDERBUFFER];//Call a method on the OpenGL context to present the render/color buffer to the UIView’s layer!
}

-(void)setClearColor: (GLfloat)r g:(GLfloat)g b:(GLfloat)b a:(GLfloat)a{

    glClearColor(r, g, b, a);//Call glClearColor to specify the RGB and alpha (transparency) values to use when clearing the screen.
    
}

-(void)clear{

     glClear(GL_COLOR_BUFFER_BIT);//Call glClear to actually perform the clearing. Remember that there can be different types of buffers, such as the render/color buffer we’re displaying, and others we’re not using yet such as depth or stencil buffers. Here we use the GL_COLOR_BUFFER_BIT to specify what exactly to clear – in this case, the current render/color buffer.
}

-(void) setCameraFrustumLeft: (GLfloat) left
                    andRight: (GLfloat) right
                   andBottom: (GLfloat) bottom
                      andTop: (GLfloat) top
                     andNear: (GLfloat) near
                      andFar: (GLfloat) far{

    [self.projection populateFromFrustumLeft:left andRight:right andBottom:bottom andTop:top andNear:near andFar:far];
}

-(void)tranlateCamera:(CC3Vector) aVector{
    [self.projection translateBy:aVector];
}

-(void)rotateCamera: (CC3Vector) aVector{
    [self.projection rotateBy:aVector];
}

-(void)setViewPortX:(int)x y:(int)y width:(int)w height:(int)h{

    float d = (([CGView isRetinaDisplay])?1.0f:2.0f);
    glViewport(x, y, w/d , h/d );
}

@end
