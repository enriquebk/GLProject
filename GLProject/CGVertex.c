//
//  Vertex.h
//  GLProject
//
//  Created by Enrique Bermudez on 24/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGVertex.h" // structures ..

//#import "CGUtils.


size_t sizeofVertexType(CGVertexType v){

    switch (v) {
        case CGVertexType_PNTC:
            return sizeof(CGVertex_PNTC);
        break;
        
        case CGVertexType_PCT:
            return sizeof(CGVertex_PTC);
        break;
        
        case CGVertexType_PNT:
            return sizeof(CGVertex_PNT);
        break;
        
        case CGVertexType_PNC:
            return sizeof(CGVertex_PNC);
        break;
        
        case CGVertexType_PT:
            return sizeof(CGVertex_PT);
        break;
        
        case CGVertexType_PC:
            return sizeof(CGVertex_PC);
        break;
        
        default:
            return sizeof(CGVertex_PNT);
        break;
    }
}
