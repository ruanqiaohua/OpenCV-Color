//
//  OpenCVImageTool.m
//  baibao
//
//  Created by 阮巧华 on 2019/11/16.
//  Copyright © 2019 阮巧华. All rights reserved.
//

#import "OpenCVImageTool.h"
#import <opencv2/imgproc/types_c.h>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/imgproc/imgproc_c.h>

using namespace std;
using namespace cv;

@implementation OpenCVImageTool

+ (CGFloat)getTextPhotoAngle:(UIImage *)image {
    
    cv::Mat srcImage;
    UIImageToMat(image, srcImage);
    double value = CalcDegree(srcImage);
    return value;
}
/// 获取旋转后图片
+ (UIImage *)getRotateImage:(UIImage *)image degree:(CGFloat)degree {
    
    CGFloat radians = (M_PI * (-degree) / 180.0);
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,image.size.width, image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(radians);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    // backgroundColor
    CGContextSetFillColorWithColor(bitmap, [UIColor whiteColor].CGColor);
    CGContextFillRect(bitmap, CGRectMake(0, 0, rotatedSize.width, rotatedSize.height));
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, radians);
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-image.size.width / 2, -image.size.height / 2, image.size.width, image.size.height), [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

/// 获取灰色图片
+ (UIImage *)getGrayImage:(UIImage *)originImage {
    
    Mat img, grayImg, binImg;
    UIImageToMat(originImage, img);
    //灰度化
    cvtColor(img, grayImg, CV_BGR2GRAY);
    return MatToUIImage(grayImg);
}

/// 获取黑白图片
+ (UIImage *)getBlackWhiteImage:(UIImage *)originImage {
    
    Mat img, grayImg, binImg;
    UIImageToMat(originImage, img);
    // 灰度化
    cvtColor(img, grayImg, CV_BGR2GRAY);
    // 黑白
    threshold(grayImg, binImg, 128, 255, CV_THRESH_BINARY);
    return MatToUIImage(binImg);
}
//度数转换
double DegreeTrans(double theta)
{
    double res = theta / CV_PI * 180;
    return res;
}
//通过霍夫变换计算角度
double CalcDegree(const cv::Mat &srcImage)
{
    cv::Mat midImage, dstImage;

    Canny(srcImage, midImage, 50, 200, 3);
    cvtColor(midImage, dstImage, CV_GRAY2BGR);

    //通过霍夫变换检测直线
    std::vector<cv::Vec2f> lines;
    HoughLines(midImage, lines, 1, CV_PI / 180, 300, 0, 0);//第5个参数就是阈值，阈值越大，检测精度越高
    //cout << lines.size() << endl;
    NSLog(@"总共有%lu行文本",lines.size());
    //由于图像不同，阈值不好设定，因为阈值设定过高导致无法检测直线，阈值过低直线太多，速度很慢
    //所以根据阈值由大到小设置了三个阈值，如果经过大量试验后，可以固定一个适合的阈值。

    if (!lines.size())
    {
        HoughLines(midImage, lines, 1, CV_PI / 180, 200, 0, 0);
    }
    //cout << lines.size() << endl;

    if (!lines.size())
    {
        HoughLines(midImage, lines, 1, CV_PI / 180, 150, 0, 0);
    }
    //cout << lines.size() << endl;
    if (!lines.size())
    {
        return 0;
    }

    float sum = 0;
    
    for (size_t i = 0; i < lines.size(); i++)
    {
        float theta = lines[i][1];
        //只选角度最小的作为旋转角度
        sum += theta;
    }
    
    float average = sum / lines.size(); //对所有角度求平均，这样做旋转效果会更好

    double angle = DegreeTrans(average) - 90;

    return angle;
}

+ (UIImage *)repayRedImage:(UIImage *)image {
    
    Mat img;
    UIImageToMat(image, img);
    
    Mat rbg;
    cvtColor(img, rbg, CV_RGBA2BGR);
        
    vector<Mat> channels;
    split(rbg, channels);
    Mat red = channels[2];
    Mat blue = channels[0];
    Mat green = channels[1];

    Mat red_binary;
    threshold(red, red_binary, 120, 255, CV_THRESH_BINARY);
    
    return MatToUIImage(red_binary);
}

+ (UIImage *)repayBuleImage:(UIImage *)image {
    
    Mat img;
    UIImageToMat(image, img);
    
    Mat rbg;
    cvtColor(img, rbg, CV_RGBA2BGR);
        
    vector<Mat> channels;
    split(rbg, channels);
    Mat red = channels[2];
    Mat blue = channels[0];
    Mat green = channels[1];

    Mat red_binary;
    threshold(blue, red_binary, 120, 255, CV_THRESH_BINARY);
    
    return MatToUIImage(red_binary);
}

@end
