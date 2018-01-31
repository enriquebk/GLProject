//
//  CGModel.h
//  GLProject
//
//  Created by Enrique Bermudez on 29/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGArray.h"
#include <OpenGLES/ES2/gl.h>
#import "CGKeyFrameAnimation.h"

#define VBO_POSITION_SIZE       3
#define VBO_NORMAL_SIZE         3
#define VBO_UV_SIZE             2

#define VBO_NULL_ELEMENT       -1


@interface CGMesh : NSObject

/**
 * Initializes a mesh with a raw vertex array.
 *
 * @param vertexData Vertex array.
 */

-(id)initWithVertexData:(CGFloatArray*)vertexData;

/**
 * Initializes a mesh with a raw vertex array and a indices array. This mesh will be draw 
 * with the openGL primitive glDrawElements.
 *
 * @param vertexData Array that contains all the vertex data.
 * @param indices Indices of the mesh.
 */
-(id)initWithVertexData:(CGFloatArray*)vertexData indices: (CGFloatArray*)indices;

/**
 * An array with all the info for each vertex
 */
@property(strong,readonly)CGFloatArray* vertexData;

/**
 * An array that gives a list of triangles to create, by specifying the 3 vertices that make up each triangle
 */
@property(strong,readonly)CGFloatArray* indices;

/**
 * An array that have all the possible animations that the mesh can make.
 */
@property(strong)NSMutableArray* animations;

/**
 * Indicates if the mesh can make animations
 */
@property(readonly)bool isAnimated;

/**
 * Number of frames 
 */
@property(nonatomic)int frameCount;

/**
 * Number of vertex in a frame
 */
@property(nonatomic,readonly)int vertexCount;

/**
 * Contains the stride of the vertex data. The stride is the size in bytes of all data that is necessary
 * to describe a single vertex. The vertex data is interlaced - a single array is used for all values, for example
 * for basic mesh data with position, normal and uv elements we have
 * [px0, py0, pz0, nx0, ny0, nz0, u0, v0, px1, py1, pz1, nx1, ny1, nz1, u1, v1, ... ]. If all of this data is
 * reprensented by floating point values, the stride is equal to (8 * sizeof(float)), ie 3 position, 3 normal and 2 uv.
 */
@property (nonatomic, readonly) unsigned int stride;

/**
 * Contains the offset in bytes for the position data of a vertex.
 */
@property (nonatomic) int positionOffset;

/**
 * Contains the offset in bytes for the normal data of a vertex.
 * This is used uniquely for mesh data and not for particles.
 */
@property (nonatomic) int normalOffset;

/**
 * Contains the offset in bytes for the uv data of a vertex.
 * This is used uniquely for mesh data and not for particles.
 */
@property (nonatomic) int uvOffset;

/**
 *  Draw mode [GL_TRIANGLE_STRIP, GL_TRIANGLE_FAN, GL_TRIANGLES], by default the draw mode is GL_TRIANGLES.
 */
@property (nonatomic) GLenum drawMode;

/**
 * Buffer that keep track of the vertex data in the gpu memory.
 */
-(GLuint) VBOHandler;

/**
 * VBOHandler reference.
 */
-(GLuint*) VBOHandlerRef;

/**
 * Buffer that keep track of the indices in the gpu memory.
 */
-(GLuint) indicesHandler;

/**
 * Indices handler reference.
 */
-(GLuint*) indicesHandlerRef;

@end
