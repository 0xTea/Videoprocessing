//
//  OpenCVWrapper.h
//  VideoProcessingtest
//
//  Created by Tshepo on 2016/11/18.
//  Copyright © 2016 test. All rights reserved.
//

#ifndef OpenCVWrapper_h
#define OpenCVWrapper_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <opencv2/highgui/cap_ios.h>
@class ViewController;

@interface OpenCVWrapper : NSObject

-(id)initWithController:(ViewController*)c andImageView:(UIImageView*)iv;
+ (UIImage *)processImageWithOpenCV:(UIImage*)inputImage;

@end

#endif /* OpenCVWrapper_h */
