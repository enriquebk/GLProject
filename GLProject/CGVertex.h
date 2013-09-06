//
//  Vertex.h
//  GLProject
//
//  Created by Enrique Bermudez on 24/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#ifndef GLProject_Vertex_h
#define GLProject_Vertex_h
#include <stddef.h>

//#import "CGUtils.h"

typedef float CGColor[4];


typedef enum {
    
    CGVertexType_PNTC = 0, //vertex, normal, texture coords, color - NOT IMPLEMENTED!
    CGVertexType_PCT = 1, //vertex, color, texture coords,
    CGVertexType_PNT = 2, //vertex, normal, texture coords
    CGVertexType_PNC = 3, //vertex, normal, color
    CGVertexType_PT = 4, //vertex, texture coords
    CGVertexType_PC = 5, //vertex, color
    
} CGVertexType;

typedef struct {
    float Position[3];
    float Color[4];
} CGVertex_PC;

typedef struct {
    float Position[3];
    float Normal[3];
    float Color[4];
} CGVertex_PNC;

typedef struct {
    float Position[3];
    float Normal[3];
    float TextureCoords[2];
    float Color[4];
} CGVertex_PNTC;

typedef struct {
    float Position[3];
    float TextureCoords[2];
    float Color[4];
} CGVertex_PTC;

typedef struct {
    float Position[3];
    float TextureCoords[2];
} CGVertex_PT;

typedef struct {
    float Position[3];
    float Normal[3];
    float TextureCoords[2];
} CGVertex_PNT;


size_t sizeofVertexType(CGVertexType v);

#endif
