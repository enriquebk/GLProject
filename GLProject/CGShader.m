//
//  CGShader.m
//  GLProject
//
//  Created by Enrique Bermudez on 24/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGShader.h"

@implementation CGShader


//-(void)renderObject: in render

-(id)initWithVertexShader:(NSString*)vs fragmentShader:(NSString*)fs{

    self = [super init];
    
    if(self){
        
        // Compile the vertex and fragment shaders.
        GLuint vertexShader = [CGShader compileShader:vs
                                             withType:GL_VERTEX_SHADER];
        GLuint fragmentShader = [CGShader compileShader:fs
                                               withType:GL_FRAGMENT_SHADER];

        // Calls glCreateProgram, glAttachShader, and glLinkProgram to link the vertex and fragment shaders into a complete program.
        self.handler = glCreateProgram(); // Si quiero cambiar habilitar o deshablitar este programa  tengo q guardar la variable.
        glAttachShader(self.handler, vertexShader);
        glAttachShader(self.handler, fragmentShader);

        //Linkeo los 2 "Programas objetos"
        glLinkProgram(self.handler);


        // Calls glGetProgramiv and glGetProgramInfoLog to check and see if there were any link errors, and display the output and quit if so.
        GLint linkSuccess;
        glGetProgramiv(self.handler, GL_LINK_STATUS, &linkSuccess);
        if (linkSuccess == GL_FALSE) {
            GLchar messages[256];
            glGetProgramInfoLog(self.handler, sizeof(messages), 0, &messages[0]);
            NSString *messageString = [NSString stringWithUTF8String:messages];
            NSLog(@"Program ERROR: %@", messageString);
            glDeleteShader(self.handler);
            exit(1);
        }
    
    }
    
    return self;
}


// Compile a shader on the run
+ (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType {
    
    NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName
                                                           ofType:@"glsl"];
    NSError* error;
    NSString* shaderString = [NSString stringWithContentsOfFile:shaderPath
                                                       encoding:NSUTF8StringEncoding error:&error];
    if (!shaderString) {
        NSLog(@"Error loading shader: %@", error.localizedDescription);
        exit(1);
    }
    
    // Calls glCreateShader to create a OpenGL object to represent the shader. When you call this function you need to pass in a shaderType to indicate whether it’s a fragment or vertex shader. We take ethis as a parameter to this method.
    GLuint shaderHandle = glCreateShader(shaderType);
    
    // Calls glShaderSource to give OpenGL the source code for this shader. We do some conversion here to convert the source code from an NSString to a C-string.
    const char * shaderStringUTF8 = [shaderString UTF8String];
    int shaderStringLength = [shaderString length];
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
    
    
    glCompileShader(shaderHandle);//compile the shader at runtime!
    
    
    // This can fail – and it will in practice if your GLSL code has errors in it. When it does fail, it’s useful to get some output messages in terms of what went wrong. This code uses glGetShaderiv and glGetShaderInfoLog to output any error messages to the screen (and quit so you can fix the bug!)
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        glDeleteShader(shaderHandle);
        exit(1);
    }
    
    return shaderHandle;
}

-(void)drawObject:(CGObject3D*) object usingEngine:(CGEngine*)engine{
//Over ride me
 
}



@end
