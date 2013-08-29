//
//  CGStaticObject.m
//  GLProject
//
//  Created by Enrique Bermudez on 25/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGStaticObject.h"

const GLubyte _Indices[] = {
    0, 1, 2,
    2, 3, 0
};

@implementation CGStaticObject


-(CGVertexType)vertexType{

    return self.vbo.type;
}



-(void)draw{

    
    
    glDrawElements(GL_TRIANGLES, sizeof(GLubyte)*6/sizeof(GLubyte),
                   GL_UNSIGNED_BYTE, 0);
}

@end
