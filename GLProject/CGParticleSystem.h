//
//  CGParticleSystem.h
//  GLProject
//
//  Created by Enrique Bermudez on 28/10/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGNode.h"
#import "CGTexture.h"
#import "CGParticle.h"

#define MAX_PARTICELS 40

@interface CGParticleSystem : CGNode 

/**
 */
@property NSMutableArray* particles;

@property(assign, nonatomic) float emissionRate;

#pragma mark -
#pragma mark Particles properties

@property float particlesMaxLifeTime; //remove

/**
 *  Particles texture.
 */
@property (strong)CGTexture* particlesTexture;

#pragma mark -

/**
 *  Updates all particles of the CGParticleSystem.
 */
-(void)update:(float)dt;

/**
 *  Adds a particle to the system.
 */
-(void)emitParticle;

/**
 *  Starts particles emission.
 */
-(void)startEmission;

/**
 *  Stops particles emission.
 */
-(void)stopEmission;

@end


@protocol CGParticleSystemManager

@required

/**
 */
-(CGParticle*)createParticleForSystem:(CGParticleSystem*)particleSystem;

/**
 */
-(void)updateParticle: (CGParticle*)particle deltaTime: (float)dt;

//-(float) maxParticleLife;

@end


@interface CGParticleSystem ()

@property id<CGParticleSystemManager> particleManager;

@end

@interface CGDefaultParticleManager : NSObject  <CGParticleSystemManager>

@end
