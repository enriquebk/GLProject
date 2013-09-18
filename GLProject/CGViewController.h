//
//  CGViewController.h
//  GLProject
//
//  Created by Enrique Bermudez on 20/08/13.
//  Copyright (c) 2013 Enrique Bermudez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>



@interface CGViewController : UIViewController{

    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;
    GLuint _colorRenderBuffer;
    
    bool rotUp;
    bool rotDown;
    bool rotRight;
    bool rotLeft;
    
    bool moveFwd;
    bool moveBwd;
    bool moveRight;
    bool moveLeft;
    
}
@property (weak, nonatomic) IBOutlet UIView *glView;

- (IBAction)rotUpTouchUp:(id)sender;
- (IBAction)rotUpTouchDown:(id)sender;

- (IBAction)rotDownTouchUp:(id)sender;
- (IBAction)rotDownTouchDown:(id)sender;

- (IBAction)rotRightTouchUp:(id)sender;
- (IBAction)rotRightTouchDown:(id)sender;

- (IBAction)rotLeftTouchUp:(id)sender;
- (IBAction)rotLeftTouchDown:(id)sender;


- (IBAction)moveUpTouchUp:(id)sender;
- (IBAction)moveUpTouchDown:(id)sender;

- (IBAction)moveDownTouchUp:(id)sender;
- (IBAction)moveDownTouchDown:(id)sender;

- (IBAction)moveRightTouchUp:(id)sender;
- (IBAction)moveRightTouchDown:(id)sender;

- (IBAction)moveLeftTouchUp:(id)sender;
- (IBAction)moveLeftTouchDown:(id)sender;

@end
