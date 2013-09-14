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
}
@property (weak, nonatomic) IBOutlet UIView *glView;
- (IBAction)upAction:(id)sender;
- (IBAction)downAction:(id)sender;
- (IBAction)leftAction:(id)sender;
- (IBAction)rightAction:(id)sender;
- (IBAction)rotLAction:(id)sender;
- (IBAction)rotRAction:(id)sender;

@end
