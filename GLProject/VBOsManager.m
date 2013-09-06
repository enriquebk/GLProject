//
//  VBOsManager.m
//  HelloOpenGL
//
//  Created by Enrique Bermudez on 22/08/13.
//
//

#import "VBOsManager.h"

@implementation VBOsManager

static VBOsManager* _VBOsManager;

- (id)init{

    self = [super init];
    
    
    if(self){
        VBOs = [[NSDictionary alloc] init];
    }
    
    return self;
}

+(id)sharedInstance{
    
    if(!_VBOsManager){
        _VBOsManager = [[VBOsManager alloc] init];
    }
    
    return _VBOsManager;
}


-(CGVertexBufferObject*) VBOFromFile: (NSString*)filename{

    CGVertexBufferObject* vbo = [VBOs objectForKey:filename];
    if(vbo){
        return vbo;
    }else{
        
        if(true){ //MD2
        
        }else{
        
        }
        
    }
    
    return nil;
}

-(CGVertexBufferObject*) VBOFromKey: (NSString*)key{
    
    return  [VBOs objectForKey:key];
}

-(CGVertexBufferObject*) addVBO:(GLfloat*)data withKey:(NSString*)key
                       withType:(CGVertexType) type{
    
    CGVertexBufferObject* vbo = [[CGVertexBufferObject alloc] initWithName:key vertexData:data type:type frameCount:1];

    glGenBuffers(1, [vbo getHandlerRef] );
    glBindBuffer(GL_ARRAY_BUFFER, [vbo handler]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(data), data, GL_STATIC_DRAW);
    
    return vbo;
}

-(CGVertexBufferObject*) addVBO:(GLfloat*)data withKey:(NSString*)key
                       withType:(CGVertexType) type indices:(GLvoid*)indices{
    
    CGVertexBufferObject* vbo = [[CGVertexBufferObject alloc] initWithName:key vertexData:data type:type frameCount:1 indices:indices];
    
    glGenBuffers(1, [vbo getHandlerRef] );
    glBindBuffer(GL_ARRAY_BUFFER, [vbo handler]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(CGVertex_PC)*4, data, GL_STATIC_DRAW);
    
    GLuint indexBuffer;//Buffer that keep track of the indices that make up triangles
    glGenBuffers(1, &indexBuffer); // idem vertexBuffer
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer); // idem vertexBuffer
    
   
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLubyte)*6, indices, GL_STATIC_DRAW); // idem vertexBuffer
    
    return vbo;
}

- (unsigned int) createBufferFromArray:(const float*)array size:(int)size {
	// set up buffer to store array
	GLuint bufferIndex;
	glGenBuffers(1, &bufferIndex);
	glBindBuffer(GL_ARRAY_BUFFER, bufferIndex);
	
	// Copy data from local memory
	glBufferData(GL_ARRAY_BUFFER, (GLsizeiptr)(size * sizeof(GLfloat)), array, GL_STATIC_DRAW);
	
	return bufferIndex;
}


@end
