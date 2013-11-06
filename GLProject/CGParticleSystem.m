//
//  CGParticleSystem.m
//  GLProject
//
//  Created by Enrique Bermudez on 28/10/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import "CGParticleSystem.h"
#import "CGShader.h"
#import "TextureManager.h"

@implementation CGDefaultParticleManager

-(void)updateParticle:(CGParticle *)particle deltaTime:(float)dt{
    particle.position = CC3VectorMake(particle.position.x + particle.movementDirection.x*dt*6
                                      , particle.position.y + particle.movementDirection.y*dt*6
                                      ,particle.position.z+ particle.movementDirection.z*dt*6);
}

@end

@interface CGParticleSystem (){
    NSMutableArray* deadParticles;
    NSTimer* emissionTimer;
    GLuint bufferHandler;
    CGShader* shader;
    float* particlesVertexData;
    
    GLuint _positionSlot;
    GLuint _colorSlot;
    GLuint _viewProjectionMatrixUniform;
    GLuint _viewMatrixUniform;
    GLuint _textureSlot;
    
}

@end

@implementation CGParticleSystem

-(id)init{
    self = [super init];
    if (self) {
        [self setupParticleSystem];
    }
    return self;
}


-(id)initWithParent:(CGNode *)parent{
    self = [super initWithParent:parent];
    if (self) {
        [self setupParticleSystem];
    }
    return self;
}


-(void)setupParticleSystem{
    
    shader = [CGShader shaderNamed:@"ParticleSystemShader"];
    _particles = [[NSMutableArray alloc] init];
    deadParticles = [[NSMutableArray alloc] init];
    _emissionRate = 0.01;
    particlesVertexData = malloc(sizeof(float)*8/*Pos+color*/);
    _particlesMaxLifeTime = 4000;
    self.particleManager = [[CGDefaultParticleManager alloc] init];
    
    float aux[8] ={0.0f,5.0f,0.0f,1.0f,  1.0f,0.0f,0.0f,1.0f};
    
    memcpy(particlesVertexData, aux, sizeof(float)*8);
    
    
    glGenBuffers(1, &bufferHandler );
    glBindBuffer(GL_ARRAY_BUFFER,bufferHandler);
    glBufferData(GL_ARRAY_BUFFER, sizeof(float)*8, particlesVertexData, GL_DYNAMIC_DRAW);
    
    self.particlesTexture = [[TextureManager sharedInstance] textureFromFileName:@"particle.png"];
    
    _textureSlot = glGetUniformLocation(shader.handler, "Texture");
    _positionSlot = glGetAttribLocation(shader.handler, "Position");
    _viewProjectionMatrixUniform = glGetUniformLocation(shader.handler, "viewProjectionMatrix");
    _viewMatrixUniform = glGetUniformLocation(shader.handler, "viewMatrix");
    _colorSlot = glGetAttribLocation(shader.handler, "sourceColor");
    
}


-(void)update:(float)dt{

    [deadParticles removeAllObjects];
    
    for (CGParticle*p in self.particles) {

        [self.particleManager updateParticle:p deltaTime:dt];
        
        if(p.timeAlive>self.particlesMaxLifeTime){
            [deadParticles addObject:p];
        }
    }
    
    for (CGParticle*p in deadParticles) {
        [self.particles removeObject:p];
    }
    
    free(particlesVertexData);
    particlesVertexData = malloc(sizeof(float)*8* [self.particles count]);
    int i = 0;
    for (CGParticle*p in self.particles) {
        particlesVertexData[0+ 8*i]=p.position.x;
        particlesVertexData[1+ 8*i]=p.position.y;
        particlesVertexData[2+ 8*i]=p.position.z;
        particlesVertexData[3+ 8*i]=1.0f;
        particlesVertexData[4+ 8*i]=p.color.r;
        particlesVertexData[5+ 8*i]=p.color.g;
        particlesVertexData[6+ 8*i]=p.color.b;
        particlesVertexData[7+ 8*i]=p.color.a;
        i++;
    }
    
    glBindBuffer(GL_ARRAY_BUFFER, bufferHandler);
    glBufferData(GL_ARRAY_BUFFER, sizeof(float)*8*[self.particles count], particlesVertexData, GL_DYNAMIC_DRAW);
    
}


-(void)emitParticle{
    //configure p
    
    if(self.particles.count>MAX_PARTICELS){
        [self.particles removeObjectAtIndex:0];
    }
    
    CGParticle* p =[[CGParticle alloc] init];
    
    CC3GLMatrix * modelMatrix = [self transformedMatrix];
    
    GLfloat* m = modelMatrix.glMatrix;
    p.position= CC3VectorMake(m[12],m[13],m[14]);
    p.startPosition= CC3VectorMake(m[12],m[13],m[14]);
    
    [self.particles addObject: p];
    
}


-(void)setEmissionRate:(float)emissionRate{
    _emissionRate = emissionRate;
    [self stopEmission];
    [self startEmission];
}


-(void)startEmission{

    emissionTimer = [NSTimer scheduledTimerWithTimeInterval:self.emissionRate target:self selector:@selector(emitParticle) userInfo:nil repeats:YES];
    
}


-(void)stopEmission{

    [emissionTimer invalidate];
    emissionTimer = nil;
}


-(void)drawWithRenderer:(CGRenderer *)renderer{

    //Draw
    
    glDepthMask(GL_FALSE);
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE);
    
   // if(shader.handler != renderer.currentShaderHandler ){
       glUseProgram(shader.handler);
    //    renderer.currentShaderHandler = shader.handler;
   // }
    
    glEnableVertexAttribArray(_positionSlot);
    glEnableVertexAttribArray(_colorSlot);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D,  self.particlesTexture .handler);
    glUniform1i(_textureSlot, 0); // el 0 se corresponde con la textura activa
    
    glBindBuffer(GL_ARRAY_BUFFER, bufferHandler);
    
    
    glUniformMatrix4fv(_viewMatrixUniform,1, 0, renderer.camera.viewMatrix.glMatrix);
    
    CC3GLMatrix * viewProjectionMatrix =  [renderer.camera.porjectionMatrix copy];
    [viewProjectionMatrix multiplyByMatrix:renderer.camera.viewMatrix];
    glUniformMatrix4fv(_viewProjectionMatrixUniform, 1, 0, viewProjectionMatrix.glMatrix);

    glVertexAttribPointer(_positionSlot, 4, GL_FLOAT, false, 8*sizeof(float), NULL);
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, false, 8*sizeof(float), (void*)(4*sizeof(float)));
    
    
    glDrawArrays(GL_POINTS, 0/*De donde arranco*/, [self.particles count]/**/);
    
    glDisableVertexAttribArray(_positionSlot);
    glDisableVertexAttribArray(_colorSlot);

    glDepthMask(GL_TRUE);
    glDisable(GL_BLEND);
    
}

-(void)dealloc{
    [self stopEmission];
}

@end
