//
//  CGModel.h
//  GLProject
//
//  Created by Enrique Bermudez on 29/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGArray.h"


@interface CGMesh : NSObject


-(id)initWithVertexData:(CGArray*)vertexData;

-(id)initWithVertexData:(CGArray*)vertexData indices: (CGArray*)indices;

/**
 * An array with all the info for each vertex
 */
@property(readonly)GLfloat* vertexData;

/**
 * An array that gives a list of triangles to create, by specifying the 3 vertices that make up each triangle
 */
@property(readonly)GLubyte* indices;

/**
 * Number of indices
 */
@property(nonatomic)int indicesCount;

/**
 * Number of frames 
 */
@property(nonatomic)int frameCount;

/**
 * Contains the stride of the vertex data. The stride is the size in bytes of all data that is necessary
 * to describe a single vertex. The vertex data is interlaced - a single array is used for all values, for example
 * for basic mesh data with position, normal and uv elements we have
 * [px0, py0, pz0, nx0, ny0, nz0, u0, v0, px1, py1, pz1, nx1, ny1, nz1, u1, v1, ... ]. If all of this data is
 * reprensented by floating point values, the stride is equal to (8 * sizeof(float)), ie 3 position, 3 normal and 2 uv.
 */
@property (nonatomic) unsigned int stride;

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
 * Contains the offset in bytes for the color data of a vertex.
 * This is used uniquely for particle data and not for meshse.
 */
@property (nonatomic) int colorOffset;

/**
 * Contains the offset in bytes for the size data of a vertex.
 * This is used uniquely for particle data and not for meshse.
 */
@property (nonatomic) int frameSizeOffset;

/**
 *  Next frame position offset
 */
@property (nonatomic) int nextFramePosOffset;

/**
 *  Next frame normal offset
 */
@property (nonatomic) int nextFrameNormalOffset;

/**
 * Buffer that keep track of the vertex data in the gpu memory
 */
-(GLuint) VBOHandler;

/**
 * VBOHandler reference
 */
-(GLuint*) VBOHandlerRef;

/**
 * Buffer that keep track of the indices in the gpu memory
 */
-(GLuint) indicesHandler;

/**
 * indicesHandler reference
 */
-(GLuint*) indicesHandlerRef;

@end
