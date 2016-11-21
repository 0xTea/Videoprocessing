#include "OpenCVWrapper.h"

#include <opencv2/opencv.hpp>
#import <opencv2/highgui/cap_ios.h>
#include "opencv2/imgproc/imgproc.hpp"
#include <iostream>
#include <stdio.h>
#include <stdlib.h>

#import "UIImage+OpenCV.h"

using namespace cv;
using namespace std;

@interface OpenCVWrapper () <CvVideoCameraDelegate >
{
}
@end

@implementation OpenCVWrapper {
    ViewController * viewController;
    UIImageView * imageView;
    CvVideoCamera * videoCamera;
}
+ (UIImage *)processImageWithOpenCV:(UIImage*)inputImage {
    Mat mat = [inputImage CVMat];
    
    // do your processing here
   // ...
    
    return [UIImage imageWithCVMat:mat];
}

Mat src; Mat src_gray;
int thresh = 100;
int max_thresh = 255;
RNG rng(12345);

-(id)initWithController:(ViewController*)c andImageView:(UIImageView*)iv
{
    viewController = c;
    imageView = iv;
    
    videoCamera = [[CvVideoCamera alloc] initWithParentView:imageView];
    // ... set up the camera
    videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    videoCamera.defaultFPS = 30;
    videoCamera.grayscaleMode = NO;
    videoCamera.delegate = self;
    videoCamera.switchCameras;
    videoCamera.rotateVideo = true;
    videoCamera.start;
    
    return self;
}
#ifdef __cplusplus
- (void)processImage:(Mat&)image
{
int const max_BINARY_value = 2147483647;
    int iLowH = 170;
    int iHighH = 179;
    
    int iLowS = 150;
    int iHighS = 255;
    
    int iLowV = 60;
    int iHighV = 255;
    
    Mat image_copy;
    int threshold_value = 100;
    cv::Mat dst;
    dst=image;
    cv::cvtColor(image, dst, cv::COLOR_RGB2GRAY);
    cv::Mat canny_output;
    std::vector<std::vector<cv::Point> > contours;
    std::vector<cv::Vec4i> hierarchy;
    
    
    Mat imgHSV;
    cvtColor(image, imgHSV, COLOR_BGR2HSV); //Convert the captured frame from BGR to HSV
    
    cv::RNG rng(12345);
    Mat imgThresholded;

    cv::threshold( dst, dst, 0, max_BINARY_value,cv::THRESH_OTSU );
    inRange(imgHSV, Scalar(iLowH, iLowS, iLowV), Scalar(iHighH, iHighS, iHighV), imgThresholded); //Threshold the image
    
    //morphological opening (remove small objects from the foreground)
    erode(imgThresholded, imgThresholded, getStructuringElement(MORPH_ELLIPSE, cv::Size(5, 5)) );
    dilate( imgThresholded, imgThresholded, getStructuringElement(MORPH_ELLIPSE, cv::Size(5, 5)) );
    
    //morphological closing (fill small holes in the foreground)
    dilate( imgThresholded, imgThresholded, getStructuringElement(MORPH_ELLIPSE, cv::Size(5, 5)) );
    erode(imgThresholded, imgThresholded, getStructuringElement(MORPH_ELLIPSE, cv::Size(5, 5)) );
    
    cv::Mat contourOutput = dst.clone();
    //find countours of Thresholded image
    cv::findContours(imgThresholded, contours, cv::RETR_LIST, cv:: CHAIN_APPROX_SIMPLE,cv::Point(0,0));
    
    Mat drawing = Mat::zeros(dst.size(), CV_8UC3 );
    vector<Point2f>center( contours.size() );
    vector<float>radius( contours.size() );
    vector<cv::Rect> boundRect( contours.size() );
    vector<vector<cv::Point> > contours_poly( contours.size() );
    
    for( size_t i = 0; i < contours.size(); i++ )
    { approxPolyDP( Mat(contours[i]), contours_poly[i], 3, true );
        boundRect[i] = boundingRect( Mat(contours_poly[i]) );
        minEnclosingCircle( contours_poly[i], center[i], radius[i] );
    }

    
    for( size_t i = 0; i< contours.size(); i++ )
    {
        Scalar color = Scalar(rng.uniform(0, 255), rng.uniform(0,255), rng.uniform(0,255) );
       // cv::drawContours( image, contours_poly, (int)i, color, 1, 8, vector<Vec4i>(), 0, cv::Point() );
        cv::rectangle(image, boundRect[i].tl(), boundRect[i].br(), color, 2, 8, 0 );
        //cv::circle( image, center[i], (int)radius[i], color, 2, 8, 0 );
    }
    //Draw the contours
    cv::Mat contourImage(dst.size(), CV_8UC3, cv::Scalar(0,0,0));
    cv::Scalar colors[3];
    colors[0] = cv::Scalar(0, 0, 0);
    colors[1] = cv::Scalar(0, 255, 0);
    colors[2] = cv::Scalar(0, 0, 0);
    for (size_t idx = 0; idx < contours.size(); idx++) {
        //cv::drawContours(image, contours, idx, colors[1]);
    }
   // cvtColor(image, image_copy, CV_BGRA2BGR);
    // invert image
  //  ...
}



#endif
@end
