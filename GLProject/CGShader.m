//
//  CGShader.m
//  GLProject
//
//  Created by Enrique Bermudez on 24/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGShader.h"

@implementation CGShader

-(id)initWithVertexShader:(NSString*)vs fragmentShader:(NSString*)fs{

    self = [super init];
    
    if(self){
        
        // Compile the vertex and fragment shaders.
        GLuint vertexShader = [CGShader compileShader:vs
                                             withType:GL_VERTEX_SHADER];
        GLuint fragmentShader = [CGShader compileShader:fs
                                               withType:GL_FRAGMENT_SHADER];

        
        [self linkVertexShader:vertexShader fragmentShader:fragmentShader];
    
    }
    
    return self;
}

-(id)initWithVertexShaderSource:(NSString*)vs fragmentShaderSource:(NSString*)fs{

    self = [super init];
    
    if(self){
        // Compile the vertex and fragment shaders.
        GLuint vertexShader = [CGShader compileShaderSource: vs
                                             withType:GL_VERTEX_SHADER];
        GLuint fragmentShader = [CGShader compileShaderSource:fs
                                               withType:GL_FRAGMENT_SHADER];
        [self linkVertexShader:vertexShader fragmentShader:fragmentShader];
    
    }

    return self;
}

-(BOOL)linkVertexShader:(GLuint)vertexShader fragmentShader:(GLuint)fragmentShader{

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
    
    return TRUE;
}

+ (GLuint)compileShaderSource:(NSString*)source withType:(GLenum)shaderType {
    
    NSString* shaderString = source;

    
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
    
    return [self compileShaderSource:shaderString withType:shaderType];
}

+ (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType withPreProcessorHeader:(NSString *)preProcessorHeader{

    
    NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName
                                                           ofType:@"glsl"];
    NSError* error;
    NSString* shaderString = [NSString stringWithContentsOfFile:shaderPath
                                                       encoding:NSUTF8StringEncoding error:&error];
    
    if (!shaderString) {
        NSLog(@"Error loading shader: %@", error.localizedDescription);
        exit(1);
    }
    
    
    [preProcessorHeader stringByAppendingString:shaderString];
    return [self compileShaderSource:preProcessorHeader withType:shaderType];
}

+ (CGShader*)shaderNamed:(NSString*)shaderFiles{
 
    CGShader* shader = [[CGShaderManager sharedInstance] shaderWithKey:shaderFiles];
    
    if(!shader){
        NSString* vertexShaderName = [NSString stringWithFormat:@"%@_v",shaderFiles];
        NSString* fragmentShaderName = [NSString stringWithFormat:@"%@_f",shaderFiles];
        shader = [[CGShader alloc] initWithVertexShader:vertexShaderName fragmentShader:fragmentShaderName];
        [[CGShaderManager sharedInstance] addShader:shader WithKey:shaderFiles];
    }
    
    return shader;
}

+ (CGShader*)shaderWithvertexSource:(NSString*)vs withFragmentSource:(NSString*)fs{

    return [[CGShader alloc] initWithVertexShaderSource:vs fragmentShaderSource:fs];
}

@end


@implementation CGShaderManager

static CGShaderManager* sm;

+ (id)sharedInstance{
    
    if(sm){
        return sm;
    }
    
    sm = [[CGShaderManager alloc] init];
    sm.shaders = [[NSMutableDictionary alloc] init];
    return sm;
}


-(CGShader*) shaderWithKey: (NSString*)key{
    
    return  [self.shaders objectForKey:key];
}

-(void) addShader:(CGShader*) shader WithKey: (NSString*)key{
    
    [self.shaders setObject:shader forKey:key];
}

@end
